//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
            for (NSNumber *symbolNumber in [SetCardDeck validSetCardSymbols]) {
                SetCardSymbol symbol = (SetCardSymbol) [symbolNumber integerValue];
                for (NSNumber *shadingNumber in [SetCardDeck validSetCardShadings]) {
                    SetCardShading shading = (SetCardShading) [shadingNumber integerValue];
                    for (UIColor *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] initWithNumber:number withSymbol:symbol withShading:shading withColor:color];
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

+ (NSArray *)validSetCardSymbols // of SetCardSymbol
{
    return @[
             @(SetCardSymbolTriangle),
             @(SetCardSymbolCircle),
             @(SetCardSymbolSquare)
             ];
}

+ (NSArray *)validSetCardShadings // of SetCardShading
{
    return @[
             @(SetCardShadingSolid),
             @(SetCardShadingStriped),
             @(SetCardShadingOpen)
             ];
}

@end
