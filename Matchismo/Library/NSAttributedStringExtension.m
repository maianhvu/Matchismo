//
//  NSAttributedStringExtension.m
//  Matchismo
//
//  Created by Anh Vu Mai on 22/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "NSAttributedStringExtension.h"
#import "FunctionalInterface.h"

@implementation NSAttributedString (NSAttributedStringExtension)

- (NSAttributedString *)attributedStringByAppendingString:(NSString *)string
{
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", self.string, string]];
    
    // Run from the start of the attributed string until the end to copy attributes
    [NSAttributedString copyAttributesFrom:self
                           startingAtIndex:0
                                        to:finalString
                           startingAtIndex:0
                                 forLength:self.length];
    
    return finalString;
}

- (NSAttributedString *)attributedStringByAppendingAttributedString:(NSAttributedString *)string
{
    NSMutableAttributedString *combined = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", self.string, string.string]];
    // Copy attributes from both
    [NSAttributedString copyAttributesFrom:self
                           startingAtIndex:0
                                        to:combined
                           startingAtIndex:0
                                 forLength:self.length];
    [NSAttributedString copyAttributesFrom:string
                           startingAtIndex:0
                                        to:combined
                           startingAtIndex:self.length
                                 forLength:string.length];
    
    return combined;
}

+ (NSAttributedString *)attributedStringByJoiningComponents:(NSArray *)components // of NSAttributedString or NSString
                                                usingString:(NSString *)glue
{
    // Empty attributed string
    if (!components.count) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    components = [components filter:^(id object) {
        return (BOOL) ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSAttributedString class]]);
    }];
    
    NSInteger totalStringLength = [[components map:^(id component) {
        if ([component isKindOfClass:[NSString class]]) {
            return @(((NSString *)component).length);
        } else if ([component isKindOfClass:[NSAttributedString class]]) {
            return @(((NSAttributedString *)component).string.length);
        }
        return @0;
    }] integerSum];
    totalStringLength += glue.length * (components.count - 1);
    
    // Initialize the entire string
    NSMutableString *joinedString = [[NSMutableString alloc] initWithCapacity:totalStringLength];
    BOOL isFirst = YES;
    for (id object in components) {
        if (isFirst) {
            isFirst = NO;
        } else {
            [joinedString appendString:glue];
        }
        
        if ([object isKindOfClass:[NSString class]]) {
            [joinedString appendString:(NSString *)object];
        } else if ([object isKindOfClass:[NSAttributedString class]]) {
            [joinedString appendString:((NSAttributedString *)object).string];
        }
    }
    
    // Initialize the attributed string
    NSMutableAttributedString *joinedAttributedString = [[NSMutableAttributedString alloc] initWithString:joinedString];
    NSUInteger stringIndex = 0;
    NSUInteger componentIndex = 0;
    
    // Copy attributes from individual components
    while (stringIndex < joinedString.length && componentIndex < components.count) {
        NSString *componentString = components[componentIndex];
        
        if ([componentString isKindOfClass:[NSAttributedString class]]) {
            // Copy attributes
            [NSAttributedString copyAttributesFrom:(NSAttributedString *)componentString
                                   startingAtIndex:0
                                                to:joinedAttributedString
                                   startingAtIndex:stringIndex
                                         forLength:componentString.length];
        }
        
        // Go to next component
        componentIndex++;
        stringIndex += componentString.length;
        
        // Add glue
        stringIndex += glue.length;
    }
    
    return joinedAttributedString;
}


#pragma mark - Helper Methods
+ (void)copyAttributesFrom:(NSAttributedString *)source
           startingAtIndex:(NSUInteger)sourceStart
                        to:(NSMutableAttributedString *)destination
           startingAtIndex:(NSUInteger)destinationStart
                 forLength:(NSUInteger)length
{
    NSUInteger index = sourceStart;
    
    while (index - sourceStart < length) {
        NSRange remainingRange = NSMakeRange(index, length + sourceStart - index);
        
        NSRange effectiveRange;
        NSDictionary *attributes = [source attributesAtIndex:index
                                       longestEffectiveRange:&effectiveRange
                                                     inRange:remainingRange];
        
        if (effectiveRange.length == 0) {
            // Nothing to see 'ere, continue
            index++;
            continue;
        }
        
        NSRange destRange = NSMakeRange(destinationStart + index - sourceStart, effectiveRange.length);
        // Set all attributes for the effective range
        [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if (![key isKindOfClass:[NSString class]]) {
                return;
            }
            [destination addAttribute:((NSString *)key) value:value range:destRange];
        }];
        
        index += effectiveRange.length;
    }
}

@end
