//
//  PlayingCard.m
//  Matchismo
//
//  Created by Anh Vu Mai on 5/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import "PlayingCard.h"

int square(int x) {
    return x * x;
}

static int const BONUS_SAME_RANK = 4;
static int const BONUS_SAME_SUIT = 1;

@implementation PlayingCard

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♠", @"♣", @"♥", @"♦"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",
             @"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards
{
    NSArray *allCards = [otherCards arrayByAddingObject:self];
    int sameRankCardsCount = [PlayingCard countCardsOfSameRanksFromArray:allCards];
    int sameSuitCardsCount = [PlayingCard countCardsOfSameSuitsFromArray:allCards];
    return square(sameRankCardsCount) * BONUS_SAME_RANK
        + square(sameSuitCardsCount) * BONUS_SAME_SUIT;
}

+ (int)countCardsOfSameRanksFromArray:(NSArray *)cards // of PlayingCards
{
    NSArray *cardsSortedByRanks = [cards sortedArrayUsingComparator:^(id card1, id card2) {
        NSAssert([card1 isKindOfClass:[PlayingCard class]], @"The first card must be a PlayingCard");
        NSAssert([card2 isKindOfClass:[PlayingCard class]], @"The second card must be a PlayingCard");
        
        PlayingCard *playingCard1 = card1;
        PlayingCard *playingCard2 = card2;
        
        return [[NSNumber numberWithInteger:playingCard1.rank] compare:[NSNumber numberWithInteger:playingCard2.rank]];
    }];
    
    PlayingCard *previousCard = nil;
    int duplicates = 0;
    for (PlayingCard *card in cardsSortedByRanks) {
        if (previousCard && card.rank == previousCard.rank) {
            duplicates++;
        }
        previousCard = card;
    }
    return duplicates;
}

+ (int)countCardsOfSameSuitsFromArray:(NSArray *)cards // of PlayingCards
{
    NSArray *cardsSortedBySuits = [cards sortedArrayUsingComparator: ^(id card1, id card2) {
        PlayingCard *playingCard1 = card1;
        PlayingCard *playingCard2 = card2;
        return [playingCard1.suit compare:playingCard2.suit];
    }];
    
    PlayingCard *previousCard = nil;
    int duplicates = 0;
    for (PlayingCard *card in cardsSortedBySuits) {
        if (previousCard && [card.suit isEqualToString:previousCard.suit]) {
            duplicates++;
        }
        previousCard = card;
    }
    
    return duplicates;
}

- (NSString *)description {
    return [self contents];
}

@end
    
