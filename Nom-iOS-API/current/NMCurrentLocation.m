//
//  NMCurrentLocation.m
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import "NMCurrentLocation.h"
#import "NMUtil.h"

static BOOL isScheduledForStop = false;
static NSTimer *scheduledTimer = nil;

@implementation NMCurrentLocation

- (id)init {
    self = [super init];
    if (! self) { return nil; }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    return self;
}

- (void)startUpdating {
    if (isScheduledForStop) {
        isScheduledForStop = false;
        [scheduledTimer invalidate];
    }
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLater {
    isScheduledForStop = false;
    [locationManager stopUpdatingLocation];
}

- (void)stopUpdating {
    if (isScheduledForStop) {
        return;
    } else {
        isScheduledForStop = true;
        scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:7.5 target:[NMUtil currentLocation]
                                  selector:@selector(stopUpdatingLater) 
                                  userInfo:nil repeats:NO];
    }
}

- (CGFloat)lat { return locationManager.location.coordinate.latitude;     }
- (CGFloat)lng { return locationManager.location.coordinate.longitude;    }
- (CGFloat)altitude { return locationManager.location.altitude;           }
- (CGFloat)accuracy { return locationManager.location.horizontalAccuracy; }

+ (NSArray *)imageUrlsFromLocation:(NSArray *)images {
    NSMutableArray *arr = nil;
    NSString *url;
    @try {
        for (NSDictionary *img in images) {
            if ([(url = [img objectForKey:@"url"]) length] > 0)
                [arr addObject:url];
        }
    } @catch (NSException *ex) {}
    return arr;
}

+ (NSString *)primaryImageUrlFromImages:(NSArray *)images {
    NSDictionary *right;
    @try {
        if (([images count] > 0) && (right = [images objectAtIndex:0])) {
            NSString *url;
            if ([(url = [right objectForKey:@"url"]) length] > 0) {
                return url;
            }
        }
    } @catch (NSException *ex) {}
    return nil;
}

#pragma mark CLLocation Manager Delegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    CLLocationAccuracy accuracy = newLocation.horizontalAccuracy;
    if (accuracy < kCLLocationAccuracyHundredMeters){
        [self stopUpdating];
    }
}

@end
