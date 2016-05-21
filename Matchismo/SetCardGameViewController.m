//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize button recognizers
    for (NSUInteger cardIndex = 0; cardIndex < self.cardButtons.count; cardIndex++) {
        id buttonView = [self.cardButtons objectAtIndex:cardIndex];
        if ([buttonView isKindOfClass:[SetCardView class]]) {
            SetCardView *button = buttonView;
            
            if ([[self.game cardAtIndex:cardIndex] isKindOfClass:[SetCard class]]) {
                button.card = (SetCard *) [self.game cardAtIndex:cardIndex];
            }
            
            [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapButtonWithRecognizer:)]];
        }
    }
    
    [self updateUI];
}

- (CardMatchingGame *)game
{
    CardMatchingGame *cardGame = [super game];
    cardGame.gameMode = CardGameModeMatch3;
    return cardGame;
}

#pragma mark - Actions
- (void)didTapButtonWithRecognizer:(UITapGestureRecognizer *)recognizer
{
    // Verify that it is indeed a SetCardView that was tapped
    if (![recognizer.view isKindOfClass:[SetCardView class]]) {
        return;
    }
    
    SetCardView *cardView = (SetCardView *) recognizer.view;
    // Find out the index of the card among the views
    NSUInteger cardIndex = [self.cardButtons indexOfObject:cardView];
    
    // Cannot find the button
    if (cardIndex == NSNotFound) {
        return;
    }
    
    // Ignore matched cards
    if (cardView.isFadedOut) {
        return;
    }
    
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

#pragma mark - Overridden methods
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    // Update card views' appearances
    for (NSUInteger cardIndex = 0; cardIndex < self.cardButtons.count; cardIndex++) {
        if ([self.cardButtons[cardIndex] isKindOfClass:[SetCardView class]]) {
            SetCardView *cardView = (SetCardView *) self.cardButtons[cardIndex];
            SetCard *card = (SetCard *) [self.game cardAtIndex:cardIndex];
            [cardView setCard:card];
            
            if ([self.game.previousChoosingResult.cards containsObject:card]) {
                cardView.highlighted = YES;
            }
        }
    }
    
    [super updateUI];
}

@end
