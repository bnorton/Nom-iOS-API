//
//  NSData+additions.m
//
//  Created by Brian Norton on 12/29/11.
//  Copyright (c) 2012 Nom Inc. All rights reserved.
//

/* This convenience method is for image uploads so the image has a unique (probably)
 * name and identifier in the database.
 */

#import "NSData+additions.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSData (additions)

- (NSString *)SHA1Sum {
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, self.length, digest);
    for (NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
