//
//  DeviceInstallVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/15.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DeviceListVC.h"
#import "SVProgressHUD.h"
#import "YNRequestWithArgs.h"

#import "DeviceInstall.h"
#import "Devicemodel.h"
#import "DeviceChange.h"
#import "DeviceInMapVC.h"
#import "AppDelegate.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WaterCell.h"
#import "UIColor-Expanded.h"
#import "YNRequest.h"
#import "DeviceInstallApi.h"
#import "YNLocation.h"
#import "YNTableView.h"

static NSString *ID = @"DeviceList";

@interface DeviceListVC () <touchRightBtnDelegate>

/** 展示信息列表*/
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

/** 接收服务器返回数据数组*/
@property (nonatomic,strong ) NSMutableArray *arrProduct;
/** 纬度*/
@property (nonatomic,strong ) NSString *strLat;
/** 经度*/
@property (nonatomic,strong ) NSString *strLong;
/** 控制分页数*/
@property (nonatomic,assign ) NSInteger pageNum;
@property (nonatomic,strong) YNTableView *deviceTableView;
@end

@implementation DeviceListVC
#pragma mark - lift cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title                            =@"设备安装";
        
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(RefreshDeviceList:)
                                                     name:@"RefreshDeviceList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
    }
    return self;
}

/**
 *  设置控件的基本属性
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化接收数组
    self.arrProduct = [[NSMutableArray alloc]init];
    // 控制加载的页数
    self.pageNum = 1;
    [self setYNTableView];
    [self setMJRefresh];
}

/**
 *  取消右滑返回上级页面, 接收通知
 *
 *  @param animated animated
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

/**
 *  dealloc中销毁通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDeviceList" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCodeAgained" object:nil];
}


#pragma mark - private methods
/**
 *  接收通知刷新列表
 *
 *  @param text NSNotification
 */
-(void)RefreshDeviceList:(NSNotification *)text
{
    NSString *name = [text.userInfo objectForKey:@"StateName"];
    NSString *nameId = [text.userInfo objectForKey:@"State"];
    NSString *mchnId = [text.userInfo objectForKey:@"MchnId"];
    NSString *imei = [text.userInfo objectForKey:@"imei"];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSIndexPath *index = [NSIndexPath indexPathForRow:tempAppDelegate.scrollIndex inSection:0];
    
    Devicemodel *model  = [self.arrProduct objectAtIndex:tempAppDelegate.scrollIndex];
    model.waterMchnStateName = name;
    model.waterMchnState = nameId;
    model.waterMchnId = mchnId;
    model.strcodeImei = imei;
    
    [self.arrProduct insertObject:model atIndex:tempAppDelegate.scrollIndex];
    [self.arrProduct removeObjectAtIndex:tempAppDelegate.scrollIndex];
    [self.myTableView reloadData];
    [self.myTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionNone animated:NO];
    
}

-(void)getCodeAgained
{
    self.pageNum = 1;
    [self.arrProduct removeAllObjects];
    [self getDeviceList];
}


/**
 *  向服务器发送请求
 */
-(void)getDeviceList
{
    //获取经纬度
    [YNLocation getMyLocation:self.strLat
                    lontitude:self.strLong
                       height:nil
                 successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {
                     self.strLat = strLat;
                     self.strLong = strLon;
                 }];
    
    
    //发送请求
    [DeviceInstallApi apiWithDeviceList:self.strLong
                               latitude:self.strLat
                                pageNum:self.pageNum
                                uitable:self.myTableView
                                  nsArr:self.arrProduct
                           successBlock:^{
                               
                               self.pageNum -= 1;
                           }
                            returnBlock:^{
                                // 数组除重
                                NSMutableArray *categoryArr = [NSMutableArray array];
                                for (int i = 0; i < [self.arrProduct count]; i++)
                                {
                                    if ([categoryArr containsObject:[self.arrProduct objectAtIndex:i]] == NO)
                                    {
                                        [categoryArr addObject:[self.arrProduct objectAtIndex:i]];
                                    }
                                }
                                //重新更新数据源
                                _deviceTableView.items = categoryArr;
                                [self.myTableView reloadData];
                            }];
}

#pragma mark - public methods
#pragma mark - touchRightBtnDelegate
-(void)touchDeviceInstall:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tempAppDelegate.scrollIndex = btn.tag;
    DeviceInstall *infoVC = [[DeviceInstall alloc]init];
    Devicemodel *wmodel         = self.arrProduct[btn.tag];
    infoVC.dmodel               = wmodel;
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)touchDeviceChange:(id)sender{
    UIButton *btn = (UIButton *)sender;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tempAppDelegate.scrollIndex = btn.tag;
    DeviceChange *infoVC = [[DeviceChange alloc]init];
    Devicemodel *wmodel            = self.arrProduct[btn.tag];
    infoVC.dmodel                  = wmodel;
    [self.navigationController pushViewController:infoVC animated:YES];
}

/**
 *  私有方法 - 设置cell的各种属性
 *
 *  @param cell      目标cell
 *  @param model     数据model
 *  @param indexPath indexPath
 */
- (void)setTheCellWithCell:(WaterCell *)cell model:(id)model indexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    cell.devicemodel   = model;
    cell.text          = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    cell.rightBtn.tag = indexPath.row;
}


- (void)setYNTableView {
    
    _deviceTableView = [[YNTableView alloc] initWithItems:self.arrProduct cellIdentifier:ID dataSourceBlock:^(WaterCell *cell, WaterModel *model, NSIndexPath *indexPath) {
        // 自定义设置cell的各种属性
        [self setTheCellWithCell:cell model:model indexPath:indexPath];
    } delegateBlock:^(NSIndexPath *indexPath) {
        DeviceInMapVC *thirdConstructionInfoVC = [[DeviceInMapVC alloc]init];
        NSMutableArray *arrModel = [[NSMutableArray alloc]init];
        Devicemodel *wmodel      = self.arrProduct[indexPath.row];
        [arrModel addObject:wmodel];
        thirdConstructionInfoVC.arrLocation       = arrModel;
        [self.navigationController pushViewController:thirdConstructionInfoVC animated:YES];
        
    }];
    _deviceTableView.YNTableView = self.myTableView;
    self.myTableView.dataSource = _deviceTableView;
    self.myTableView.delegate   = _deviceTableView;
    [self.myTableView registerClass:[WaterCell class] forCellReuseIdentifier:ID];
    // 设置表足的属性
    self.myTableView.tableFooterView = [[UIView alloc]init];
}

- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        
        [self.arrProduct removeAllObjects];
        self.pageNum = 1;
        [self getDeviceList];
    }];
    
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        
        self.pageNum +=1;
        [self getDeviceList];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    header.autoChangeAlpha = YES;
    footer.autoChangeAlpha = YES;
    footer.automaticallyRefresh = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    self.myTableView.header = header;
    self.myTableView.footer = footer;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
