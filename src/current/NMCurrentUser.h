//
//  NMCurrentUser.h
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMCurrentUser : NSObject

+ (NSDictionary *)user;

+ (NSString *)getStringForKey:(NSString *)key;
+ (void)setNumber:(CGFloat)num ForKey:(NSString *)key;

+ (CGFloat)getNumberForKey:(NSString *)key;
+ (void)setString:(NSString *)string ForKey:(NSString *)key;

+ (BOOL)getBooleanForKey:(NSString *)key;
+ (void)setBoolean:(BOOL)abool ForKey:(NSString *)key;

+ (void)setDate:(NSDate *)date forKey:(NSString *)key;
+ (NSDate *)getDateForKey:(NSString *)key;

+ (void)setUser:(NSDictionary *)user;
+ (NSDictionary *)getUser;

+ (void)setLoggedIn;

+ (id)getObjectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;


@end
