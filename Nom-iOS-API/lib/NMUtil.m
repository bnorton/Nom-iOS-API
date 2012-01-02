//
//  NMUtil.m
//
// Copyright (c) 2012 Nom (http://justnom.it)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in 
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to 
// do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMUtil.h"
#import "AFHTTPClient.h"
#import "NMCurrentLocation.h"
#import "AFJSONRequestOperation.h"

@implementation NMUtil

static AFHTTPClient *sharedClient = nil;
static NSOperationQueue *sharedQueue = nil;
static NSDateFormatter *_date_formatter;
static NMCurrentLocation *_currentLocation;

- (id)init {
    self = [super init];
    if (! self) { return nil; }
    
    return self;
}

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;

        sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://justnom.it"]];
        sharedQueue = [[NSOperationQueue alloc] init];

        _currentLocation = [[NMCurrentLocation alloc] init];
        [_currentLocation startUpdating];
    }
}

/**
 * Methods that wrap the parameters themselves
 */

+ (AFHTTPClient *)http_client {
    return sharedClient;
}

+(NSOperationQueue *)queue {
    return sharedQueue;
}

+ (NMCurrentLocation *)currentLocation {
    return _currentLocation;
}

+ (NSString *)base36Encode:(NSInteger)to_encode {
    NSString *alpha = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *result = @"";
    int mod;
    while (to_encode > 0) {
        mod = to_encode % 36;
        to_encode = to_encode / 36;
        result = [NSString stringWithFormat:@"%c%@", [alpha characterAtIndex:mod], result];
    }
    return result;
}

+ (NSString *)publicationToken {
    int r = abs((int)arc4random() % (int)pow(36, 10));
    return [NMUtil base36Encode:r];
}

+ (NSString *)textForThumb:(NSInteger)value {
    if (value == 1) {
        return @"a thumb up";
    } else if (value == 2) {
        return @"meh";
    }
    return nil;
}

@end
