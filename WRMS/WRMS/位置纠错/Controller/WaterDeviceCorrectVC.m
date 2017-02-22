//
//  WellErrorVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/15.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "WaterDeviceCorrectVC.h"
#import "WaterModel.h"
#import "WaterCell.h"
#import "WaterDeviceCorrectApi.h"
#import "WaterDeviceInMapVC.h"




static NSString *ID = @"WaterDeviceCorrect";

@interface WaterDeviceCorrectVC () <UIScrollViewDelegate,UISearchBarDelegate,touchRightBtnDelegate,BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch *_geoCodeSearch;
}
@property(nonatomic,strong) UIView *editView;
/** 水位编号*/
@property(nonatomic,strong)UILabel *wellIdTitleLbl;
@property(nonatomic,strong)UITextField *wellIdLbl;
/** 水位经度*/
@property(nonatomic,strong)UILabel *wellLatTitleLbl;
@property(nonatomic,strong)UITextField *wellLatLbl;
/** 水位纬度*/
@property(nonatomic,strong)UILabel *wellLonTitleLbl;
@property(nonatomic,strong)UITextField *wellLonLbl;
/** 水位地址*/
@property(nonatomic,strong)UILabel *wellAdsTitleLbl;
@property(nonatomic,strong)UITextView *wellAdsLbl;

//确定
@property(nonatomic,strong)UIButton *btnOk;
@property(nonatomic,strong)UIScrollView *mysv;


/** 计时器, 每隔一段时间获取位置*/
@property (nonatomic, strong) NSTimer             *myTimer;
/** 搜索栏*/
@property (strong,nonatomic ) IBOutlet UISearchBar         *mySearchBar;
/** 定义一个数组用来展示searchBar搜索出来的数据*/
@property (nonatomic, strong) NSMutableArray      *searchArr;
/** 定义一个展示数组*/
@property (nonatomic, strong) NSMutableArray      *showArr;

/** 底部上拉分页的控件*/
@property (nonatomic, strong) MJRefreshFooter *refreshFooter;
@property (nonatomic,strong ) NSMutableArray      *arrProduct;
@property (nonatomic,strong ) IBOutlet UITableView         *myTB;
@property (nonatomic,strong ) WaterModel           *RowWellmodel;
/** 参数经度对应的值*/
@property (nonatomic,strong ) NSString            *strLat;
/** 参数纬度对应的值*/
@property (nonatomic,strong ) NSString            *strLong;
/** 参数海拔对应的值*/
@property (nonatomic,strong ) NSString            *strHeight;
/** 地址*/
@property (nonatomic,strong ) NSString            *location;
/** 当前分页数*/
@property (nonatomic,assign ) NSInteger           pageNum;
@property (nonatomic,strong) YNNavigationRightBtn *btnRightItem;
@property(nonatomic,strong) YNTableView *errorTableView;
@end

@implementation WaterDeviceCorrectVC
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title                            = @"位置纠错";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
        
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _geoCodeSearch.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化地理编码类
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    __weak typeof(self) weakSelf = self;
    _arrProduct = [[NSMutableArray alloc]init];
    _showArr    = [NSMutableArray array];
    
    self.myTB.tableFooterView = [[UIView alloc]init];
    // 给tableView设置滚动视图的代理
    self.pageNum              = 1;
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    //采用GCD异步线程，获取到用户定位后再取接口数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self getLat];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 获取数据
            [self setMJRefresh];
            
            // 设置tableView
            [self setYNTableView];
        });
    });
    
    
    _btnRightItem = [[YNNavigationRightBtn alloc]initWith:nil img:@"ErrorLoc" contro:self];
    
    _btnRightItem.clickBlock = ^(){
        [weakSelf toErrorMapVC];
    };
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    _geoCodeSearch.delegate = nil;
    [SVProgressHUD dismiss];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getCodeAgained" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKGeoCodeSearchDelegate
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
    BMKAddressComponent *addressDetail = result.addressDetail;
    self.location = [NSString stringWithFormat:@"%@%@%@%@%@", addressDetail.province, addressDetail.city, addressDetail.district, addressDetail.streetName, addressDetail.streetNumber];
    _wellAdsLbl.text = self.location;
    
}

#pragma mark --- UISearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.mySearchBar.text = nil;
    self.searchArr = nil;
    _showArr = _arrProduct;
    _errorTableView.items = _showArr;
    [self.myTB reloadData];
    [self.mySearchBar resignFirstResponder];
    
    // 点击取消后恢复刷新控件
    self.myTB.header.hidden = NO;
    self.myTB.footer.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length > 0)
    {
        self.searchArr   = [NSMutableArray array];
        WaterModel *model = [[WaterModel alloc] init];
        for (model in self.arrProduct)
        {
            if ([model.pointId rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                [self.searchArr addObject:model];
            }
        }
        self.showArr = self.searchArr;
        _errorTableView.items = self.showArr;
        [self.myTB reloadData];
    }else{
        
        self.showArr = self.arrProduct;
        _errorTableView.items = self.showArr;
        [self.myTB reloadData];
    }
    // 搜索过程中隐藏刷新控件
    self.myTB.header.hidden = YES;
    self.myTB.footer.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
    
    // 点击搜索后隐藏刷新控件
    self.myTB.header.hidden = YES;
    self.myTB.footer.hidden = YES;
}


#pragma mark - touchRightBtnDelegate
- (void)touchWellError:(id)sender {
    
    if (!self.refreshFooter.isRefreshing)
    {
        //采用GCD异步线程，获取到用户定位后再回到主线程更新UI
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [YNLocation getMyLocation:self.strLat
                            lontitude:self.strLong
                               height:self.strHeight
                         successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {
                             
                             self.strHeight = strHeight;
                             self.strLong = strLon;
                             self.strLat = strLat;
                             
                             // 在水位采集中，使用百度地图通过经纬度获取到地址
                             CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake([self.strLat floatValue], [self.strLong floatValue]);
                             //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
                             NSDictionary* testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_COMMON);
                             //转换GPS坐标至百度坐标(加密后的坐标)
                             testdic2 = BMKConvertBaiduCoorFrom(coor2,BMK_COORDTYPE_GPS);
                             //解密加密后的坐标字典
                             coor2 = BMKCoorDictionaryDecode(testdic2);//转换后的百度坐标
                             //                         NSLog(@"END 转换之后：%f,%f",coor2.latitude,coor2.longitude);
                             
                             //初始化逆地理编码类
                             BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
                             
                             //需要逆地理编码的坐标位置
                             reverseGeoCodeOption.reverseGeoPoint = coor2;
                             [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
                             
                         }];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.strHeight       = self.strHeight;
                self.wellLatLbl.text = self.strLat;
                self.wellLonLbl.text = self.strLong;
            });
        });
        
        
        UIButton *btn     = (UIButton *)sender;
        self.RowWellmodel = self.arrProduct[btn.tag];
        
        self.editView = [[UIView alloc]init];
        self.editView.backgroundColor = [UIColor whiteColor];
        self.editView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
        
        self.mysv = [[UIScrollView alloc]init];
        [self.mysv setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.editView.frame.size.height)];
        [self.editView addSubview:self.mysv];
        
        
        
        self.wellIdTitleLbl = [[UILabel alloc]init];
        _wellIdTitleLbl.text = @"编号:";
        _wellIdTitleLbl.textColor = [UIColor blackColor];
        _wellIdTitleLbl.textAlignment = NSTextAlignmentRight;
        [self.mysv addSubview:self.wellIdTitleLbl];
        
        self.wellIdLbl = [[UITextField alloc]init];
        _wellIdLbl.textColor = [UIColor darkGrayColor];
        _wellIdLbl.text = self.RowWellmodel.pointId;
        _wellIdLbl.borderStyle = UITextBorderStyleRoundedRect;
        _wellIdLbl.enabled = NO;
        [self.mysv addSubview:self.wellIdLbl];
        
        self.wellLatTitleLbl = [[UILabel alloc]init];
        self.wellLatTitleLbl.text = @"经度:";
        _wellLatTitleLbl.textAlignment = NSTextAlignmentRight;
        self.wellLatTitleLbl.textColor = [UIColor blackColor];
        [self.mysv addSubview:self.wellLatTitleLbl];
        
        self.wellLatLbl = [[UITextField alloc]init];
        self.wellLatLbl.textColor = [UIColor darkGrayColor];
        _wellLatLbl.borderStyle = UITextBorderStyleRoundedRect;
        self.wellLatLbl.text = self.strLat;
        [self.mysv addSubview:self.wellLatLbl];
        
        /** 水位纬度*/
        self.wellLonTitleLbl = [[UILabel alloc]init];
        self.wellLonTitleLbl.textColor = [UIColor blackColor];
        self.wellLonTitleLbl.text = @"纬度:";
        _wellLonTitleLbl.textAlignment = NSTextAlignmentRight;
        [self.mysv addSubview:self.wellLonTitleLbl];
        
        self.wellLonLbl = [[UITextField alloc]init];
        self.wellLonLbl.textColor = [UIColor darkGrayColor];
        self.wellLonLbl.text = self.strLong;
        _wellLonLbl.borderStyle = UITextBorderStyleRoundedRect;
        [self.mysv addSubview:self.wellLonLbl];
        
        /** 水位地址*/
        
        self.wellAdsTitleLbl = [[UILabel alloc]init];
        self.wellAdsTitleLbl.text = @"地址:";
        _wellAdsTitleLbl.textAlignment = NSTextAlignmentRight;
        [self.mysv addSubview:self.wellAdsTitleLbl];
        
        self.wellAdsLbl = [[UITextView alloc]init];
        self.wellAdsLbl.textColor = [UIColor darkGrayColor];
        _wellAdsLbl.layer.borderColor = [UIColor colorWithHexString:addressColor].CGColor;
        _wellAdsLbl.layer.borderWidth = 1;
        [_wellAdsLbl.layer setCornerRadius:6];
        [_wellAdsLbl setFont:[UIFont systemFontOfSize:16]];
        self.wellAdsLbl.text = self.location;
        [self.mysv addSubview:self.wellAdsLbl];
        
        //SDLayout
        self.wellIdTitleLbl.sd_layout
        .heightIs(40)
        .widthIs(85)
        .leftSpaceToView(self.mysv,10)
        .topSpaceToView(self.mysv,10);
        
        self.wellIdLbl.sd_layout
        .heightIs(40)
        .leftSpaceToView(self.wellIdTitleLbl,10)
        .rightSpaceToView(self.mysv,10)
        .topSpaceToView(self.mysv,10);
        
        self.wellLatTitleLbl.sd_layout
        .heightIs(40)
        .widthIs(85)
        .leftSpaceToView(self.mysv,10)
        .topSpaceToView(self.wellIdTitleLbl,10);
        
        self.wellLatLbl.sd_layout
        .heightIs(40)
        .leftSpaceToView(self.wellLatTitleLbl,10)
        .topEqualToView(self.wellLatTitleLbl)
        .rightSpaceToView(self.mysv,10);
        
        self.wellLonTitleLbl.sd_layout
        .heightIs(40)
        .widthIs(85)
        .leftSpaceToView(self.mysv,10)
        .topSpaceToView(self.wellLatTitleLbl,10);
        
        self.wellLonLbl.sd_layout
        .heightIs(40)
        .leftSpaceToView(self.wellLonTitleLbl,10)
        .topEqualToView(self.wellLonTitleLbl)
        .rightSpaceToView(self.mysv,10);
        
        self.wellAdsTitleLbl.sd_layout
        .heightIs(40)
        .widthIs(85)
        .leftSpaceToView(self.mysv,10)
        .topSpaceToView(self.wellLonTitleLbl,8);
        
        self.wellAdsLbl.sd_layout
        .heightIs(80)
        .leftSpaceToView(self.wellAdsTitleLbl,10)
        .topSpaceToView(self.wellLonTitleLbl,10)
        .rightSpaceToView(self.mysv,10);
        
        
        [self.mysv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,300)];
        
        //确定
        _btnOk =[[UIButton alloc]initWithFrame:CGRectMake(0, _editView.frame.size.height- 50,[UIScreen mainScreen].bounds.size.width, 50)];
        [_btnOk addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchDown];
        [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
        [_btnOk.titleLabel setTextColor:[UIColor whiteColor]];
        _btnOk.backgroundColor =[UIColor colorWithHexString:correctColor];
        [self.editView addSubview:_btnOk];
        
        
        UIImageView *backgroundV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
        [self presentSemiView:self.editView withOptions:@{KNSemiModalOptionKeys.backgroundView:backgroundV}];
    }
}

- (void)commitAction {
    
    self.location = self.wellAdsLbl.text;
    self.strLong = self.wellLonLbl.text;
    self.strLat = self.wellLatLbl.text;
    
    [WaterDeviceCorrectApi apiWithErrorUpdate:self.RowWellmodel.pointId altitude:self.strHeight createUser:self.RowWellmodel.createUserAccntstr longitude:self.strLong latitude:self.strLat location:self.location successBlock:^() {
        [SVProgressHUD showSuccessWithStatus:@"纠错成功"];
        [self dismissSemiModalView];
    }];
}

#pragma mark - Private Method
-(void)getCodeAgained
{
    [self.arrProduct removeAllObjects];
    self.pageNum = 1;
    [self getListAction];
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
    cell.text  = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
    cell.typStr = @"水位纠错";
    cell.model = model;
    cell.rightBtn.tag = indexPath.row;
    cell.delegate = self;
}

/**
 * 获取经纬度
 */
-(void)getLat
{
    //获取经纬度
    [YNLocation getMyLocation:self.strLat
                    lontitude:self.strLong
                       height:self.strHeight
                 successBlock:^(NSString *strLat, NSString *strLon, NSString *strHeight) {
                     self.strLat = strLat;
                     self.strLong = strLon;
                     self.strHeight = strHeight;
                 }];
}

/**
 *   附近的水位列表地图展示
 *
 *  @return
 */
-(void)toErrorMapVC
{
    WaterDeviceInMapVC *wevc = [[WaterDeviceInMapVC alloc]init];
    wevc.arrLocation         = self.arrProduct;
    [self.navigationController pushViewController:wevc animated:YES];
}

/**
 *获取水位列表数据
 */
-(void)getListAction
{
    
    [WaterDeviceCorrectApi apiWithErrorList:self.strLong latitude:self.strLat pageNum:self.pageNum uiTableView:self.myTB arr:_arrProduct returnBlock:^{
        
        self.showArr = self.arrProduct;
        _errorTableView.items = self.showArr;
        [self.myTB reloadData];
    } successBlock:^{
        
        self.pageNum -= 1;
    }];
    NSLog(@"=-=%zd",_arrProduct.count);
}

/**
 *  设置TableView
 */
- (void)setYNTableView
{
    _errorTableView = [[YNTableView alloc]initWithItems:_arrProduct cellIdentifier:ID dataSourceBlock:^(WaterCell *cell, id model, NSIndexPath *indexPath) {
        [self setTheCellWithCell:cell model:model indexPath:indexPath];
        cell.rightBtn.tag = indexPath.row;
    } delegateBlock:^(NSIndexPath *indexPath) {
        if (!self.refreshFooter.isRefreshing)
        {
            WaterDeviceInMapVC *wevc = [[WaterDeviceInMapVC alloc]init];
            NSMutableArray *arrModel = [[NSMutableArray alloc]init];
            WaterModel *wmodel        = [[WaterModel alloc] init];
            wmodel = self.showArr[indexPath.row];
            [arrModel addObject:wmodel];
            wevc.arrLocation = arrModel;
            [self.navigationController pushViewController:wevc animated:YES];
        }
        
    }];
    _errorTableView.YNTableView = self.myTB;
    __weak typeof(self) weakSelf = self;
    
    // 上下滚动视图的时候让搜索栏消失或出现
//    _errorTableView.scrollBlock = ^(CGPoint velocity){
//        
//        if (velocity.y > 30.0)
//        {
//            [UIView animateWithDuration:0.5f animations:^{
//                weakSelf.mySearchBar.frame = CGRectMake(0, 0, weakSelf.view.bounds.size.width, 44);
//            }];
//        }else{
//            [UIView animateWithDuration:0.5f animations:^{
//                weakSelf.mySearchBar.frame = CGRectMake(0, 64, weakSelf.view.bounds.size.width, 44);
//            }];
//        }
//    };
    // 视图滚动到顶端让搜索栏出现
    _errorTableView.scrollToTopBlock = ^(){
        
        weakSelf.mySearchBar.frame = CGRectMake(0, 64, weakSelf.view.bounds.size.width, 44);
    };
    
    self.myTB.dataSource = _errorTableView;
    self.myTB.delegate   = _errorTableView;
    
    [self.myTB registerClass:[WaterCell class] forCellReuseIdentifier:ID];
}

- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        
        [self.arrProduct removeAllObjects];
        self.pageNum = 1;
        [self getListAction];
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
    self.myTB.header = header;
    self.myTB.footer = footer;
}


@end
