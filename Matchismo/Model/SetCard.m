//
//  SetCard.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCard.h"

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

@end
