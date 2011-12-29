//
//  NMUtil.m
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

+ (NMCurrentLocation *)NMCurrentLocation {
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
