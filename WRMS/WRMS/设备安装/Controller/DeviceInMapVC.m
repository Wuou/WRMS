//
//  DeviceInstallMap.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/22.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DeviceInMapVC.h"
#import "Devicemodel.h"
#import "MyAnnotation.h"
#import "DeviceInfoVC.h"
#import "TMapView.h"

@interface DeviceInMapVC () <TMapViewDelegate>

/** 天地图*/
@property (strong, nonatomic) IBOutlet TMapView *mapView;
/** 纬度字段*/
@property (nonatomic,strong ) NSString *strLatitude;
/** 经度字段*/
@property (nonatomic,strong ) NSString *strLongitude;
/** 编号*/
@property (nonatomic,strong ) IBOutlet UILabel  *labelNum;
/** 地址*/
@property (nonatomic,strong ) IBOutlet UILabel  *labelAdd;
/** 下方的背景view*/
@property (nonatomic,strong ) IBOutlet UIView   *viewBottom;
/** 背景颜色*/
@property (nonatomic,strong ) IBOutlet UILabel  *labelBG;

@end

@implementation DeviceInMapVC

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title                            = @"水位设备位置";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

/**
 *  视图出现时设置代理, 获取位置
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapView StartGetPosition];
    
    [self showPointInMap];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

/**
 *  视图消失, 停止获取位置
 *
 *  @param animated animated
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    [self.mapView StopGetPosition];
}

#pragma mark --- TMapView Delegate
- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view
{
    DeviceInfoVC *pevc = [[DeviceInfoVC alloc]init];
    MyAnnotation *myAnno     = view.annotation;
//        NSLog(@"标题%@",myAnno.title);
    NSRange range            = [myAnno.title rangeOfString:@"我的位置"];//判断字符串是否包含
    if (range.length >0)//包含
    {
        [view setSelected:NO];
    }
    else//不包含
    {
        for (Devicemodel *pmodel in self.arrLocation)
        {
            if ([myAnno.title rangeOfString:@"-"].length > 0)
            {
                if([pmodel.waterMchnId isEqualToString:[myAnno.title substringToIndex:[myAnno.title rangeOfString:@"-"].location]])
                {
                    pevc.wmodel = pmodel;
                }
            }else
            {
                if([pmodel.pointId isEqualToString:myAnno.title])
                {
                    pevc.wmodel = pmodel;
                }
            }
        }
        [self.navigationController pushViewController:pevc animated:YES];
    }
}

#pragma mark - private methods
/**
 *  显示水位的位置
 */
- (void)showPointInMap
{
    CLLocationCoordinate2D pt;
    for (Devicemodel *pmodel in self.arrLocation)
    {
        pt.latitude        = [pmodel.straltitude doubleValue];
        pt.longitude       = [pmodel.strlongitude doubleValue];
        MyAnnotation *temp = [[MyAnnotation alloc] init];
        temp.coordinate    = pt;
        if (pmodel.coversIdCustom.length > 0)
        {
            temp.title = [NSString stringWithFormat:@"%@-%@",pmodel.pointId,pmodel.coversIdCustom];
        }else
        {
            temp.title = pmodel.pointId;
        }
        [self.mapView addAnnotation:temp];
        [self.mapView setCenterCoordinate:pt];
    }
    
    if ([self.arrLocation count]== 1)
    {
        Devicemodel *pmodel = [self.arrLocation objectAtIndex:0];
        self.labelAdd.text =[NSString stringWithFormat:@"地址:%@",pmodel.strlocation];
        if (pmodel.coversIdCustom.length > 0)
        {
            self.labelNum.text = [NSString stringWithFormat:@"编号:%@-%@",pmodel.pointId,pmodel.coversIdCustom];
        }else
        {
            self.labelNum.text = [NSString stringWithFormat:@"编号:%@",pmodel.pointId];
        }
    }else
    {
        [self.labelBG setHidden:YES];
        [self.viewBottom setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
