//
//  NSAttributedStringExtension.h
//  Matchismo
//
//  Created by Anh Vu Mai on 22/5/16.
//  Copyright © 2016 Anh Vu Mai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (NSAttributedStringExtension)

- (NSAttributedString *)attributedStringByAppendingAttributedString:(NSAttributedString *)string;
- (NSAttributedString *)attributedStringByAppendingString:(NSString *)string;

+ (NSAttributedString *)attributedStringByJoiningComponents:(NSArray *)components // of NSAttributedString or NSString
                                                usingString:(NSString *)glue;
@end
