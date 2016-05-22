//
//  CardGameHistoryViewController.m
//  Matchismo
//
//  Created by Anh Vu Mai on 22/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "CardGameHistoryViewController.h"
#import "NSAttributedStringExtension.h"

static NSString *const MESSAGE_HISTORY_EMPTY = @"Moves history is empty.";

@interface CardGameHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *historyTextView;

@end

@implementation CardGameHistoryViewController

- (void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.history && self.history.count > 0) {
        NSAttributedString *fullHistory = [NSAttributedString attributedStringByJoiningComponents:self.history                                                                            usingString:@"\n\n"];
        self.historyTextView.attributedText = fullHistory;
    } else {
        self.historyTextView.text = MESSAGE_HISTORY_EMPTY;
    }
}

// Fix UITextView text doesn't start at top bug
- (void)viewDidLayoutSubviews {
    [self.historyTextView setContentOffset:CGPointZero animated:NO];
}

@end
