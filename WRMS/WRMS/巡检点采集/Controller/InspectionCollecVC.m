//
//  InspectionCollecVC.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "InspectionCollecVC.h"
#import "AddInspectionVC.h"
#import "ViewController.h"
#import "InspectionInfoVC.h"


static NSString *identity = @"inspectionCell";
@interface InspectionCollecVC () 
@property (nonatomic,strong)IBOutlet UITableView *mytb;
@property (nonatomic,strong)YNTableView *inpectionTable;
@property (nonatomic,strong)YNNavigationRightBtn *rightBtn;
//巡检点数组
@property (nonatomic,strong)NSMutableArray       *arrInspection;
//显示巡检点列表
@property (nonatomic,strong)NSMutableArray       *showArr;


@end

@implementation InspectionCollecVC
#pragma mark - LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"监测点采集列表";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshList)
                                                     name:@"RefreshInspecList" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.arrInspection = [[NSMutableArray alloc]init];
    self.showArr       = [[NSMutableArray alloc]init];
    //addBtn
    _rightBtn = [[YNNavigationRightBtn alloc]initWith:nil img:@"add" contro:self];
    __weak typeof(self) weakSelf = self;
    _rightBtn.clickBlock = ^(){
        [weakSelf toAddInspectionVC];
    };
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    self.pageNum = 1;
    
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshInspecList" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getCodeAgained" object:nil];
    
}
#pragma mark - Private
- (void)getCodeAgained {
    [_mytb.header beginRefreshing];
}

- (void)refreshList {
    [self.arrInspection removeAllObjects];
    self.pageNum = 1;
    [self getInspecList];
}

//监测点列表
- (void)getInspecList {
    
    [InspectionApi apiWithInspecList:self.mytb pageNum:self.pageNum arrProduct:self.arrInspection pageChange:^{
        self.pageNum -= 1;
    } repeatArr:^{
        //数组除重
        NSMutableArray *categoryArr = [NSMutableArray array];
        for (int i = 0; i<[self.arrInspection count]; i++) {
            if ([categoryArr containsObject:[self.arrInspection objectAtIndex:i]] == NO) {
                [categoryArr addObject:[self.arrInspection objectAtIndex:i]];
            }
        }
        //在刷新列表前，将数据源数组更新
        _inpectionTable.items = categoryArr;
        [self.mytb reloadData];
    }];
    
}

/**
 *  初始化MJRefresh
 */
- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        
        [self.arrInspection removeAllObjects];
        self.pageNum = 1;
        [self getInspecList];
        
        _mytb.userInteractionEnabled = NO;
        _mytb.scrollEnabled = NO;
    }];
    
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        
        self.pageNum +=1;
        [self getInspecList];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    header.autoChangeAlpha = YES;
    footer.autoChangeAlpha = YES;
    footer.automaticallyRefresh = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    _mytb.header = header;
    _mytb.footer = footer;
}

//push到添加巡检点采集
- (void)toAddInspectionVC {
    AddInspectionVC *advc = [[AddInspectionVC alloc]init];
    [self.navigationController pushViewController:advc animated:YES];
}

- (void)setYNTable {
    _inpectionTable = [[YNTableView alloc] initWithItems:self.arrInspection cellIdentifier:identity dataSourceBlock:^(inspectionCell *cell, PointModel *model, NSIndexPath *indexPath) {
        
        [cell setPointModel:model];
        cell.leftIDLbl.text =[NSString stringWithFormat:@"%zd",indexPath.row +1];
    } delegateBlock:^(NSIndexPath *indexPath) {
        
        InspectionInfoVC *iivc = [[InspectionInfoVC alloc]init];
        PointModel *pmodel = self.arrInspection[indexPath.row];
        iivc.pmodel = pmodel;
        [self.navigationController pushViewController:iivc animated:YES];
    }];
    
    _inpectionTable.YNTableView = self.mytb;
    self.mytb.delegate   = _inpectionTable;
    self.mytb.dataSource = _inpectionTable;
    [self.mytb registerClass:[inspectionCell class] forCellReuseIdentifier:identity];
    self.mytb.tableFooterView =[[UIView alloc]init];
}

- (void)refreshHiddenInfoAction {
    [_arrInspection removeAllObjects];
    [self getInspecList];
    [self.mytb reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
