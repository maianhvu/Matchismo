//
//  SetCard.h
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "Card.h"
#import <UIKit/UIColor.h>

typedef NS_ENUM(NSInteger, SetCardSymbol) {
    SetCardSymbolTriangle,
    SetCardSymbolCircle,
    SetCardSymbolSquare
};

typedef NS_ENUM(NSInteger, SetCardShading) {
    SetCardShadingSolid,
    SetCardShadingStriped,
    SetCardShadingOpen
};


@interface SetCard : Card

@property (nonatomic, readonly) NSUInteger number;
@property (nonatomic, readonly) SetCardSymbol symbol;
@property (nonatomic, readonly) SetCardShading shading;
@property (nonatomic, strong, readonly) UIColor *color;

// Designated initializer
- (instancetype)initWithNumber:(NSUInteger)number
                    withSymbol:(SetCardSymbol)symbol
                   withShading:(SetCardShading)shading
                     withColor:(UIColor *)color;

+ (NSUInteger)maxNumber;
+ (NSArray *)validColors; // of UIColor
@end
