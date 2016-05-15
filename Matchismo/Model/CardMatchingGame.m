//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Anh Vu Mai on 14/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardMatchingGame.h"

static const CardMatchingGameMode DEFAULT_GAME_MODE = CardGameModeMatch3;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Cards
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                         withDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        // Set default properties
        _gameMode = DEFAULT_GAME_MODE;
        
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
            }
        }
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            // Flip the card over
            card.chosen = NO;
        } else {
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    [chosenCards addObject:otherCard];
                }
            }
            
            if ([self sufficesForMatchingWithCardsCount: (int)chosenCards.count + 1]) {
                int score = [card match:chosenCards];
                if (score) {
                    self.score += score * MATCH_BONUS;
                    // Make all cards be matched
                    for (Card *otherCard in chosenCards) {
                        otherCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    // Flip down all cards except the current one
                    for (Card *otherCard in chosenCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
        }
    }
    
    card.chosen = YES;
    self.score -= COST_TO_CHOOSE;
}

- (BOOL)sufficesForMatchingWithCardsCount:(int)cardsCount
{
    return (self.gameMode == CardGameModeMatch2 && cardsCount >= 2) ||
           (self.gameMode == CardGameModeMatch3 && cardsCount >= 3);
}

@end
