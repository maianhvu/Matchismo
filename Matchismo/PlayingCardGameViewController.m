//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

static int const SEGMENT_ID_MATCHING_MODE_2 = 0;
static int const SEGMENT_ID_MATCHING_MODE_3 = 1;

@interface PlayingCardGameViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingModeSegmentedControl;

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateUI
{
    // Disable or enable the segmented control for when the game just started
    if (self.matchingModeSegmentedControl.enabled == self.playerStartedGame) {
        self.matchingModeSegmentedControl.enabled = !self.playerStartedGame;
    }
    
    // Select the correct segment based on the default game mode
    if (self.game.gameMode == CardGameModeMatch2) {
        self.matchingModeSegmentedControl.selectedSegmentIndex = SEGMENT_ID_MATCHING_MODE_2;
    } else if (self.game.gameMode == CardGameModeMatch3) {
        self.matchingModeSegmentedControl.selectedSegmentIndex = SEGMENT_ID_MATCHING_MODE_3;
    }
    
    // Update buttons' appearance
    for (id button in self.cardButtons) {
        if ([button isKindOfClass:[UIButton class]]) {
            UIButton *cardButton = button;
            
            int cardButtonIndex = (int) [self.cardButtons indexOfObject:cardButton];
            Card *card = [self.game cardAtIndex:cardButtonIndex];
            [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
            cardButton.enabled = !card.isMatched;
        }
    }
    
    [super updateUI];
}
#pragma mark - Matching Mode
- (IBAction)changeMatchingModeSegmentedControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == SEGMENT_ID_MATCHING_MODE_2) {
        self.game.gameMode = CardGameModeMatch2;
    } else if (sender.selectedSegmentIndex == SEGMENT_ID_MATCHING_MODE_3) {
        self.game.gameMode = CardGameModeMatch3;
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

@end
