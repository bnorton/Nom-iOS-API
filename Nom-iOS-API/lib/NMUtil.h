//
//  NMUtil.h
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

#import <Foundation/Foundation.h>
#import "NMClient.h"

#define HTTPClient [NMUtil http_client]
#define HTTPQueue [NMUtil queue]

#define THUMB_UP @"1"
#define THUMB_MEH @"2"

#define RANK_BEST @"1"
#define RANK_SECOND @"2"
#define RANK_THIRD @"3"

@class AFHTTPClient, NMCurrentLocation;

@interface NMUtil : NSObject

+ (AFHTTPClient *)http_client;
+ (NSOperationQueue *)queue;

+ (NSString *)textForThumb:(NSInteger)value;

+ (NMCurrentLocation *)currentLocation;

+ (NSString *)base36Encode:(NSInteger)to_encode;
+ (NSString *)publicationToken;

@end
