//
//  NMCurrentLocation.h
//
//  Created by Brian Norton on 11/16/11.
//  Copyright (c) 2011 Nom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NMCurrentLocation : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

- (void)startUpdating;
- (void)stopUpdating;

- (CGFloat)lat;
- (CGFloat)lng;
- (CGFloat)altitude;
- (CGFloat)accuracy;

@end
