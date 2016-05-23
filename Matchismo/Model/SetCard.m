//
//  SetCard.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCard.h"
#import "FunctionalInterface.h"

static CGFloat const SYMBOL_STROKE_WIDTH = 7.0;

@interface SetCard ()

@end

@implementation SetCard

@synthesize attributedContents = _attributedContents;

#pragma mark - Initialization
- (instancetype)initWithNumber:(NSUInteger)number
                    withSymbol:(SetCardSymbol)symbol
                   withShading:(SetCardShading)shading
                     withColor:(UIColor *)color
{
    if (![SetCard isValidCardNumber:number] ||
        ![SetCard isValidColor:color]) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        _number = number;
        _symbol = symbol;
        _shading = shading;
        _color = color;
    }

    return self;
}

#pragma mark - Validation
+ (BOOL)isValidCardNumber:(NSUInteger)number
{
    return number >= 1 && number <= [SetCard maxNumber];
}

+ (BOOL)isValidColor:(UIColor *)color
{
    return [[SetCard validColors] containsObject:color];
}

#pragma mark - Allowed Parameter Values
+ (NSUInteger)maxNumber
{
    return 3;
}

+ (NSArray *)validColors // of UIColor
{
    
    return @[
             [UIColor colorWithRed:1.0 green:0.314 blue:0.314 alpha:1.0], // Red
             [UIColor colorWithRed:0.918 green:0.678 blue:0.0 alpha:1.0], // Yellow
             [UIColor colorWithRed:0.153 green:0.698 blue:1.0 alpha:1.0]  // Blue
             ];
}

#pragma mark - Functionality

- (int)match:(NSArray *)otherCards
{
    NSArray *allCards = [otherCards arrayByAddingObject:self];
    if ([SetCard isASet:allCards]) {
        return 1;
    } else {
        return 0;
    }
}


+ (BOOL)isASet:(NSArray *)array
{
    // Compare numbers
    NSArray *uniqueNumbers = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return @(card.number);
    }] uniqueNumbers];
    if (uniqueNumbers.count != 1 && uniqueNumbers.count != 3) {
        return NO;
    }
    
    // Compare symbols
    NSArray *uniqueSymbols = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return @(card.symbol);
    }] uniqueNumbers];
    if (uniqueSymbols.count != 1 && uniqueSymbols.count != 3) {
        return NO;
    }
    
    // Compare shadings
    NSArray *uniqueShadings = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return @(card.shading);
    }] uniqueNumbers];
    if (uniqueShadings.count != 1 && uniqueShadings.count != 3) {
        return NO;
    }
    
    // Compare UIColors
    NSArray *uniqueColors = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return card.color;
    }] uniqueUsingDescription];
    if (uniqueColors.count != 1 && uniqueColors.count != 3) {
        return NO;
    }
    
    // Satisfied all conditions
    return YES;
}

#pragma mark - Contents
- (NSString *)contents
{
    return @"";
}

- (NSAttributedString *)attributedContents
{
    if (!_attributedContents) {
        NSString *symbolRepresentation = [self stringRepresentationForSymbol];
        NSString *unstyledContents = [NSString stringWithFormat:@"%lu%@", self.number, symbolRepresentation];
        
        NSRange numberRange = NSMakeRange(0,
                                          unstyledContents.length - symbolRepresentation.length);
        NSRange symbolRange = NSMakeRange(unstyledContents.length - symbolRepresentation.length,
                                          symbolRepresentation.length);
        
        NSMutableAttributedString *styledContents = [[NSMutableAttributedString alloc] initWithString:unstyledContents];
        
        // Set color for the number
        [styledContents addAttribute:NSForegroundColorAttributeName value:self.color range:numberRange];
        
        switch (self.shading) {
            case SetCardShadingSolid:
                [styledContents addAttribute:NSForegroundColorAttributeName value:self.color range:symbolRange];
                break;
            case SetCardShadingStriped:
                [styledContents addAttribute:NSStrikethroughStyleAttributeName
                                       value:@(NSUnderlineStyleDouble)
                                       range:symbolRange];
                [styledContents addAttribute:NSStrikethroughColorAttributeName value:self.color range:symbolRange];
            case SetCardShadingOpen:
                [styledContents addAttribute:NSStrokeColorAttributeName value:self.color range:symbolRange];
                [styledContents addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:symbolRange];
                
                [styledContents addAttribute:NSStrokeWidthAttributeName value:@(SYMBOL_STROKE_WIDTH) range:symbolRange];
                break;
        }
        _attributedContents = styledContents;
    }
    
    return _attributedContents;
}

- (NSString *)stringRepresentationForSymbol
{
    switch (self.symbol) {
        case SetCardSymbolTriangle:
            return @"▲";
        case SetCardSymbolCircle:
            return @"●";
        case SetCardSymbolSquare:
            return @"■";
    }
}
@end
