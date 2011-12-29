//
//  NSNull+additions.m
//
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

/* These additions are needed (or desired) since the parsing or null from
 * JSON can result in "<null>" which is an NSNull, so in favor of checking
 * explicitly for the NSNull case the developer is free to cehck for things
 * like [item length] > 0 whick now works without extra effort.
 */

#import "NSNull+additions.h"

@implementation NSNull (additions)

-(NSUInteger)length {
    return 0;
}

- (BOOL)isEqualToString:(NSString *)aString {
    return [aString isKindOfClass:[NSNull class]] ? YES : NO;
}

- (CGFloat)floatValue {
    return 0.0f;
}
@end
