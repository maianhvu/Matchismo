//
//  FunctionalInterface.h
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <Foundation/NSArray.h>

@interface NSArray (FunctionalInterface)

- (NSArray *)map:(id (^)(id))transform;
- (NSArray *)filter:(BOOL (^)(id))predicate;

- (NSArray *)uniqueUsingComparator:(NSComparisonResult (^)(id, id))comparator;
- (NSArray *)uniqueNumbers;
- (NSArray *)uniqueUsingDescription;

- (void)forEach:(void (^)(id))consumer;

@end
