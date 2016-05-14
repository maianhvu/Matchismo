//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Anh Vu Mai on 14/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardMatchingGame.h"

static const CardMatchingGameMode DEFAULT_GAME_MODE = CardGameModeMatch3;

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, strong) NSMutableArray *chosenCards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
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

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    // Only allow unmatched cards to be chosen
    if (!card.isMatched) {
        // Flip over chosen card
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // Add the current card to the array of chosen cards
            [self.chosenCards addObject:card];
           
            // Calculate match score if condition for matching fulfils
            if ([self hasHitChosenCardsLimit]) {
                NSInteger matchScore = [self calculateMatchScore];
                if (matchScore) {
                    self.score += matchScore;
                    for (Card *card in self.chosenCards) {
                        card.matched = YES;
                    }
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *card in self.chosenCards) {
                        card.chosen = NO;
                    }
                }
                // Erase the chosen cards
                _chosenCards = nil;
            } else {
                // Just mark the card as chosen and move on
                card.chosen = YES;
            }
            
            self.score -= COST_TO_CHOOSE;
        }
    }
}

- (BOOL)hasHitChosenCardsLimit
{
    return (self.gameMode == CardGameModeMatch2 && self.chosenCards.count >= 2) ||
           (self.gameMode == CardGameModeMatch3 && self.chosenCards.count >= 3);
}

- (NSInteger)calculateMatchScore
{
    return 0; // TODO: Stub
}

@end
