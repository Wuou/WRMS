//
//  MapVC.h
//  LeftSlide
//
//  Created by zhujintao on 16/7/21.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErrorAlertModel ;
@interface MapVC : UIViewController
/** 报警信息数组*/
@property (nonatomic,strong) NSMutableArray     *arrLocation;
/** 天地图*/
@property (weak, nonatomic) IBOutlet TMapView   *mapView;
/** 报警名称*/
@property (nonatomic,strong) IBOutlet UILabel   *eventNameLbl;
/** 地址*/
@property (nonatomic,strong) IBOutlet UILabel   *addrLbl;
/** 底部视图*/
@property (nonatomic,strong) IBOutlet UIView    *bottomView;
/** 底部label*/
@property (nonatomic,strong) IBOutlet UILabel   *bgLbl;
/** 参数经度对应的值*/
@property (nonatomic,strong ) NSString          *latStr;
/** 参数纬度对应的值*/
@property (nonatomic,strong ) NSString          *longStr;
@property (nonatomic,strong ) NSString          *alarmTypeNameStr;
/** 参数纬度对应的值*/
@property (nonatomic,strong ) NSString          *addrStr;
/** 参数海拔对应的值*/
@property (nonatomic,strong ) NSString          *heightStr;

@property (nonatomic,strong) ErrorAlertModel *emModel;
@end
