//
//  SetCard.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCard.h"
#import "FunctionalInterface.h"

@implementation SetCard

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
             [UIColor redColor],
             [UIColor greenColor],
             [UIColor purpleColor]
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
    if ([uniqueNumbers count] != 1 && [uniqueNumbers count] != 3) {
        return NO;
    }
    
    // Compare symbols
    NSArray *uniqueSymbols = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return @(card.symbol);
    }] uniqueNumbers];
    if ([uniqueSymbols count] != 1 && [uniqueSymbols count] != 3) {
        return NO;
    }
    
    // Compare shadings
    NSArray *uniqueShadings = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return @(card.shading);
    }] uniqueNumbers];
    if ([uniqueShadings count] != 1 && [uniqueShadings count] != 3) {
        return NO;
    }
    
    // Compare UIColors
    NSArray *uniqueColors = [[array map:^(id cardObj) {
        SetCard *card = (SetCard *)cardObj;
        return card.color;
    }] uniqueUsingDescription];
    if ([uniqueColors count] != 1 && [uniqueColors count] != 3) {
        return NO;
    }
    
    // Satisfied all conditions
    return YES;
}
@end
