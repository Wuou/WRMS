//
//  JBBarChartViewController.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBarChartViewController.h"
// Views
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"
#import "JBFontConstants.h"
#import "JBColorConstants.h"
#import "JBStringConstants.h"
#import "YNSegment.h"
#import "UIColor-Expanded.h"
#import "SVProgressHUD.h"
#import "UIViewController+KNSemiModal.h"
#import "dateAiyvcModel.h"
#import "YNRequest.h"
#import "DataAlyApi.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight         = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding        = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight   = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding  = 20.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight   = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding  = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding          = 1.0f;
NSInteger const kJBBarChartViewControllerNumBars           = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight      = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight      = 5;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface JBBarChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

/** 图表展示view*/
@property (nonatomic, strong) JBBarChartView         *barChartView;
/** 图表信息展示view*/
@property (nonatomic, strong) JBChartInformationView *informationView;
/** 图表区头展示view*/
@property (nonatomic, strong) JBChartHeaderView      *headerView;
/** 图表区尾展示view*/
@property (nonatomic, strong) JBBarChartFooterView   *footerView;
/** 第一组数据*/
@property (nonatomic, strong) NSMutableArray         *mArrY_Chart;
/** 日期数组*/
@property (nonatomic, strong) NSMutableArray         *mArrX_Month;
/** 第二个数组 */
@property (nonatomic,strong ) NSMutableArray         *chartData2;
/** 当前数组，也就是选中条件对应的数组*/
@property (nonatomic,strong ) NSMutableArray         *arrChartNow;
/** 滚动视图*/
@property (nonatomic,strong ) YNSegment              *scrollBtnView;
/** datePiker所在的view*/
@property (nonatomic,strong ) UIView                 *viewTime;
/** 分割线1*/
@property (nonatomic,strong ) UILabel                *labelLine1;
/** 分割线2*/
@property (nonatomic,strong ) UILabel                *labelLine2;
/** 确定按钮*/
@property (nonatomic,strong ) UIButton               *btnOk;
/** 取消按钮*/
@property (nonatomic,strong ) UIButton               *btnCancel;
/** 日期选择器*/
@property (nonatomic,strong ) UIDatePicker           *workPick;
/** 选择的下标*/
@property (nonatomic,assign ) NSInteger              selectIndex;
/** 选中的日期*/
@property (nonatomic,strong ) NSString               *workTime;
/** 结束日期*/
@property (nonatomic,strong ) NSString               *endTimeStr;
/** 开始日期*/
@property (nonatomic,strong ) NSString               *startTimeStr;

@end

@implementation JBBarChartViewController

#pragma mark - VC life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

/**
 *  设置图表的样式
 *
 *  @param animated animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.barChartView setState:JBChartViewStateExpanded];
}

/**
 *  属性的初始化, 控件的设置
 */
-(void)viewDidLoad
{
    self.arrChartNow = [[NSMutableArray alloc]init];
    self.mArrY_Chart = [[NSMutableArray alloc]init];
    self.chartData2  = [[NSMutableArray alloc]init];
    self.mArrX_Month = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = kJBColorBarChartControllerBackground;
    self.navigationItem.rightBarButtonItem = [self chartToggleButtonWithTarget:self action:@selector(showTimeView:)];
    
    //时间选择 父view
    self.viewTime = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 250, self.view.bounds.size.width, 250)];
    self.viewTime.backgroundColor = [UIColor colorWithHexString:@"3c3c3c"];
    
    //时间选择组件
    self.workPick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,54,self.viewTime.bounds.size.width,200)];
    [self.workPick setValue:[UIColor whiteColor] forKey:@"textColor"];
    self.workPick.tintColor = [UIColor whiteColor];
    [self.workPick setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    self.workPick.datePickerMode = UIDatePickerModeDate;
    [self.viewTime addSubview:self.workPick];
    
    //时间选择后确定按钮
    self.btnOk = [[UIButton alloc]initWithFrame:CGRectMake(self.viewTime.frame.size.width - 93, 5, 88, 44)];
    [self.btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnOk setBackgroundColor:[UIColor colorWithHexString:@"f35854"]];
    [self.btnOk.layer setCornerRadius:8];
    [self.btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnOk addTarget:self action:@selector(timeOkAction) forControlEvents:UIControlEventTouchDown];
    [self.btnOk.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.viewTime addSubview:self.btnOk];
    
    //开始时间和结束时间
    NSDate* _date                   = [NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];

    self.endTimeStr                 = [dateformatter stringFromDate:_date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:_date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-11];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:_date options:0];
    self.startTimeStr = [dateformatter stringFromDate:newdate];
    
    
    if ([self.title isEqualToString:@"水位趋势日统计"] || [self.title isEqualToString:@"水位报警工单日统计"])
    {
        self.workTime = self.endTimeStr;
    }else
    {
        self.workTime = [NSString stringWithFormat:@"%@ 至 %@",self.startTimeStr,self.endTimeStr];
    }
    
    //获取图表数据
    [self getConnDataFromTitle];
    
    //图表柱状
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding, kJBBarChartViewControllerChartPadding, self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeight);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.minimumValue = 0.0f;
    self.barChartView.inverted = NO;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    //图表表头顶部的信息
    self.headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeaderHeight)];
    self.headerView.subtitleLabel.text = self.workTime;
    self.headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
    self.barChartView.headerView = self.headerView;
    
    //图表底部，比如点击柱状图显示的view
    self.footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartFooterHeight)];
    self.footerView.padding = kJBBarChartViewControllerChartFooterPadding;
    self.footerView.leftLabel.textColor = [UIColor whiteColor];
    self.footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = self.footerView;
    //图表底部的文字
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.barChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.barChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.view addSubview:self.informationView];
    [self.informationView setTitleText:self.naviTitle1];
    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
    
    //图表顶部的分类seqement
    _scrollBtnView = [[YNSegment alloc] initWithFrame:(CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 40, 30)) withBtnArr:@[self.naviTitle1,self.naviTitle2]];
    [self.headerView addSubview:_scrollBtnView];
    self.selectIndex = 0;
    typeof(self) weakSelf  = self;
    _scrollBtnView.myBlock = ^(NSInteger i){
        if (i == 0)
        {
            weakSelf.selectIndex = 0;
            [weakSelf.barChartView reloadData];
        }
        if (i == 1)
        {
            weakSelf.selectIndex = 1;
            [weakSelf.barChartView reloadData];
        }
    };
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


/**
 *  dealloc里将delegate置空, 防止循环引用, 节约内存
 */
- (void)dealloc
{
    _barChartView.delegate = nil;
    _barChartView.dataSource = nil;
}

#pragma mark - JBChartViewDataSource
- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}

#pragma mark - JBBarChartViewDataSource
- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    NSInteger num;
    
    if(self.selectIndex == 0)
    {
        num = [self.mArrY_Chart count];
    }else{
        num = [self.chartData2 count];
    }
    return num;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber;
    
    [self.informationView setHidden:NO animated:YES];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    
    NSString *tipStr = [self.mArrX_Month objectAtIndex:index];
    [self.tooltipView setText:tipStr];
    if ([self.title isEqualToString:@"水位报警工单日统计"]|| [self.title isEqualToString:@"水位趋势日统计"])
    {
        [self.tooltipView setText:[tipStr substringFromIndex:5]];
    }else{
        [self.tooltipView setText:tipStr];
    }
    
    if(self.selectIndex == 0)
    {
        valueNumber = [self.mArrY_Chart objectAtIndex:index];
    }else
    {
        valueNumber = [self.chartData2 objectAtIndex:index];
    }
    
    if ([self.title isEqualToString:@"水位报警工单月统计"] && self.selectIndex == 1)
    {
        [self.informationView setValueText:[NSString stringWithFormat:@"%@小时", valueNumber] unitText:nil];
    }else if ([self.title isEqualToString:@"水位报警工单日统计"] && self.selectIndex == 1)
    {
        [self.informationView setValueText:[NSString stringWithFormat:@"%@小时", valueNumber] unitText:nil];
    }else if ([self.title isEqualToString:@"水位趋势月统计"] && self.selectIndex == 0)
    {
        [self.informationView setValueText:[NSString stringWithFormat:@"%@米",valueNumber] unitText:nil];
    }else if ([self.title isEqualToString:@"水位趋势日统计"] && self.selectIndex == 0)
    {
        [self.informationView setValueText:[NSString stringWithFormat:@"%@米",valueNumber] unitText:nil];
    }
    else
    {
        [self.informationView setValueText:[NSString stringWithFormat:@"%@个",valueNumber] unitText:nil];
    }
    
    if (self.selectIndex == 0)
    {
        [self.informationView setTitleText:self.naviTitle1];
    }else
    {
        [self.informationView setTitleText:self.naviTitle2];
    }
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self.informationView setHidden:YES animated:YES];
    [self setTooltipVisible:NO animated:YES];
}

#pragma mark - JBBarChartViewDelegate
- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    
    CGFloat height;
    
    if (self.selectIndex == 0)
    {
        height = [[self.mArrY_Chart objectAtIndex:index] floatValue];
    }else
    {
        height = [[self.chartData2 objectAtIndex:index] floatValue];
    }
    return height;
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    NSInteger count1 = 0; // 判断第一个数组中0的个数
    NSInteger count2 = 0; // 判断第二个数组中0的个数
//    NSLog(@"%d", self.selectIndex);
    if (self.selectIndex == 0)
    {
        for (NSNumber *strCoverNum in self.mArrY_Chart)
        {
            if ([[strCoverNum stringValue] isEqualToString:@"0"])
            {
                count1 ++;
            }
        }
        // 如果数据全为0，图表颜色为透明
        if (count1 == self.mArrY_Chart.count)
        {
            return [UIColor clearColor];
        }else{
            return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
        }
    }else{
        
        for (NSNumber *strMchnNum in self.chartData2)
        {
            if ([[strMchnNum stringValue] isEqualToString:@"0"])
            {
                count2 ++;
            }
        }
        // 如果数据全为0，图表颜色为透明
        if (count2 == self.chartData2.count)
        {
            return [UIColor clearColor];
        }else{
            return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
        }
    }
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

#pragma mark - Hidden Buttons
- (void)chartToggleButtonPressed:(id)sender
{
    UIView *buttonImageView                = [self.navigationItem.rightBarButtonItem valueForKey:kJBBarChartViewControllerNavButtonViewKey];
    buttonImageView.userInteractionEnabled = NO;
    CGAffineTransform transform            = self.barChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    buttonImageView.transform              = transform;
    [self.barChartView setState:self.barChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
        buttonImageView.userInteractionEnabled = YES;
    }];
}

#pragma mark - Show DatePicker
/**
 *  展示日期选择器, 放在一个动画窗口下
 *
 *  @param sender sender
 */
-(void)showTimeView:(id)sender
{
    UIImageView *backgroundV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
    [self presentSemiView:self.viewTime withOptions:@{KNSemiModalOptionKeys.backgroundView:backgroundV}];
}

/**
 *  选择好日期后的回调方法
 */
-(void)timeOkAction
{
    NSDate* _date                   = self.workPick.date;
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM"];
    self.endTimeStr                 = [dateformatter stringFromDate:_date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:_date];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:-11];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:_date options:0];
    self.startTimeStr = [dateformatter stringFromDate:newdate];
    
    
    NSDate *  senddate              = [NSDate date];
    NSDateFormatter  *dateformatterNow=[[NSDateFormatter alloc] init];
    [dateformatterNow setDateFormat:@"yyyy-MM"];
    NSString *  locationString      = [dateformatterNow stringFromDate:senddate];
    
    if ([[self.endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue] >  [[locationString stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue])
    {
        [SVProgressHUD showErrorWithStatus:@"无法选择该日期"];
    }else
    {
        if ([self.title isEqualToString:@"水位趋势日统计"] || [self.title isEqualToString:@"水位报警工单日统计"])
        {
            self.workTime = self.endTimeStr;
        }else
        {
            self.workTime = [NSString stringWithFormat:@"%@ 至 %@",self.startTimeStr,self.endTimeStr];
        }
        self.headerView.subtitleLabel.text = self.workTime;
        [self getConnDataFromTitle];
        [self dismissSemiModalView];
    }
}

/**
 *  点击空白区域取消选择日期界面
 */
-(void)timeCancelAction
{
    [self dismissSemiModalView];
}

#pragma mark - Overrides
- (JBChartView *)chartView
{
    return self.barChartView;
}

#pragma mark - Get Connec Data
-(void)getConnDataFromTitle
{
    if ([self.title isEqualToString:@"水位报警工单月统计"])
    {
        [self getAlarmOrderMonth];
    }else if([self.title isEqualToString:@"水位报警工单日统计"])
    {
        [self getAlarmOrderDay];
    }else if([self.title isEqualToString:@"水位趋势月统计"])
    {
        [self getWaterMonth];
    }else if([self.title isEqualToString:@"水位趋势日统计"])
    {
        [self getWaterDay];
    }
}


/**
 *  水位报警工单月统计
 */
-(void)getAlarmOrderMonth
{
    [self.mArrY_Chart removeAllObjects];
    [self.chartData2 removeAllObjects];
    [self.mArrX_Month removeAllObjects];
    [DataAlyApi apiWithAlarmOrderMonth:self.startTimeStr endTime:self.endTimeStr nsArr:self.mArrY_Chart nsArr2:self.chartData2 nsArrX:_mArrX_Month successBlock:^() {
        [self setFooterViewText];
    }];
}


/**
 *  水位报警工单日统计
 */
-(void)getAlarmOrderDay
{
    [self.mArrY_Chart removeAllObjects];
    [self.chartData2 removeAllObjects];
    [self.mArrX_Month removeAllObjects];
    [DataAlyApi apiWithAlarmOrderDay:self.endTimeStr nsArr:self.mArrY_Chart nsArr2:self.chartData2 nsArrX:self.mArrX_Month successBlock:^() {
        [self setFooterViewText];
    }];
}

/**
 *  水位趋势月统计
 */
-(void)getWaterMonth
{

    [self.mArrY_Chart removeAllObjects];
    [self.chartData2 removeAllObjects];
    [self.mArrX_Month removeAllObjects];
//    NSLog(@"%@", self.startTimeStr);
//    NSLog(@"%@", self.endTimeStr);
    [DataAlyApi apiWithWaterMonth:self.startTimeStr endTime:self.endTimeStr nsArr:self.mArrY_Chart nsArr2:self.chartData2 nsArrX:_mArrX_Month successBlock:^{
        [self setFooterViewText];
    }];
}

/**
 *  水位趋势日统计
 */
-(void)getWaterDay
{
    [self.mArrY_Chart removeAllObjects];
    [self.chartData2 removeAllObjects];
    [self.mArrX_Month removeAllObjects];
//    NSLog(@"%@", self.startTimeStr);
//    NSLog(@"%@", self.endTimeStr);
    [DataAlyApi apiWithWaterDay:self.endTimeStr nsArr:self.mArrY_Chart nsArr2:self.chartData2 nsArrX:_mArrX_Month successBlock:^{
        [self setFooterViewText];
    }];
}

/**
 *  刷新footerView的起始日期和结束日期Text
 */
-(void)setFooterViewText
{
    self.footerView.leftLabel.text  = [[self.mArrX_Month firstObject] uppercaseString];
    self.footerView.rightLabel.text = [[self.mArrX_Month lastObject] uppercaseString];
    [self.barChartView reloadDataAnimated:YES];
}
@end
