//
//  NSNull+additions.m
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
//  Created by Brian Norton on 11/24/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

/* These additions are needed (or desired) since the parsing or null from
 * JSON can result in "<null>" which is an NSNull, so in favor of checking
 * explicitly for the NSNull case the developer is free to cehck for things
 * like [item length] > 0 which now works without extra effort.
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
