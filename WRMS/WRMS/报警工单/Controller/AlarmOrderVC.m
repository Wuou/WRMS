//
//  AlarmOrderVC.m
//  WRMS
//
//  Created by mymac on 16/8/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "AlarmOrderVC.h"
#import "ErrorAlertModel.h"
#import "ErrorOrderApi.h"
#import "ErrorAlertCell.h"
#import "ErrorAlertInfoVC.h"
#import "MapVC.h"


static NSString *const ErrorIdentifier = @"ErrorAlertCell";
@interface AlarmOrderVC () <touchRightBtnDelegate>
/** 接收服务器返回数据*/
@property (nonatomic,strong) NSMutableArray *arrProduct;
/** 展示列表*/
@property (nonatomic,strong) IBOutlet UITableView    *myTB;
@property (nonatomic, strong) YNTableView *errorTableView;
@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation AlarmOrderVC
#pragma Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title                            = @"报警工单";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshList)
                                                     name:@"RefreshEventManageList" object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTB.tableFooterView = [[UIView alloc] init];
    
    // 从服务器获取数据
    self.arrProduct           = [[NSMutableArray alloc]init];
    
    self.pageNum = 1;

    [self setYNTableView];
    [self setMJRefresh];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCodeAgained" object:nil];
}

#pragma mark - touchRightBtnDelegate
- (void)touchlocBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    MapVC *emMapVC = [[MapVC alloc]init];
    ErrorAlertModel *emModel = self.arrProduct[btn.tag];
    emMapVC.emModel = emModel;
    [self.navigationController pushViewController:emMapVC animated:YES];
}

#pragma mark - private methods
- (void)getCodeAgained
{
    [self.arrProduct removeAllObjects];
    [self getListAction];
}

- (void)refreshList {
    [_myTB.header beginRefreshing];
}

/**
 *  获取列表数据
 */
- (void)getListAction
{
    [ErrorOrderApi apiWithErrorOrderList:self.arrProduct uiTableView:self.myTB successBlock:^() {
        _errorTableView.items = self.arrProduct;
        [self.myTB reloadData];
    }];
}

- (void)setYNTableView {
    // 自定义封装UITableView的代理方法
    _errorTableView = [[YNTableView alloc] initWithItems:self.arrProduct cellIdentifier:ErrorIdentifier dataSourceBlock:^(ErrorAlertCell *cell, ErrorAlertModel *model, NSIndexPath *indexPath) {
        cell.emModel = model;
        cell.delegate = self;
        cell.locBtn.tag = indexPath.row;
        cell.leftIDLbl.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    } delegateBlock:^(NSIndexPath *indexPath) {
        ErrorAlertInfoVC *evc   = [[ErrorAlertInfoVC alloc]init];
        ErrorAlertModel *emodel = [self.arrProduct objectAtIndex:indexPath.row];
        evc.strFromType = @"工单";
        evc.wmodel = emodel;
        evc.orderIdStr = emodel.orderId;
        [self.navigationController pushViewController:evc animated:YES];
    }];
    _errorTableView.YNTableView = self.myTB;
    self.myTB.dataSource = self.errorTableView;
    self.myTB.delegate   = self.errorTableView;
    [self.myTB registerClass:[ErrorAlertCell class] forCellReuseIdentifier:ErrorIdentifier];
}

- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        
        [self.arrProduct removeAllObjects];
        self.pageNum = 1;
        [self getListAction];
    }];
    
//    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
//        
//        self.pageNum +=1;
//        [self getListAction];
//    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    header.autoChangeAlpha = YES;
//    footer.autoChangeAlpha = YES;
//    footer.automaticallyRefresh = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    self.myTB.header = header;
//    self.myTB.footer = footer;
}


- (void)didReceiveMemoryWarning {
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
