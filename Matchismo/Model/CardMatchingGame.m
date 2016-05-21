//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Anh Vu Mai on 14/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardMatchingGame.h"
#import "FunctionalInterface.h"

static const CardMatchingGameMode DEFAULT_GAME_MODE = CardGameModeMatch2;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 0;


@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic, readwrite) CardChoosingResult *previousChoosingResult;
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

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    // Remember choosing result
    NSArray *rememberedChosenCards = @[card];
    BOOL isMatchPerformed = NO;
    NSInteger scoreOffset = 0;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            // Flip the card over
            card.chosen = NO;
            // Since we flipped it over it's no longer considered a choice
            rememberedChosenCards = @[];
        } else {
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                // Skip matched cards
                if (otherCard.isMatched) {
                    continue;
                }
                
                // Do not consider cards that were included in the previous choosing
                // if it was a match
                if (self.previousChoosingResult.isMatchPerformed &&
                    [self.previousChoosingResult.cards containsObject:otherCard]) {
                    // Unchoose card (flip it back down) and continue
                    otherCard.chosen = NO;
                    continue;
                }
                
                if (otherCard.isChosen) {
                    [chosenCards addObject:otherCard];
                }
            }
            
            if ([self sufficesForMatchingWithCardsCount: (int)chosenCards.count + 1]) {
                isMatchPerformed = YES;
            
                int score = [card match:chosenCards];
                NSArray *allCards = [chosenCards arrayByAddingObject:card];
                void (^cardAction)(id) = nil;
                
                if (score) {
                    scoreOffset = score * MATCH_BONUS;
                    // Make all cards be matched and chosen
                    cardAction = ^(id cardObject) {
                        Card *card = (Card *)cardObject;
                        card.matched = YES;
                        card.chosen = YES;
                    };
                } else {
                    scoreOffset = -MISMATCH_PENALTY;
                    // Unselect all cards
                    cardAction = ^(id cardObject) {
                        Card *card = (Card *)cardObject;
                        card.chosen = NO;
                    };
                }
                [allCards forEach:cardAction];
                
                // Remember card choices
                rememberedChosenCards = [chosenCards arrayByAddingObject:card];
            } else {
                // Just choose the card
                card.chosen = YES;
            }
            
            self.score += scoreOffset - COST_TO_CHOOSE;
            
        }
        
        // Save previous match
        self.previousChoosingResult = [[CardChoosingResult alloc] initWithCards:rememberedChosenCards
                                                             withMatchPerformed:isMatchPerformed
                                                                      withScore:scoreOffset];
    }
}

- (BOOL)sufficesForMatchingWithCardsCount:(int)cardsCount
{
    return (self.gameMode == CardGameModeMatch2 && cardsCount >= 2) ||
           (self.gameMode == CardGameModeMatch3 && cardsCount >= 3);
}

@end
