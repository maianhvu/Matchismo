//
//  SetCardView.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCardView.h"

static CGFloat const CORNER_FONT_STANDARD_HEIGHT = 68.0;
static CGFloat const CORNER_RADIUS = 3.0;
static CGFloat const SYMBOL_HEIGHT_RATIO = 0.2;
static CGFloat const SYMBOL_MARGIN_RATIO = 0.075;
static CGFloat const SYMBOL_STROKE_WIDTH = 1.0;
static CGFloat const CARD_STROKE_WIDTH = 4.0;

@interface SetCardView ()

@end

@implementation SetCardView

#pragma mark - Setters

- (void)setNumber:(NSUInteger)number
{
    if (_number == number) {
        return;
    }
    
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(SetCardSymbol)symbol
{
    if (_symbol == symbol) {
        return;
    }
    
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(SetCardShading)shading
{
    if (_shading == shading) {
        return;
    }
    
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    if (_color == color) {
        return;
    }
    
    _color = color;
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted == highlighted) {
        return;
    }
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (void)setFadedOut:(BOOL)fadedOut
{
    if (_fadedOut == fadedOut) {
        return;
    }
    _fadedOut = fadedOut;
    [self setNeedsDisplay];
}

- (void)setCard:(SetCard *)card
{
    BOOL modified = NO;
    if (_number != card.number) {
        _number = card.number;
        modified = YES;
    }
    if (_symbol != card.symbol) {
        _symbol = card.symbol;
        modified = YES;
    }
    if (_shading != card.shading) {
        _shading = card.shading;
        modified = YES;
    }
    if (![_color isEqual:card.color]) {
        _color = card.color;
        modified = YES;
    }
    if (_highlighted != card.isChosen) {
        _highlighted = card.isChosen;
        modified = YES;
    }
    if (_fadedOut != card.isMatched) {
        _fadedOut = card.isMatched;
        modified = YES;
    }
    if (modified) {
        [self setNeedsDisplay];
    }
}

#pragma mark - Rendering
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    // Change display based on whether the card is chosen
    if (self.isFadedOut) {
        [[SetCardView fadedOutColor] setFill];
        UIRectFill(self.bounds);
    } else {
        CGRect whiteBackgroundRect = self.bounds;
        
        if (self.isHighlighted) {
            // Draw border
            [[SetCardView highlightColor] setFill];
            [roundedRect fill];
            // Make background rect smaller
            whiteBackgroundRect = CGRectInset(self.bounds, CARD_STROKE_WIDTH, CARD_STROKE_WIDTH);
        }
        
        [[SetCardView normalBackgroundColor] setFill];
        UIRectFill(whiteBackgroundRect);
    }
    
    [self drawSymbols];
}

- (void)drawSymbols
{
    CGPoint drawOrigin = CGPointMake([self symbolLeftMargin],
                                     [self symbolTopMarginForSymbolCount:self.number]
                                     );
    UIBezierPath *symbolPath;
    // Define path from symbol type
    switch (self.symbol) {
        case SetCardSymbolTriangle:
            symbolPath = [self makeTrianglePathAtOrigin:drawOrigin
                                         forSymbolCount:self.number];
            break;
        case SetCardSymbolCircle:
            symbolPath = [self makeCirclePathAtOrigin:drawOrigin
                                       forSymbolCount:self.number];
            break;
        case SetCardSymbolSquare:
            symbolPath = [self makeSquarePathAtOrigin:drawOrigin
                                       forSymbolCount:self.number];
            break;
        default:
            return;
    }
    
    // Stroke path first
    symbolPath.lineWidth = SYMBOL_STROKE_WIDTH;
    [self.color setStroke];
    [symbolPath stroke];
    
    // Then fill the symbol
    [symbolPath addClip];
    
    switch (self.shading) {
        case SetCardShadingOpen:
            break;
        case SetCardShadingSolid:
            [self.color setFill];
            CGRect lastRect = [self drawRectForSymbolNumber:self.number - 1
                                                 outOfTotal:self.number];
            
            UIRectFill(CGRectMake(drawOrigin.x,
                                  drawOrigin.y,
                                  lastRect.size.width,
                                  lastRect.origin.y + lastRect.size.height - drawOrigin.y));
            break;
        case SetCardShadingStriped:
            [self drawStripesAtOrigin:drawOrigin
                       forSymbolCount:self.number];
            break;
    }
}

- (UIBezierPath *)makeTrianglePathAtOrigin:(CGPoint)origin
                            forSymbolCount:(NSUInteger)symbolCount
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat symbolSize = [self symbolSize];
    CGFloat halfSize = symbolSize / 2;
    CGFloat triangleHeight = tan(M_PI / 3) * halfSize;
    CGFloat yOffset = halfSize - triangleHeight / 2;
    
    for (NSUInteger index = 0; index < symbolCount; index++) {
        
        CGPoint squareOrigin = [self drawOriginForSymbolNumber:index outOfTotal:symbolCount];
        
        // Draw triangle
        CGPoint origin = CGPointMake(squareOrigin.x + halfSize, squareOrigin.y + yOffset);
        [path moveToPoint:origin];
        [path addLineToPoint:CGPointMake(squareOrigin.x + symbolSize, squareOrigin.y + symbolSize - yOffset)];
        [path addLineToPoint:CGPointMake(squareOrigin.x, squareOrigin.y + symbolSize - yOffset)];
        [path addLineToPoint:origin];
    }
    return path;
}

- (UIBezierPath *)makeSquarePathAtOrigin:(CGPoint)origin
                          forSymbolCount:(NSUInteger)symbolCount
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (NSUInteger index = 0; index < symbolCount; index++) {
        CGRect square = [self drawRectForSymbolNumber:index outOfTotal:symbolCount];
        [path appendPath:[UIBezierPath bezierPathWithRect:square]];
    }
    
    return path;
}

- (UIBezierPath *)makeCirclePathAtOrigin:(CGPoint)origin
                          forSymbolCount:(NSUInteger)symbolCount
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    for (NSUInteger index = 0; index < symbolCount; index++) {
        CGRect square = [self drawRectForSymbolNumber:index outOfTotal:symbolCount];
        [path appendPath:[UIBezierPath bezierPathWithOvalInRect:square]];
    }
    return path;
}

- (void)drawStripesAtOrigin:(CGPoint)origin
             forSymbolCount:(NSUInteger)symbolCount
{
    UIBezierPath *lines = [[UIBezierPath alloc] init];
    CGFloat distance = SYMBOL_STROKE_WIDTH * 2;
    
    for (NSUInteger symbolIndex = 0; symbolIndex < symbolCount; symbolIndex++) {
        CGPoint symbolOrigin = CGPointMake(origin.x, origin.y + symbolIndex * ([self symbolSize] + [self symbolDistance]));
        
        for (CGFloat offset = distance; offset < [self symbolSize]; offset += distance) {
            CGFloat lineY = symbolOrigin.y + offset;
            [lines moveToPoint:CGPointMake(symbolOrigin.x, lineY)];
            [lines addLineToPoint:CGPointMake(symbolOrigin.x + [self symbolSize], lineY)];
        }
    }
    
    [lines stroke];
}

#pragma mark - Calculation Helpers
- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

- (CGFloat)symbolSize { return self.bounds.size.height * SYMBOL_HEIGHT_RATIO; }
- (CGFloat)symbolLeftMargin { return (self.bounds.size.width - [self symbolSize]) / 2; }
- (CGFloat)symbolDistance { return self.bounds.size.height * SYMBOL_MARGIN_RATIO; }
- (CGFloat)symbolTopMarginForSymbolCount:(NSUInteger)symbolCount
{
    CGFloat allSymbolsHeight = [self symbolSize] * symbolCount + [self symbolDistance] * (symbolCount - 1);
    return (self.bounds.size.height - allSymbolsHeight) / 2;
}

- (CGPoint)drawOriginForSymbolNumber:(NSUInteger)symbolNumber
                          outOfTotal:(NSUInteger)totalNumber
{
    CGFloat top = [self symbolTopMarginForSymbolCount:totalNumber];
    return CGPointMake([self symbolLeftMargin], top + symbolNumber * ([self symbolSize] + [self symbolDistance]));
}

- (CGRect)drawRectForSymbolNumber:(NSUInteger)symbolNumber
                       outOfTotal:(NSUInteger)totalNumber
{
    CGPoint origin = [self drawOriginForSymbolNumber:symbolNumber outOfTotal:totalNumber];
    return CGRectMake(origin.x, origin.y, [self symbolSize], [self symbolSize]);
}

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Colors

+ (UIColor *)fadedOutColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}
+ (UIColor *)highlightColor
{
    return [UIColor colorWithRed:0.533 green:0.792 blue:0.341 alpha:1.0];
}
+ (UIColor *)normalBackgroundColor
{
    return [UIColor whiteColor];
}

@end
