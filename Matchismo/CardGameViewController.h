//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

// Abstract class
@interface CardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) BOOL playerStartedGame;

// Abstract method. Must override
- (Deck *)createDeck;

// Protected
- (void)updateUI;

@end

