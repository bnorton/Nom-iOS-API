//
//  NMCurrentUser.m
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMCurrentUser.h"

@implementation NMCurrentUser

static NSUserDefaults *defaults = nil;
static NSMutableDictionary *user = nil;

/* Load the Current user for this application launch or re-load
 * it if the NMCurrentUser changes
 */
+ (void)loadCurrentUser {
    if ([[defaults objectForKey:@"auth_token"] length] > 0) { [user setObject:[defaults objectForKey:@"auth_token"] forKey:@"auth_token"]; }
    if ([[defaults objectForKey:@"user_nid"] length] > 0)   { [user setObject:[defaults objectForKey:@"user_nid"] forKey:@"user_nid"]; }
    if ([[defaults objectForKey:@"email"] length] > 0)      { [user setObject:[defaults objectForKey:@"email"] forKey:@"email"]; }
    if ([[defaults objectForKey:@"name"] length] > 0)       { [user setObject:[defaults objectForKey:@"name"] forKey:@"name"]; }
    if ([[defaults objectForKey:@"screen_name"] length] > 0){ [user setObject:[defaults objectForKey:@"screen_name"] forKey:@"screen_name"]; }
    if ([[defaults objectForKey:@"image_url"] length] > 0)  { [user setObject:[defaults objectForKey:@"image_url"] forKey:@"image_url"]; }
    if ([[defaults objectForKey:@"created_at"] length] > 0) { [user setObject:[defaults objectForKey:@"created_at"] forKey:@"created_at"]; }
    if ([[defaults objectForKey:@"updated_at"] length] > 0) { [user setObject:[defaults objectForKey:@"updated_at"] forKey:@"updated_at"]; }
    if ([[defaults objectForKey:@"city"] length] > 0)       { [user setObject:[defaults objectForKey:@"city"] forKey:@"city"]; }
    if ([[defaults objectForKey:@"follower_count"] length] > 0){ [user setObject:[defaults objectForKey:@"follower_count"] forKey:@"follower_count"]; }
}

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;

        defaults = [NSUserDefaults standardUserDefaults];
        user = [[NSMutableDictionary alloc] initWithCapacity:20];
        [NMCurrentUser loadCurrentUser];
        [NMCurrentUser setLoggedIn];
    }
}

+ (NSDictionary *)user {
    return user;
}

+ (void)setDate:(NSDate *)date forKey:(NSString *)key {
    [NMCurrentUser setNumber:[date timeIntervalSince1970] ForKey:key];
}

+ (NSDate *)getDateForKey:(NSString *)key {
    CGFloat then = [NMCurrentUser getNumberForKey:key];
    NSDate *date_now = [NSDate date];
    CGFloat now = [date_now timeIntervalSince1970];
    return [NSDate dateWithTimeInterval:(now - then) sinceDate:date_now];
}

+ (NSString *)getStringForKey:(NSString *)key {
    return [defaults stringForKey:key];
}

+ (void)setString:(NSString *)string ForKey:(NSString *)key {
    [defaults setObject:[string copy] forKey:key];
    [defaults synchronize];
}

+ (CGFloat)getNumberForKey:(NSString *)key{
    return [defaults floatForKey:key];
}

+ (void)setNumber:(CGFloat)afloat ForKey:(NSString *)key{
    [defaults setObject:[NSNumber numberWithFloat:afloat] forKey:key];
    [defaults synchronize];
}

+ (BOOL)getBooleanForKey:(NSString *)key{
    return [defaults boolForKey:key];
}

+ (void)setBoolean:(BOOL)abool ForKey:(NSString *)key{
    [defaults setObject:[NSNumber numberWithBool:abool] forKey:key];
    [defaults synchronize];
}

/* Store the User details into the NSUserDefaults */
+ (void)setUser:(NSDictionary *)_user {
    if (_user != nil) {
        if ([[_user objectForKey:@"auth_token"] length] > 0) { [defaults setObject:[_user objectForKey:@"auth_token"] forKey:@"auth_token"]; }
        if ([[_user objectForKey:@"user_nid"] length] > 0)   { [defaults setObject:[_user objectForKey:@"user_nid"] forKey:@"user_nid"]; }
        if ([[_user objectForKey:@"email"] length] > 0)      { [defaults setObject:[_user objectForKey:@"email"] forKey:@"email"]; }
        if ([[_user objectForKey:@"name"] length] > 0)       { [defaults setObject:[_user objectForKey:@"name"] forKey:@"name"]; }
        if ([[_user objectForKey:@"screen_name"] length] > 0){ [defaults setObject:[_user objectForKey:@"screen_name"] forKey:@"screen_name"]; }
        if ([[_user objectForKey:@"image_url"] length] > 0)  { [defaults setObject:[_user objectForKey:@"image_url"] forKey:@"image_url"]; }
        if ([[_user objectForKey:@"created_at"] length] > 0) { [defaults setObject:[_user objectForKey:@"created_at"] forKey:@"created_at"]; }
        if ([[_user objectForKey:@"updated_at"] length] > 0) { [defaults setObject:[_user objectForKey:@"updated_at"] forKey:@"updated_at"]; }
        if ([[_user objectForKey:@"city"] length] > 0)       { [defaults setObject:[_user objectForKey:@"city"] forKey:@"city"]; }
        if ([[_user objectForKey:@"follower_count"] length] > 0){ [defaults setObject:[_user objectForKey:@"follower_count"] forKey:@"follower_count"]; }
        
        [defaults synchronize];
        
        [NMCurrentUser loadCurrentUser];
        [NMCurrentUser setLoggedIn];
    }
}

+ (NSDictionary *)getUser {
    return user;
}

+ (void)setLoggedIn {
    if ([user objectForKey:@"auth_token"]) {
        [NMCurrentUser setBoolean:YES ForKey:@"user_logged_in"];
        [NMCurrentUser setBoolean:YES ForKey:@"logged_in_or_connected"];
    } else {
        [NMCurrentUser setBoolean:NO ForKey:@"user_logged_in"];
        [NMCurrentUser setBoolean:NO ForKey:@"logged_in_or_connected"];
    }
}

+ (id)getObjectForKey:(NSString *)key{
    return [defaults objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key{
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

@end
