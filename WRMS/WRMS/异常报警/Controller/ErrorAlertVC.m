//
//  EventManagementVC.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "ErrorAlertVC.h"
#import "EventManagementApi.h"
#import "AddErrorAlertVC.h"
#import "ErrorAlertCell.h"
#import "ErrorAlertModel.h"
#import "ErrorAlertInfoVC.h"
#import "MapVC.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

static NSString *identity = @"ErrorAlertCell";
@interface ErrorAlertVC ()<UIScrollViewDelegate,touchRightBtnDelegate,BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_geoCodeSearch;
}
@end

@implementation ErrorAlertVC

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"异常报警";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshHiddenInfoAction)
                                                     name:@"RefreshQueryAlarmOrderList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(RefreshWellErrorList)
                                                     name:@"RefreshWellErrorList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //addBtn
    _rightBtn = [[YNNavigationRightBtn alloc]initWith:nil img:@"add" contro:self];
    __weak typeof(self) weakSelf = self;
    _rightBtn.clickBlock = ^(){
        [weakSelf toAddEventManagement];
    };
    self.showArr    = [[NSMutableArray alloc] init];
    self.arrProduct = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.pageNum              = 1;
    //设置tableView
    [self setYNTable];
    [self setMJRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshQueryAlarmOrderList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCodeAgained" object:nil];
}

#pragma mark - rightBtn delegate
- (void)touchlocBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    MapVC *emMapVC = [[MapVC alloc]init];
    ErrorAlertModel *emModel = self.arrProduct[btn.tag];
    emMapVC.emModel = emModel;
    [self.navigationController pushViewController:emMapVC animated:YES];
}

#pragma mark - private Methods
- (void)toAddEventManagement {
    AddErrorAlertVC *addEMVC = [[AddErrorAlertVC alloc]init];
    [self.navigationController pushViewController:addEMVC animated:YES];
}

- (void)getCodeAgained {
    self.pageNum = 1;
    [self getListAction];
}


- (void)setYNTable {
    _eventManagementTable = [[YNTableView alloc] initWithItems:self.arrProduct cellIdentifier:identity dataSourceBlock:^(ErrorAlertCell *cell, ErrorAlertModel  *model, NSIndexPath *indexPath) {
        cell.delegate = self ;
        cell.locBtn.tag = indexPath.row;
        cell.emModel  = model;
        cell.leftIDLbl.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    } delegateBlock:^(NSIndexPath *indexPath) {
        
        ErrorAlertInfoVC *emInfoVC = [[ErrorAlertInfoVC alloc]init];
        self.emModel = self.arrProduct[indexPath.row];
        emInfoVC.orderIdStr = self.emModel.orderId;
        emInfoVC.wmodel = self.emModel;
        [self.navigationController pushViewController:emInfoVC animated:YES];
    }];
    _eventManagementTable.YNTableView = self.myTB;
    self.myTB.delegate   = _eventManagementTable;
    self.myTB.dataSource = _eventManagementTable;
    [self.myTB registerClass:[ErrorAlertCell class] forCellReuseIdentifier:identity];
    self.myTB.tableFooterView = [[UIView alloc] init];
}


/**
 *  初始化MJRefresh
 */
- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        [self.arrProduct removeAllObjects];
        self.pageNum = 1;
        [self getListAction];
        _myTB.userInteractionEnabled = NO;
        _myTB.scrollEnabled = NO;
    }];
    
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        self.pageNum +=1;
        [self getListAction];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    header.autoChangeAlpha = YES;
    footer.autoChangeAlpha = YES;
    footer.automaticallyRefresh = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    _myTB.header = header;
    _myTB.footer = footer;
}

//获取列表数据
- (void)getListAction {
    
    [EventManagementApi apiWithTableView:self.myTB pageNum:self.pageNum dataArr:self.arrProduct pageChange:^{
        
        self.showArr = self.arrProduct ;
        _eventManagementTable.items = self.arrProduct;
        self.pageNum -= 1;
    } repeatArr:^{
        //数组除重
        NSMutableArray *categoryArr = [NSMutableArray array];
        for (int i = 0; i<[self.arrProduct count]; i++) {
            if ([categoryArr containsObject:[self.arrProduct objectAtIndex:i]] == NO) {
                [categoryArr addObject:[self.arrProduct objectAtIndex:i]];
            }
        }
        //在刷新列标前，将数据源数组更新
        _eventManagementTable.items = categoryArr;
        [self.myTB reloadData];
    }];
}

- (void)refreshHiddenInfoAction {
    [_arrProduct removeAllObjects];
    [self getListAction];
    [self.myTB reloadData];
}

- (void)RefreshWellErrorList {
    [_arrProduct removeAllObjects];
    [self getListAction];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
