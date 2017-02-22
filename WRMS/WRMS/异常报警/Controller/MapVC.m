//
//  MapVC.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/21.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "MapVC.h"
#import "ErrorAlertInfoVC.h"
#import "ErrorAlertModel.h"

@interface MapVC ()<TMapViewDelegate>

@end

@implementation MapVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title                            = @"报警点";
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView StartGetPosition];
    [self showPointInMap];
    self.mapView.ShowPosition  = YES;
//    self.mapView.UserTrackMode = TUserTrackingModeFollow;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

/**
 *  viewcontroller 即将消失，停止地图定位
 *
 *  @return
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView StopGetPosition];
}

#pragma mark - mapView delegate
- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view {
    MyAnnotation *myAnno = view.annotation;
    //判断字符串是否包含"我的位置"
    NSRange range        = [myAnno.title rangeOfString:@"报警位置"];
    if (range.length > 0)
    {
        [view setSelected:NO];
    }
    else
    {
    }
}

- (void)mapView:(TMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

#pragma mark - private methods
- (void)showPointInMap {
    
    //采用GCD异步显示水位信息
    CLLocationCoordinate2D pt;
    self.latStr  = self.emModel.latitude;
    self.longStr = self.emModel.longitude;
    self.addrStr = self.emModel.location;
    self.alarmTypeNameStr = self.emModel.alarmTypeName;
    NSLog(@"%@ %@",self.latStr,self.longStr);
    pt.latitude        = [self.latStr  doubleValue];
    pt.longitude       = [self.longStr doubleValue];
    MyAnnotation *temp = [[MyAnnotation alloc]init];
    temp.coordinate    = pt;
    temp.title         = [NSString stringWithFormat:@"%@",self.alarmTypeNameStr];
    
    [self.mapView addAnnotation:temp];
    [self.mapView setCenterCoordinate:pt];
    self.addrLbl.text = [NSString stringWithFormat:@"地址:%@",self.addrStr];
    NSLog(@"%@",self.addrStr);
    [self.bgLbl setHidden:NO];
    [self.bottomView setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
