//
//  SetCardView.h
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic,getter=isHighlighted) BOOL highlighted;
@property (nonatomic,getter=isFadedOut) BOOL fadedOut;

- (void)setCard:(SetCard *)card;

@end
