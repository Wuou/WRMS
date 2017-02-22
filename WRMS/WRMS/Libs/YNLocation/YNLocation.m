//
//  myLocation.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@implementation YNLocation

+ (void)getMyLocation:(NSString *)lat
            lontitude:(NSString *)lonti
               height:(NSString *)height
         successBlock:(locationSucBlock)locaBlock
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate.latStr ==  nil && myDelegate.lonStr == nil)
    {
        //先定位
        if([CLLocationManager locationServicesEnabled])
        {
            CLLocationManager *locationManager = [[CLLocationManager alloc] init];
            lat                                = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
            lonti                              = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
            height                             = [NSString stringWithFormat:@"%.2f", locationManager.location.altitude];
        }
    }else
    {
        if ([myDelegate.latStr floatValue] > 0 && [myDelegate.lonStr floatValue] > 0)
        {
            lat = myDelegate.latStr;
            lonti = myDelegate.lonStr;
            height = myDelegate.altitude;
        }else
        {
            //先定位
            if([CLLocationManager locationServicesEnabled])
            {
                CLLocationManager *locationManager = [[CLLocationManager alloc] init];
                lat                                = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
                lonti                              = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
                height                             = [NSString stringWithFormat:@"%.2f", locationManager.location.altitude];
            }
        }
    }

    if ([lat floatValue] >1 && [lonti floatValue] >1) {
        locaBlock(lat,lonti,height);
    }else{
        
    }
}
@end
