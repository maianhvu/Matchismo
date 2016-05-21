//
//  FunctionalInterface.m
//  Matchismo
//
//  Created by Anh Vu Mai on 21/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <Foundation/NSString.h>
#import "FunctionalInterface.h"

@implementation NSArray (FunctionalInterface)

- (NSArray *)map:(id (^)(id))transform
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    [self forEach:^(id object) {
        id transformed = transform(object);
        if (transformed) {
            [result addObject:transformed];
        }
    }];
    return result;
}

- (NSArray *)filter:(BOOL (^)(id))predicate
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self forEach:^(id object){
        if (predicate(object)) {
            [result addObject:object];
        }
    }];
    return result;
}

- (NSArray *)uniqueUsingComparator:(NSComparisonResult (^)(id, id))comparator
{
    NSArray *sorted = [self sortedArrayUsingComparator:comparator];
    id previous = nil;
    NSMutableArray *unique = [[NSMutableArray alloc] init];
    
    for (id object in sorted) {
        if (!previous || ![object isEqual:previous]) {
            [unique addObject:object];
        }
        previous = object;
    }
    
    return unique;
}

- (NSArray *)uniqueNumbers
{
    return [self uniqueUsingComparator:^(id element1, id element2) {
        NSNumber *number1 = (NSNumber *)element1;
        NSNumber *number2 = (NSNumber *)element2;
        return [number1 compare:number2];
    }];
}

- (NSArray *)uniqueUsingDescription
{
    return [self uniqueUsingComparator:^(id element1, id element2) {
        return [[element1 description] compare:[element2 description]];
    }];
}

- (void)forEach:(void (^)(id))consumer
{
    for (id object in self) {
        consumer(object);
    }
}

@end
