//
//  Card.m
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
            break;
        }
    }
    
    return score;
}

- (NSAttributedString *)attributedContents
{
    if (!_attributedContents) {
        _attributedContents = [[NSAttributedString alloc] initWithString:self.contents];
    }
    return _attributedContents;
}

@end
