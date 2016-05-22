//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardChoosingResult.h"
#import "CardGameHistoryViewController.h"
#import "FunctionalInterface.h"
#import "NSAttributedStringExtension.h"

static NSString *const SEGUE_ID_SHOW_HISTORY = @"Show History";

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) NSMutableArray *cardChoosingHistory;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    self.playerStartedGame = NO;
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           withDeck:[self createDeck]];
    return _game;
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    _game = nil;
    _cardChoosingHistory = nil;
    self.playerStartedGame = NO;
    // Reset all card to face down
    [self updateUI];
}

- (void)updateUI
{
    // Update score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int) self.game.score];
    
    // Update previous choosing result if any
    CardChoosingResult *result = self.game.previousChoosingResult;
    NSAttributedString *cardChoosingResultString;
    
    if (result) {
        if (result.cards.count == 0) {
            cardChoosingResultString = [[NSAttributedString alloc] initWithString:@"Unpicked card."];
        } else if (result.isMatchPerformed) {
            NSAttributedString *cardsRepresentation = [CardGameViewController stringRepresentationOfCards:result.cards];
            // Gained score
            if (result.score > 0) {
                cardChoosingResultString = [[[[NSAttributedString alloc] initWithString:@"Matched "] attributedStringByAppendingAttributedString:cardsRepresentation] attributedStringByAppendingString:[NSString stringWithFormat:@" for %lu points!", result.score]];
            }
            // Received penalty
            else {
                cardChoosingResultString = [cardsRepresentation attributedStringByAppendingString:[NSString stringWithFormat:@" don't match! %lu points penalty.", -result.score]];
            }
        } else {
            // Normal flip up, no match performed
            Card *lastCard = result.cards.lastObject;
            NSAttributedString *lastCardContent = [lastCard attributedContents];
            cardChoosingResultString = [[[[NSAttributedString alloc] initWithString:@"Picked "]
                                        attributedStringByAppendingAttributedString:lastCardContent]
                                        attributedStringByAppendingString:@"."];
        }
    }
    
    if (cardChoosingResultString) {
        self.cardChoosingResultLabel.attributedText = cardChoosingResultString;
        // Add to history
        [self.cardChoosingHistory addObject:cardChoosingResultString];
    } else {
        self.cardChoosingResultLabel.text = @"";
    }
    
}

#pragma mark - Deck
// abstract
- (Deck *)createDeck {
    return nil;
}

+ (NSAttributedString *)stringRepresentationOfCards:(NSArray *)cards
{
    return [NSAttributedString attributedStringByJoiningComponents:[cards map:^(id cardObj) {
        return ((Card *) cardObj).attributedContents;
    }] usingString:@" "];
}

#pragma mark - Getters

- (NSMutableArray *)cardChoosingHistory
{
    if (!_cardChoosingHistory) {
        _cardChoosingHistory = [[NSMutableArray alloc] init];
    }
    return _cardChoosingHistory;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_HISTORY] &&
        [segue.destinationViewController isKindOfClass:[CardGameHistoryViewController class]]) {
        CardGameHistoryViewController *historyVC = (CardGameHistoryViewController *)segue.destinationViewController;
        historyVC.history = self.cardChoosingHistory;
    }
}

@end
