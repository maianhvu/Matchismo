//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardChoosingResult.h"
#import "FunctionalInterface.h"
#import "NSAttributedStringExtension.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

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
    
    if (result && result.cards.count > 0) {
        if (result.isMatchPerformed) {
            NSAttributedString *cardsRepresentation = [CardGameViewController stringRepresentationOfCards:result.cards];
            // Gained score
            if (result.score > 0) {
                self.cardChoosingResultLabel.attributedText = [[[[NSAttributedString alloc] initWithString:@"Matched "] attributedStringByAppendingAttributedString:cardsRepresentation] attributedStringByAppendingString:[NSString stringWithFormat:@" for %lu points!", result.score]];
            }
            // Received penalty
            else {
                self.cardChoosingResultLabel.attributedText = [cardsRepresentation attributedStringByAppendingString:[NSString stringWithFormat:@" don't match! %lu points penalty.", -result.score]];
            }
        } else {
            self.cardChoosingResultLabel.attributedText = [((Card *)result.cards.lastObject) attributedContents];
        }
    } else {
        self.cardChoosingResultLabel.text = @"";
    }
    
}

#pragma mark Deck
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

@end
