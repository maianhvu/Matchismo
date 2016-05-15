//
//  CardChoosingResult.h
//  Matchismo
//
//  Created by Anh Vu Mai on 15/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardChoosingResult : NSObject

@property (strong, nonatomic, readonly) NSArray *cards;
@property (nonatomic,getter=isMatchPerformed,readonly) BOOL matchPerformed;
@property (nonatomic, readonly) NSInteger score;

// Designated initializer
- (instancetype)initWithCards:(NSArray *)cards
           withMatchPerformed:(BOOL)matchPerformed
                    withScore:(NSInteger)score;

@end
