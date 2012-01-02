//
//  NMCurrentLocation.m
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

#import "NMCurrentLocation.h"
#import "NMUtil.h"

static BOOL isScheduledForStop = false;
static NSTimer *scheduledTimer = nil;

/** NMCurrentLocation
  * An easy to use implementaton of location based services
  * 
  * To use the location services simply:
  *   `latitude = [[NMUtil currentLocation] lat];`
  *   `longitude = [[NMUtil currentLocation] lng];`
  *
  * Force updating to stop 'soon'
  *   `[[util currentLocation] stopUpdating];`
  *
  * Note that most of the calls to the Nom API append the geolocation
  * of a user by default for convenience. If you have your own library
  * for location then you will likely know how to switch over to use
  * yours.
  */
@implementation NMCurrentLocation

- (id)init {
    self = [super init];
    if (! self) { return nil; }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    [currentLocation startUpdating];
    
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

/**
  * Buffer the time when the updating of location stops.
  *   This makes sure that the device has locked into where
  *   the device is and saves battery.
  * TODO: Schedule it for restart sometime later to make sure
  *   we are current and accurate.
  */
- (void)stopUpdating {
    if (! isScheduledForStop) {
        isScheduledForStop = true;
        scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:7.5 target:[NMUtil currentLocation]
                                selector:@selector(stopUpdatingLater)
                                userInfo:nil repeats:NO];
    }
}

/**
  * Based on the current location of this device return properties
  * about where the we are.
  */
- (CGFloat)lat { return locationManager.location.coordinate.latitude;     }
- (CGFloat)lng { return locationManager.location.coordinate.longitude;    }
- (CGFloat)altitude { return locationManager.location.altitude;           }
- (CGFloat)accuracy { return locationManager.location.horizontalAccuracy; }

/**
  * Usage: Get a list of urls; i.e. for generating a photo gallery
  * Input: [location objectForKey:@"images"]
  * Returns: NSArray of image urls
  */
+ (NSArray *)imageUrlsFromImages:(NSArray *)images {
    NSMutableArray *arr = nil;
    NSString *url;
    for (NSDictionary *img in images) {
        if ([(url = [img objectForKey:@"url"]) length] > 0)
            [arr addObject:url];
    }
    return arr;
}

/**
  * Usage: Get the primary image from a location; i.e. for displaying the 
  *   location's primary image.
  * Input: [location objectForKey:@"images"]
  * Returns: primary image url
  */
+ (NSString *)primaryImageUrlFromImages:(NSArray *)images {
    NSDictionary *right;
    if (([images count] > 0) && (right = [images objectAtIndex:0])) {
        NSString *url;
        if ([(url = [right objectForKey:@"url"]) length] > 0)
            return url;
    }
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
