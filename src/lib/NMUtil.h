//
//  NMUtil.h
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMClient.h"

#define HTTPClient [NMUtil http_client]
#define HTTPQueue [NMUtil queue]

@class AFHTTPClient, NMCurrentLocation;

@interface NMUtil : NSObject

+ (AFHTTPClient *)http_client;
+ (NSOperationQueue *)queue;

+ (NSString *)textForThumb:(NSInteger)value;

+ (NMCurrentLocation *)currentLocation;

+ (NSString *)base36Encode:(NSInteger)to_encode;
+ (NSString *)publicationToken;

@end
