//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Anh Vu Mai on 14/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

typedef NS_ENUM(NSInteger, CardMatchingGameMode) {
    CardGameModeMatch2,
    CardGameModeMatch3
};

@interface CardMatchingGame : NSObject


// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                         withDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) CardMatchingGameMode gameMode;

@end
