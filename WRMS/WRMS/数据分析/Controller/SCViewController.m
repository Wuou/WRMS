//
//  SCViewController.m
//  SCChart
//
//  Created by 2014-763 on 15/3/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCViewController.h"
#import "SCChart.h"

@interface SCViewController () <SCChartDataSource>

/** 图表*/
@property (nonatomic, strong) SCChart *chartView;

/** 选择的时间*/
@property (nonatomic, strong) UILabel *dateLabel;

/** datePiker所在的view*/
@property (nonatomic,strong ) UIView                 *viewTime;
/** 日期选择器*/
@property (nonatomic,strong ) UIDatePicker           *workPick;
/** 确定按钮*/
@property (nonatomic,strong ) UIButton               *btnOk;
/** 选中的日期*/
@property (nonatomic,strong ) NSString               *workTime;
/** 结束日期*/
@property (nonatomic,strong ) NSString               *endTimeStr;
/** 开始日期*/
@property (nonatomic,strong ) NSString               *startTimeStr;

/** 第一组数据*/
@property (nonatomic, strong) NSMutableArray         *mArrY_Chart;
/** 日期数组*/
@property (nonatomic, strong) NSMutableArray         *mArrX_Month;
/** 第二个数组 */
@property (nonatomic,strong ) NSMutableArray         *chartData2;

@end

@implementation SCViewController
static NSString *reuseIdentifierChart = @"SCChartCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建一个滚动视图，将图表放于滚动视图上
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 94, kWidth, kHeight - 124)];
    scrollView.contentSize = CGSizeMake(5 * kWidth / 2, kHeight - 124 - 64);
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    
    // 制作图表UI
    _chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, -64, 5 * kWidth / 2 - 20, kHeight - 124) withSource:self withStyle:SCChartLineStyle];
    [_chartView showInView:scrollView];
    
    // 设置开始时间，结束时间，并给顶部时间label赋值
    [self setTheTimeInView];
    
    // 初始化数组，获取图表数据
    self.mArrY_Chart = [[NSMutableArray alloc]init];
    self.chartData2  = [[NSMutableArray alloc]init];
    self.mArrX_Month = [[NSMutableArray alloc]init];
    [self getConnDataFromTitle];
    
    // 导航栏右侧添加日期选择按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dateIcon"] style:(UIBarButtonItemStylePlain) target:self action:@selector(showTimeView:)];
    
    // 设置日期选择界面
    [self setTimePickerView];
    
    // 设置图表左下角的label，对折线的说明
    [self setExplainOfPolyline];
}

#pragma mark - Event Response
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
        self.dateLabel.text = self.workTime;
        // 获取数组
        [self getConnDataFromTitle];
        [self dismissSemiModalView];
    }
}


#pragma mark - Private Methods
/**
 *  获取图表数据
 */

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
        // 刷新图表数据
        [_chartView strokeChart];
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
        // 刷新图表数据
        [_chartView strokeChart];
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
        // 刷新图表数据
        [_chartView strokeChart];
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
        // 刷新图表数据
        [_chartView strokeChart];
    }];
}

/**
 *  设置图表需要用到的时间和顶部的时间label
 */
- (void)setTheTimeInView {
    
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
    
    // 设置时间
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, kWidth, 20)];
    _dateLabel.text = self.workTime;
    _dateLabel.textColor = [UIColor darkGrayColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_dateLabel];
}

/**
 *  设置左下角label，对折线做说明
 */
- (void)setExplainOfPolyline {
    
    UILabel *waterTrendLB = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight - 25, 80, 20)];
    waterTrendLB.textColor = SCGreen;
    waterTrendLB.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:waterTrendLB];
    
    UILabel *terminalNumLB = [[UILabel alloc] initWithFrame:CGRectMake(80, kHeight - 25, 150, 20)];
    terminalNumLB.textColor = SCRed;
    terminalNumLB.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:terminalNumLB];
    
    if ([self.title isEqualToString:@"水位报警工单日统计"]|| [self.title isEqualToString:@"水位报警工单月统计"]) {
        
        waterTrendLB.text = @"已完成工单数";
        terminalNumLB.text = @"执行效率（个/小时）";
    }else{
        
        waterTrendLB.text = @"平均水位高度";
        terminalNumLB.text = @"自检终端数量";
    }
}

/**
 *   设置日期选择界面
 */
- (void)setTimePickerView {
    
    //时间选择 父view
    self.viewTime = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 250, self.view.bounds.size.width, 250)];
    self.viewTime.backgroundColor = [UIColor whiteColor];
    
    //时间选择组件
    self.workPick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,54,self.viewTime.bounds.size.width,200)];
    [self.workPick setValue:[UIColor darkGrayColor] forKey:@"textColor"];
    self.workPick.tintColor = [UIColor whiteColor];
    [self.workPick setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    self.workPick.datePickerMode = UIDatePickerModeDate;
    [self.viewTime addSubview:self.workPick];
    
    //时间选择后确定按钮
    self.btnOk = [[UIButton alloc]initWithFrame:CGRectMake(self.viewTime.frame.size.width - 93, 5, 88, 44)];
    [self.btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnOk setBackgroundColor:[UIColor colorWithHexString:@"00c0f1"]];
    [self.btnOk.layer setCornerRadius:8];
    [self.btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnOk addTarget:self action:@selector(timeOkAction) forControlEvents:UIControlEventTouchDown];
    [self.btnOk.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.viewTime addSubview:self.btnOk];
}

/**
 *  展示图表下的日期
 *
 *  @param num 个数
 *
 *  @return 数组
 */
- (NSArray *)getXTitles:(int)num {
    
    NSMutableArray *dayTitleArr = [NSMutableArray array];
    [self.mArrX_Month enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *dateStr = (NSString *)obj;
        if ([self.title isEqualToString:@"水位报警工单日统计"]|| [self.title isEqualToString:@"水位趋势日统计"]){
            
            NSString *dayStr = [dateStr substringFromIndex:5];
            [dayTitleArr addObject:dayStr];
        }
    }];
    
    if ([self.title isEqualToString:@"水位报警工单日统计"]|| [self.title isEqualToString:@"水位趋势日统计"]) {
        
        return dayTitleArr;
    }else{
        
        return self.mArrX_Month;
    }
}

#pragma mark - SCChart Delegate
//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    
    return [self getXTitles:(int)self.mArrX_Month.count];
}

//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
    
//    NSMutableArray *ary = [NSMutableArray array];
//    NSMutableArray *ary2 = [NSMutableArray array];
//    for (NSInteger i = 0; i < 30; i++) {
//        CGFloat num = arc4random_uniform(1000) / 100;
//        NSString *str = [NSString stringWithFormat:@"%f",num];
//        [ary addObject:str];
//    }
//    for (NSInteger i = 0; i < 30; i++) {
//        CGFloat num = arc4random_uniform(1000) / 100;
//        NSString *str = [NSString stringWithFormat:@"%f",num];
//        [ary2 addObject:str];
//    }
    if (self.mArrY_Chart.count > 0 && self.chartData2.count > 0) {
        
        return @[self.mArrY_Chart,self.chartData2];
    }else{
        
        return nil;
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCGreen,SCRed,SCBlue];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart {
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return YES;
}


@end
