//
//  CardChoosingResult.m
//  Matchismo
//
//  Created by Anh Vu Mai on 15/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardChoosingResult.h"

@implementation CardChoosingResult

- (instancetype)initWithCards:(NSArray *)cards
           withMatchPerformed:(BOOL)matchPerformed
                    withScore:(NSInteger)score
{
    self = [super init];
    
    
    if (self) {
        _cards = cards;
        _matchPerformed = matchPerformed;
        _score = score;
    }
    
    return self;
}

@end
