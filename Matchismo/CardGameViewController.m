//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

static int const SEGMENT_ID_MATCHING_MODE_2 = 0;
static int const SEGMENT_ID_MATCHING_MODE_3 = 1;

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingModeSegmentedControl;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [self updateUI];
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                           withDeck:[self createDeck]];
    return _game;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = (int) [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    _game = nil;
    // Reset all card to face down
    [self updateUI];
}

- (void)updateUI
{
    // Select the correct segment based on the default game mode
    if (self.game.gameMode == CardGameModeMatch2) {
        self.matchingModeSegmentedControl.selectedSegmentIndex = SEGMENT_ID_MATCHING_MODE_2;
    } else if (self.game.gameMode == CardGameModeMatch3) {
        self.matchingModeSegmentedControl.selectedSegmentIndex = SEGMENT_ID_MATCHING_MODE_3;
    }
    
    // Update buttons' appearance
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int) self.game.score];
    }
    
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

#pragma mark Deck

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

#pragma mark Matching Mode
- (IBAction)changeMatchingModeSegmentedControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == SEGMENT_ID_MATCHING_MODE_2) {
        self.game.gameMode = CardGameModeMatch2;
    } else if (sender.selectedSegmentIndex == SEGMENT_ID_MATCHING_MODE_3) {
        self.game.gameMode = CardGameModeMatch3;
    }
}

@end
