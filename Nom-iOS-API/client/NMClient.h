//
//  NMClient.h
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
//  Created by Brian Norton on 11/15/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "AFHTTPClient.h"
#import "NMUtil.h"

@interface NMClient : AFHTTPClient

/* ######################################################################
 * ########################### USER #####################################
 */
+ (void)registerUserEmail:(NSString *)email password:(NSString *)password screen_name:(NSString *)screen_name
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)loginIdentifier:(NSString *)email_or_screen_name password:(NSString *)password 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)meWithSuccess:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)screenNameCheck:(NSString *)screen_names success:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)userDetail:(NSString *)user_nid success:(void (^)(NSDictionary * response))success 
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)searchUser:(NSString *)identifier
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### LOCATION ##################################
 */
+ (void)here:(CGFloat)distance categories:(NSString *)categories cost:(NSString *)cost limit:(NSUInteger)limit
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)searchLocation:(NSString *)identifier location:(NSString *)location
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### THUMBS ####################################
 */
+ (void)thumbLocation:(NSString *)location_nid value:(NSString *)value
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)thumbUser:(NSString *)their_user_nid value:(NSString *)value
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### PUBLISHING ################################
 */
+ (void)rank:(NSString *)location_nid value:(NSString *)rank_value facebook:(BOOL)facebook
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)removeRank:(NSString *)rank_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)recommend:(NSString *)location_nid imageNid:(NSString *)image_nid 
             text:(NSString *)text facebook:(BOOL)facebook token:(NSString *)token
          success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### FOLLOWERS #################################
 */

+ (void)follow:(NSString *)other_user_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)unFollow:(NSString *)other_user_nid 
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)followersFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure;

+ (void)followingFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### COMMENTS ##################################
 */

+ (void)commentAboutLocation:(NSString *)location_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentOnUser:(NSString *)about_user_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentOnRecommendation:(NSString *)recommendation_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

+ (void)commentDestroy:(NSString *)comment_nid
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

/* #######################################################################
 * ########################### ACTIVITIES ################################
 */

+ (void)activitiesWithSuccess:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure;

+ (void)usersActivities:(NSString *)user withSuccess:(void (^)(NSDictionary * response))success
                        failure:(void (^)(NSDictionary * response))failure;

+ (void)imageUpload:(NSString *)location_nid
            success:(void (^)(NSDictionary * response))success
            failure:(void (^)(NSDictionary * response))failure
           progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress;

+ (void)imageFetch:(id)image_path;

/* #######################################################################
 * ########################### MISC ######################################
 */
+ (void)categoriesWithSuccess:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure;

@end
