//
//  WellErrorInfoVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/21.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "WaterDeviceInMapVC.h"
#import "TAnnotation.h"
#import "MyAnnotation.h"
#import "WaterDeviceInfoVC.h"

#import "WaterModel.h"
#import "TPoiSearch.h"
@interface WaterDeviceInMapVC () <TMapViewDelegate,TPoiSearchDelegate>

@property (strong,nonatomic) IBOutlet TMapView  *mapView;
@property (nonatomic,strong) NSString  *strLatitude;
@property (nonatomic,strong) NSString  *strLongitude;
@property (nonatomic,weak  ) WaterModel *wmodel;
@property (nonatomic,strong) IBOutlet UILabel   *labelNum;
@property (nonatomic,strong) IBOutlet UILabel   *labelAdd;
@property (nonatomic,strong) IBOutlet UIView    *viewBottom;
@property (nonatomic,strong) IBOutlet UILabel   *labelBG;


@property (nonatomic,strong)TPoiSearch *poiSearch;
@end

@implementation WaterDeviceInMapVC
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title                            = @"水位设备地图分布";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

/**
 *  viewcontroller 即将消失，停止地图定位
 *
 *  @return
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    [self.mapView StopGetPosition];
}
//
//- (void)showCityCode {
//    _poiSearch = [[TPoiSearch alloc] init];
//    _poiSearch.delegate = self;
//    TPoiSearchParam *param = [[TPoiSearchParam alloc] init];
//    param.strkeyword = @"丈八一路";
//    param.mapscal = 13;
//    param.searchtype = wordsSearch;
//    param.searchCounter = 30;
//    param.searchbound = _mapView.mapBound;
//    param.position = _mapView.userLocation.coordinate;
//    _poiSearch.param = param;
//}
//
//- (void)beginSearch:(TPoiSearch *)search {
//    if (_poiSearch.param.searchtype == wordsSearch)
//        NSLog(@"正在搜索");
//    else
//        NSLog(@"停止搜索");
//}

//// 检索到POI
//- (void)Search:(TPoiSearch *)search POIresult:(NSArray *)PoiResult allcounter:(NSUInteger)allcounter tips:(NSArray *)arrTips {
//    NSString *strMsg = [NSString stringWithFormat:@"行政区编码：%zd",search.param.searchareacode];
//    NSLog(@"===%@",strMsg);
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.mapView StartGetPosition];
    
    if ([self.arrLocation count] > 0)
    {
        [self showPointInMap];
    }else{
        [self.labelBG setHidden:YES];
        [self.viewBottom setHidden:YES];
        self.mapView.ShowPosition  = YES;
//        self.mapView.UserTrackMode = TUserTrackingModeFollow;
    }
//    [self showCityCode];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TMapKit Delegate
- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view
{
    WaterDeviceInfoVC *pevc  = [[WaterDeviceInfoVC alloc]init];
    MyAnnotation *myAnno = view.annotation;
    //判断字符串是否包含"我的位置"
    NSRange range        = [myAnno.title rangeOfString:@"我的位置"];
    if (range.length > 0)
    {
    }
    else
    {
        for (WaterModel *pmodel in self.arrLocation)
        {
            if ([myAnno.title rangeOfString:@"-"].length > 0)
            {
                if([pmodel.pointId isEqualToString:[myAnno.title substringToIndex:[myAnno.title rangeOfString:@"-"].location]])
                {
                    pevc.wmodel = pmodel;
                }
            }else{
                if([pmodel.pointId isEqualToString:myAnno.title])
                {
                    pevc.wmodel = pmodel;
                }
            }
        }
        [self.navigationController pushViewController:pevc animated:YES];
    }
}

#pragma mark Show Point in TmapKit
-(void)showPointInMap
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLLocationCoordinate2D pt;
        for (WaterModel *pmodel in self.arrLocation)
        {
            pt.latitude        = [pmodel.latitudestr doubleValue];
            pt.longitude       = [pmodel.longitudestr doubleValue];
            MyAnnotation *temp = [[MyAnnotation alloc] init];
            temp.coordinate    = pt;
            if (pmodel.coversIdCustom.length > 0)
            {
                temp.title = [NSString stringWithFormat:@"%@-%@",pmodel.pointId,pmodel.coversIdCustom];
            }else{
                temp.title = pmodel.pointId;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:temp];
                [self.mapView setCenterCoordinate:pt];
                
            });
        }
    });
    if ([self.arrLocation count] == 1)
    {
        WaterModel *pmodel  = [self.arrLocation objectAtIndex:0];
        self.labelAdd.text = [NSString stringWithFormat:@"地址:%@",pmodel.locationstr];
        if (pmodel.coversIdCustom.length > 0)
        {
            self.labelNum.text = [NSString stringWithFormat:@"编号:%@-%@",pmodel.pointId,pmodel.coversIdCustom];
        }else{
            self.labelNum.text = [NSString stringWithFormat:@"编号:%@",pmodel.pointId];
        }
    }else{
        [self.labelBG setHidden:YES];
        [self.viewBottom setHidden:YES];
    }
}

@end
