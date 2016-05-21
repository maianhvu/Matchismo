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

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardChoosingResultLabel;

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
            NSString *cardsRepresentation = [CardGameViewController stringRepresentationOfCards:result.cards];
            // Gained score
            if (result.score > 0) {
                self.cardChoosingResultLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points!",
                                                     cardsRepresentation, (int) result.score];
            }
            // Received penalty
            else {
                self.cardChoosingResultLabel.text = [NSString stringWithFormat:@"%@ don't match! %d points penalty.",
                                                     cardsRepresentation, (int)-result.score];
            }
        } else {
            self.cardChoosingResultLabel.text = [result.cards.lastObject contents];
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

+ (NSString *)stringRepresentationOfCards:(NSArray *)cards
{
    NSArray *contents = [cards map:^(id cardObj){
        Card* card = (Card *)cardObj;
        return [card contents];
    }];
    return [contents componentsJoinedByString:@" "];
}

@end
