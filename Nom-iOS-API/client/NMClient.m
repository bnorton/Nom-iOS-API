//
//  NMClient.m
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
//  Copyright (c) 2012 Nom Inc. All rights reserved.
//

#import "NMClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"
#import "NMCurrentLocation.h"
#import "NMCurrentUser.h"
#import "NSData+additions.h"
#import "NMUtil.h"

@implementation NMClient

+ (void)addDefaultParams:(NSMutableDictionary *)params userParams:(BOOL)user setLocation:(BOOL)location {
    /* Setup default params if we dont already have them */
    if (user) {
        if( ! [params objectForKey:@"user_nid"]) {
            NSString *user_nid = [NMCurrentUser getStringForKey:@"user_nid"];
            if (user_nid) { [params setObject:user_nid forKey:@"user_nid"]; }

            /* Add the auth_token of the user_nid comes from current_user */
            NSString *auth_token = [NMCurrentUser getStringForKey:@"auth_token"];
            if (auth_token) { [params setObject:auth_token forKey:@"auth_token"]; }
        }
    }
    /* Setup the geo-location params if we should */
    if(location) {
        NSNumber *lat = [NSNumber numberWithFloat:[[NMUtil currentLocation] lat]];
        if (lat) { [params setObject:lat forKey:@"lat"]; }

        NSNumber *lng = [NSNumber numberWithFloat:[[NMUtil currentLocation] lng]];
        if (lat) { [params setObject:lng forKey:@"lng"]; }
    }
}

+ (void)enqueueRequestWithMethod:(NSString *)method path:(NSString *)path 
                      parameters:(NSMutableDictionary *)parameters defaultParams:(BOOL)params
                         success:(void (^)(NSDictionary * response))success
                         failure:(void (^)(NSDictionary * response))failure {

    if (!parameters) { parameters = [[NSMutableDictionary alloc] initWithCapacity:4]; }

    [NMClient addDefaultParams:parameters userParams:params setLocation:YES];

    NSMutableURLRequest *request = [HTTPClient requestWithMethod:method path:path parameters:parameters];

    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
     success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        if (success) { success(JSON); }
     } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
        if (failure) { failure(JSON); }
     }];

    [HTTPQueue addOperation:operation];
}

+ (void)enqueueRequestWithMethod:(NSString *)method path:(NSString *)path 
                      parameters:(NSMutableDictionary *)parameters
                   success:(void (^)(NSDictionary * response))success
                   failure:(void (^)(NSDictionary * response))failure {

    [self enqueueRequestWithMethod:method path:path parameters:parameters defaultParams:YES success:success failure:failure];
}

/**
 * User Management
 */

+ (void)registerUserEmail:(NSString *)email password:(NSString *)password screen_name:(NSString *)screen_name
                  success:(void (^)(NSDictionary * response))success
                  failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    if (email)       { [parameters setObject:email forKey:@"email"]; }
    if (password)    { [parameters setObject:password forKey:@"password"]; }
    if (screen_name) { [parameters setObject:screen_name forKey:@"screen_name"]; }
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
}

+ (void)loginIdentifier:(NSString *)email_or_screen_name password:(NSString *)password 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:email_or_screen_name, password,nil];
    NSArray *params = [NSArray arrayWithObjects:@"email",@"password", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];

    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/login.json" parameters:parameters success:success failure:failure];
}

+(void)meWithSuccess:(void (^)(NSDictionary * response))success 
             failure:(void (^)(NSDictionary * response))failure {

    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/me.json" parameters:nil success:success failure:failure];
}

+(void)screenNameCheck:(NSString *)screen_names success:(void (^)(NSDictionary * response))success 
               failure:(void (^)(NSDictionary * response))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:screen_names forKey:@"screen_name"];
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/check.json" parameters:parameters success:success failure:failure];
}

+(void)userDetail:(NSString *)user_nid success:(void (^)(NSDictionary * response))success 
               failure:(void (^)(NSDictionary * response))failure {

    [NMClient enqueueRequestWithMethod:@"GET" path:[NSString stringWithFormat:@"/users/%@/detail.json", user_nid] parameters:nil success:success failure:failure];
}

/**
 * Location Based Services
 */

+ (void)here:(CGFloat)distance categories:(NSString *)categories cost:(NSString *)cost limit:(NSUInteger)limit
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableArray *items  = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *params = [[NSMutableArray alloc] initWithCapacity:4];

    if (distance < 0.25) { distance = 0.24f;  }
    if (distance > 5.0f) { distance = 5.01f;  }
    [items addObject:[NSString stringWithFormat:@"%f", distance]];
    [params addObject:@"dist"];

    if (limit < 6)  { limit = 6; }
    if (limit > 25) { limit = 24; }
    [items addObject:[NSString stringWithFormat:@"%d", limit]];
    [params addObject:@"limit"];

    if (categories) {
        [items addObject:[categories componentsSeparatedByString:@","]];
        [params addObject:@"categories"];
    }
    if (cost) {
        [items addObject:cost];
        [params addObject:@"cost"];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"GET" path:@"/locations/here.json" parameters:parameters success:success failure:failure];
    
}

/** Location :: Search / User :: Search */

+ (void)search:(NSString *)identifier path:(NSString *)path location:(NSString *)location
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:identifier, nil];
    NSArray *params = [NSArray arrayWithObjects:@"query", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    if (location != nil) { [parameters setObject:location forKey:@"where"]; }
    
    [NMClient enqueueRequestWithMethod:@"GET" path:path parameters:parameters success:success failure:failure];
    
}
+ (void)searchUser:(NSString *)identifier
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient search:identifier path:@"/users/search.json" location:nil success:success failure:failure];
}

+ (void)searchLocation:(NSString *)identifier location:(NSString *)location
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient search:identifier path:@"/locations/search.json" location:location success:success failure:failure];
}

/**
 * Category fetching
 */

+ (void)categoriesWithSuccess:(void (^)(NSDictionary * response))success
     failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/categories/all.json" 
                             parameters:nil success:success failure:failure];
}

+ (void)categoriesForLocation:(NSString*)location_nid 
                      success:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient enqueueRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"/locations/%@/categories.json", location_nid]
                             parameters:nil success:success failure:failure];
}

/**
 * Thumbs
 */

+ (void)thumbValue:(NSString *)value path:(NSString *)path
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:value,nil];
    NSArray *params = [NSArray arrayWithObjects:@"value",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:path parameters:parameters success:success failure:failure];
}

+ (void)thumbLocation:(NSString *)location_nid value:(NSString *)value
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient thumbValue:value path:[NSString stringWithFormat:@"/locations/%@/thumbs/create.json",location_nid] 
                success:success failure:failure];
}

+ (void)thumbUser:(NSString *)their_user_nid value:(NSString *)value
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient thumbValue:value path:[NSString stringWithFormat:@"/users/%@/thumbs/create.json",their_user_nid] 
                     success:success failure:failure];
}

/**
 * Posting to networks
 */

+ (void)publish:(NSString *)bl success:(void (^)(NSDictionary * response))success
     failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:bl,nil];
    NSArray *params = [NSArray arrayWithObjects: nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
}

/**
 * Ranking
 */

+ (void)rank:(NSString *)location_nid value:(NSString *)rank_value 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:location_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}

+ (void)removeRank:(NSString *)rank_nid 
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:rank_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"rank_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/users/register.json" parameters:parameters success:success failure:failure];
    
}

/**
 * Recommendations
 */

+ (void)recommend:(NSString *)location_nid imageNid:(NSString *)image_nid 
             text:(NSString *)text facebook:(BOOL)facebook token:(NSString *)token
                    success:(void (^)(NSDictionary * response))success
                    failure:(void (^)(NSDictionary * response))failure {

    token = token != nil ? token : [NMUtil publicationToken];
    NSArray *items  = [NSArray arrayWithObjects:location_nid, token, text,[NSNumber numberWithBool:NO], nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid", @"token", @"text", @"image_attachment_present", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];

    [self addDefaultParams:parameters userParams:YES setLocation:YES];

    if (facebook) { [parameters setObject:[NSNumber numberWithBool:facebook] forKey:@"facebook"]; }
    if (image_nid){ [parameters setObject:image_nid forKey:@"image_nid"];                         }

    /* Construct and begin the request with callbacks */
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:@"POST" path:@"/recommendation/create.json" 
                                                                   parameters:parameters 
                                                    constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                        /* Construct with Image Data */
                                                    }];

    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) { success(responseObject); }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) { failure([(AFJSONRequestOperation *)operation responseJSON]); }
    }];

    [HTTPQueue addOperation:operation];
}

/**
 * Following / Followers
 */

+ (void)followAction:(NSString *)path toUserId:(NSString *)to_user_nid 
           success:(void (^)(NSDictionary * response))success
           failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:to_user_nid, nil];
    NSArray *params = [NSArray arrayWithObjects:@"to_user_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:path parameters:parameters success:success failure:failure];
    
}

+ (void)follow:(NSString *)to_user_nid 
       success:(void (^)(NSDictionary * response))success
       failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient followAction:@"/follow/create.json" toUserId:to_user_nid success:success failure:failure];
    
}

+ (void)unFollow:(NSString *)to_user_nid 
       success:(void (^)(NSDictionary * response))success
       failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient followAction:@"/follow/destroy.json" toUserId:to_user_nid success:success failure:failure];
    
}

+ (void)followFor:(NSString *)user_nid path:(NSString *)path success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure {
    
    NSMutableDictionary *params = nil;
    if ( ! [user_nid isEqualToString:[NMCurrentUser getStringForKey:@"user_nid"]]) {
        params = [NSMutableDictionary dictionaryWithObject:user_nid forKey:@"user_nid"];
    }
    [NMClient enqueueRequestWithMethod:@"GET" path:path parameters:params success:success failure:failure];
    
}

+ (void)followersFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient followFor:user_nid path:@"/followers.json" success:success failure:failure];
}

+ (void)followingFor:(NSString *)user_nid withSuccess:(void (^)(NSDictionary * response))success
             failure:(void (^)(NSDictionary * response))failure {
    
    [NMClient followFor:user_nid path:@"/following.json" success:success failure:failure];    
}

/**
 * Comments
 */

+ (void)commentAboutLocation:(NSString *)location_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                success:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:location_nid,nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"parent_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];

    if(response_to) { [parameters setObject:response_to forKey:@"parent_nid"]; }

    [NMClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];
}

+ (void)commentOnUser:(NSString *)about_user_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:about_user_nid,nil];
    NSArray *params = [NSArray arrayWithObjects:@"about_user_nid",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];

    if(response_to) { [parameters setObject:response_to forKey:@"parent_nid"]; }

    [NMClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];

}

+ (void)commentOnRecommendation:(NSString *)recommendation_nid text:(NSString *)text inResponseTo:(NSString *)response_to
                     success:(void (^)(NSDictionary * response))success
                     failure:(void (^)(NSDictionary * response))failure {

    NSArray *items  = [NSArray arrayWithObjects:recommendation_nid,response_to,nil];
    NSArray *params = [NSArray arrayWithObjects:@"recommendation_nid",@"parent_nid", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];

    if(response_to) { [parameters setObject:response_to forKey:@"parent_nid"]; }

    [NMClient enqueueRequestWithMethod:@"POST" path:@"/comments/create.json" parameters:parameters success:success failure:failure];

}

+ (void)commentDestroy:(NSString *)comment_nid
                        success:(void (^)(NSDictionary * response))success
                        failure:(void (^)(NSDictionary * response))failure {
    
    NSArray *items  = [NSArray arrayWithObjects:comment_nid,nil];
    NSArray *params = [NSArray arrayWithObjects:@"comment_nid",nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient enqueueRequestWithMethod:@"POST" path:@"/comments/destroy.json" parameters:parameters success:success failure:failure];
    
}

/**
 * Activities
 */

+ (void)activitiesWithSuccess:(void (^)(NSDictionary * response))success
                      failure:(void (^)(NSDictionary * response))failure {
 
    [NMClient enqueueRequestWithMethod:@"GET" path:@"/activities.json" parameters:nil success:success failure:failure];
}

+ (void)usersActivities:(NSString *)user withSuccess:(void (^)(NSDictionary * response))success
                failure:(void (^)(NSDictionary * response))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:user forKey:@"by_user_nid"];
    [NMClient enqueueRequestWithMethod:@"GET" path:@"/activities.json" parameters:params defaultParams:NO success:success failure:failure];
}

/**
 * Upload Arbitrary Image
 */

+ (void)imageFetch:(id)image_path {
    NSURL *url = [image_path isKindOfClass:[NSURL class]] ? image_path : [NSURL URLWithString:image_path];
    AFImageRequestOperation *operation = [[AFImageRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    [HTTPQueue addOperation:operation];
}

+ (void)imageUpload:(NSString *)location_nid imageData:(NSData *)image_data fromLocalStore:(BOOL)local
          success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure
         progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress {

    NSArray *items  = [NSArray arrayWithObjects:location_nid,[NSNumber numberWithBool:YES], nil];
    NSArray *params = [NSArray arrayWithObjects:@"location_nid",@"image_attachment_present", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjects:items forKeys:params];
    
    [NMClient addDefaultParams:parameters userParams:YES setLocation:YES];

    /* Construct and begin the request with callbacks */
    NSMutableURLRequest *request = [HTTPClient multipartFormRequestWithMethod:@"POST" path:@"/image/create.json" 
                    parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        NSString *target_file_name = [NSString stringWithFormat:@"%@.png", [image_data SHA1Sum]];
        [formData appendPartWithFileData:image_data name:@"image[image]" fileName:target_file_name mimeType:@"image/png"];
    }];
    __block BOOL local_file = local;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id JSON) {
        if(local_file) {
            NSFileManager *filemgr = [NSFileManager defaultManager];
            NSString *image_filepath_key = [NSString stringWithFormat:@"%@_image_path",location_nid];
            NSString *path = [NMCurrentUser getStringForKey:image_filepath_key];
            if ([filemgr removeItemAtPath: path error: NULL] == YES) {}
        }
        if (success) { success(JSON); }
    } failure:^(NSURLRequest *request, NSURLResponse *response, NSError *error, id JSON) {
        if (failure) { failure(JSON); }
    }];
        
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        if (progress) {
            progress(totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];

    [HTTPQueue addOperation:operation];
}

+ (void)imageUpload:(NSString *)location_nid
          success:(void (^)(NSDictionary * response))success
          failure:(void (^)(NSDictionary * response))failure
         progress:(void (^)(NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progress {

    /* Build the image and the image metadata */
    BOOL image_flag = FALSE;
    NSData *image_data = nil;
    NSString *image_presence_key = [NSString stringWithFormat:@"%@_image_present?",location_nid];
    NSString *image_filepath_key = [NSString stringWithFormat:@"%@_image_path",location_nid];
    
    if ([NMCurrentUser getBooleanForKey:image_presence_key]) {
        NSString *path = [NMCurrentUser getStringForKey:image_filepath_key];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        image_data = [filemgr contentsAtPath: path ];
        
        if ([image_data length] > 0) {
            image_flag = TRUE;
        }
    } 
    if (! image_flag) {
        if (failure) {
            failure(nil);
        }
        return;
    }

    [NMClient imageUpload:location_nid imageData:image_data fromLocalStore:YES success:success failure:failure progress:progress];
}

@end
