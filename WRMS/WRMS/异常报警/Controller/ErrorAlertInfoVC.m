//
//  EventManagementInfoVC.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "ErrorAlertInfoVC.h"
#import "ErrorAlertModel.h"
#import "AlarmOrderLogListModel.h"
#import "AlarmOrderLogListCell.h"
#import "LogItemModel.h"
#import "YYAnimatedImageView.h"
#import "YYWebImage.h"
#import "EventManagementApi.h"
#import "CompleteEventVC.h"
#import "EventDealVC.h"
#import "RichMediaModel.h"
#import "IssuedOrderVC.h"

#define  PIC_WIDTH 120
#define  PIC_HEIGHT 120
#define  INSETS 18

static NSString *identity = @"orderListcell";
@interface ErrorAlertInfoVC ()<UITableViewDelegate,UITableViewDataSource>
/** 右侧+按钮*/
@property(nonatomic,strong)YNNavigationRightBtn *rightBtn;
/** 点击地址栏，显示一行或者多行*/
@property (weak, nonatomic) IBOutlet UIButton *addrDesBtn;
/** 展示媒体的scrollView*/
@property(nonatomic,strong)IBOutlet UIScrollView *mediasv;
@property(nonatomic,strong)IBOutlet UITableView *mytb;
/** 记录列表*/
@property (nonatomic,strong)NSMutableArray *alarmOrderListArr;
/** 显示媒体数量*/
@property (weak, nonatomic) IBOutlet UILabel *mediaNumLbl;
/** 工单列表数量*/
@property (weak, nonatomic) IBOutlet UILabel *orderListNumLbl;
/** 给报警处理详情页面传的媒体文件数组*/
@property(nonatomic,strong)NSMutableArray *arrMediaToDealVC;
@property (nonatomic,strong)LogItemModel  *itemModel;
/** 总富媒体个数*/
@property(nonatomic,strong)NSMutableArray *arrAllMedia;
/** 照片*/
@property(nonatomic,strong)NSMutableArray *arrMediaPic;
/** 视频*/
@property(nonatomic,strong)NSMutableArray *arrMediaMp4;
/** 音频*/
@property(nonatomic,strong)NSMutableArray *arrMediaMp3;
/** 视频个数*/
@property(nonatomic,assign)NSInteger vedioNum;
/** 音频个数*/
@property(nonatomic,assign)NSInteger voiceNum;
/** 判断是否离线模式*/
@property (nonatomic, assign) BOOL isShowAddr;
/** 报警模块View*/
@property (weak, nonatomic) IBOutlet UIView *eventView;
/** 处理模块View*/
@property (weak, nonatomic) IBOutlet UIView *dealView;
/** 媒体展示模块View*/
@property (weak, nonatomic) IBOutlet UIView *mediaView;
/** 地址底部分割线*/
@property (weak, nonatomic) IBOutlet UILabel *locBottomLineLbl;
/** 处理详情标题*/
@property (weak, nonatomic) IBOutlet UILabel *dealDescTitle;
/** 详情内容*/
@property (weak, nonatomic) IBOutlet UILabel *descContentLbl;
/** 详情顶部分割线*/
@property (weak, nonatomic) IBOutlet UILabel *descTopLineLbl;
/** 详情底部分割线*/
@property (weak, nonatomic) IBOutlet UILabel *descBottomLbl;
/** 媒体底部分割线*/
@property (weak, nonatomic) IBOutlet UILabel *mediaBottomLbl;
/** 处理列表View*/
@property (weak, nonatomic) IBOutlet UIView *dealListView;
/** 报警原因标题*/
@property (weak, nonatomic) IBOutlet UILabel *eventReasonTitleLbl;
/** 报警原因顶部分割线*/
@property (weak, nonatomic) IBOutlet UILabel *reasonTopLine;
/** 媒体三角图片*/
@property(nonatomic,strong)IBOutlet UIImageView *imgSanjiaoMedia;
/** 记录三角图片*/
@property(nonatomic,strong)IBOutlet UIImageView *imgSanjiaoJilu;
@end

@implementation ErrorAlertInfoVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"报警工单详情";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.vedioNum = 0;
    self.voiceNum = 0;
    self.mySV.backgroundColor =[UIColor colorWithHexString:@"F4F4F4"];
    self.arrMediaToDealVC     = [[NSMutableArray alloc] init];
    self.alarmOrderListArr    = [[NSMutableArray alloc] init];
    self.arrAllMedia          = [[NSMutableArray alloc] init];
    self.arrMediaMp3          = [[NSMutableArray alloc] init];
    self.arrMediaMp4          = [[NSMutableArray alloc] init];
    self.arrMediaPic          = [[NSMutableArray alloc] init];
    
    [self getOrderDealListAction];
    
    //设置内容
    [self setText];
    [self setSubviewsAutoLayout];
    self.isShowAddr = NO;
    //editBtn
    if ([self.strFromType isEqualToString:@"工单"]) {
        if ([self.wmodel.status isEqualToString:@"0001"]) {
            // 下发工单
            _rightBtn = [[YNNavigationRightBtn alloc]initWith:@"" img:@"ic_task_send" contro:self];
            __weak typeof(self) weakSelf = self;
            _rightBtn.clickBlock = ^(){
                [weakSelf toIssuedVC];
            };
        }else{
            // 修改工单
            _rightBtn = [[YNNavigationRightBtn alloc]initWith:@"" img:@"edit" contro:self];
            __weak typeof(self) weakSelf = self;
            _rightBtn.clickBlock = ^(){
                [weakSelf toUpdateStateVC];
            };
        }
    }
    
    self.mytb.bounces = NO;
    [self.mytb registerClass:[AlarmOrderLogListCell class] forCellReuseIdentifier:identity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - tableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.orderListNumLbl.text = [NSString stringWithFormat:@"%zd",[self.alarmOrderListArr count]];
    return self.alarmOrderListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlarmOrderLogListCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    cell.orderListModel = self.alarmOrderListArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.arrMediaToDealVC removeAllObjects];
    EventDealVC *evc = [[EventDealVC alloc]init];
    AlarmOrderLogListModel *amodel = self.alarmOrderListArr[indexPath.row];
    evc.eModel = amodel;
    [self.navigationController pushViewController:evc animated:YES];
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mytb deselectRowAtIndexPath:[self.mytb indexPathForSelectedRow] animated:YES];
    });
}

#pragma mark - private methods
/**
 *  跳转到修改报警界面
 */
- (void)toUpdateStateVC {
    CompleteEventVC *covc =[[CompleteEventVC alloc]init];
    covc.strEventId = self.orderIdStr;
    covc.strPointId = self.wmodel.pointId;
    [self.navigationController pushViewController:covc animated:YES];
}

/**
 *  跳转到任务下发界面
 */
- (void)toIssuedVC {
    
    IssuedOrderVC *iovc = [[IssuedOrderVC alloc]init];
    iovc.strOrderId = self.wmodel.orderId;
    iovc.strOrderUnitId = self.wmodel.unitId;
    [self.navigationController pushViewController:iovc animated:YES];
}

- (void)setText {
    self.alarmTypeLbl.text         = self.wmodel.alarmTypeName;
    self.alarmLevelLbl.text        = self.wmodel.alarmLevelName;
    self.createUserAccntLbl.text   = self.wmodel.updateUserAccnt;
    self.dealTimeLbl.text          = self.wmodel.updateTime;
    self.descContentLbl.text       = self.wmodel.statusName;
    self.alarmReasonLbl.text       = self.wmodel.alarmReason;
    self.locationLbl.text          = self.wmodel.location;
}

//展示富媒体
- (void)viewMedia{
    int i;
    int n = 0;
    LYPhoto *photo;
    //添加10个Button
    for(i = 0; i< [self.arrAllMedia count];i++)
    {
        RichMediaModel *rmediamodel = [self.arrAllMedia objectAtIndex:i];
        UIButton *buttonview = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonview.tag = 10000 + i;
        //设置button的大小
        buttonview.frame = CGRectMake(INSETS+n, INSETS, PIC_WIDTH,PIC_HEIGHT);
        [buttonview addTarget:self action:@selector(buttonMediaAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mediasv addSubview:buttonview];
        
        YYAnimatedImageView *webImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(INSETS+n, INSETS, PIC_WIDTH,PIC_HEIGHT)];
        [self.mediasv addSubview:webImageView];
        
        n = n+129;
        if ([rmediamodel.mtype integerValue] == 0) {
            //照片
            [webImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",rmediamodel.mconUrl]]
                                 placeholder:nil
                                     options:YYWebImageOptionSetImageWithFadeAnimation
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                    }
                                   transform:^UIImage *(UIImage *image, NSURL *url) {
                                       image = [image yy_imageByResizeToSize:CGSizeMake(PIC_WIDTH, PIC_HEIGHT) contentMode:UIViewContentModeCenter];
                                       return [image yy_imageByRoundCornerRadius:10];
                                   }
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      if (from == YYWebImageFromDiskCache) {
                                          NSLog(@"load from disk cache");
                                      }
                                  }];
            
            [buttonview setImage:webImageView.image forState:UIControlStateNormal];
            photo = [LYPhoto photoWithImageView:webImageView placeHold:webImageView.image photoUrl:[NSString stringWithFormat:@"%@",rmediamodel.mconUrl]];
            [self.arrMediaPic addObject:photo];
        }
        if ([rmediamodel.mtype integerValue] == 1) {//视频
            self.vedioNum  =  self.vedioNum + 1;
            [buttonview setImage:[UIImage imageNamed:@"videoIcon"] forState:UIControlStateNormal];
        }
        if ([rmediamodel.mtype integerValue] == 2) {//音频
            self.voiceNum  = self.voiceNum + 1;
            [buttonview setImage:[UIImage imageNamed:@"voiceIcon"] forState:UIControlStateNormal];
        }
    }
    
}

//媒体点击报警
- (void)buttonMediaAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"索引＝%zd",btn.tag-10000);
    RichMediaModel *rmediamodel = [self.arrAllMedia objectAtIndex:btn.tag -10000];
    NSString *urlstr = rmediamodel.mconUrl;
    NSString *typestr = rmediamodel.mtype;
    if ([typestr integerValue ] == 0) {//照片
        NSLog(@"%zd,%zd,%zd",btn.tag - 10000,self.voiceNum,self.vedioNum);
        NSInteger picindex = btn.tag -10000 - self.voiceNum - self.vedioNum;
        if(picindex < 0){
            picindex = 0;
        }
        [LYPhotoBrowser showPhotos:self.arrMediaPic currentPhotoIndex: picindex countType:LYPhotoBrowserCountTypeCountLabel];
        
    }
    if ([typestr integerValue ]== 1) {//视频
        //预览视频
        ZXVideoPlayerViewController *videoVC = [[ZXVideoPlayerViewController alloc]init];
        [self presentViewController:videoVC animated:YES completion:nil];
        videoVC.videoUrl =[NSString stringWithFormat:@"%@",urlstr];
        NSLog(@"===%@",videoVC.videoUrl);
    }
    
    if ([typestr integerValue ]== 2) {//音频
        //预览音频
        ZXVideoPlayerViewController *videoVC = [[ZXVideoPlayerViewController alloc]init];
        [self presentViewController:videoVC animated:YES completion:nil];
        videoVC.videoUrl =[NSString stringWithFormat:@"%@",urlstr];
    }
}

/**
 *  界面控件自适应布局
 */
- (void)setSubviewsAutoLayout {
    //报警原因
    self.alarmReasonLbl.sd_layout
    .leftSpaceToView(self.eventReasonTitleLbl,5)
    .topSpaceToView(self.reasonTopLine,8)
    .widthIs([UIScreen mainScreen].bounds.size.width - 78)
    .autoHeightRatio(0);
    
    if (self.alarmReasonLbl.text.length == 0) {
        self.cutLbl.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .topSpaceToView(self.eventReasonTitleLbl,0)
        .leftSpaceToView(self.eventView,0);
    }else{
        self.cutLbl.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .topSpaceToView(self.alarmReasonLbl,10)
        .leftSpaceToView(self.eventView,0);
    }
    
    self.locationTitle.sd_layout
    .leftSpaceToView(self.eventView,0)
    .widthIs(75)
    .topSpaceToView(self.cutLbl,0)
    .heightIs(38);
    
    // 报警地址
    self.locationLbl.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width - 78)
    .autoHeightRatio(0)
    .leftSpaceToView(self.locationTitle, 5)
    .topSpaceToView(self.cutLbl, 10);
    
    // 地址下面分割线
    if (self.locationLbl.text.length == 0)
    {
        self.eventView.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .bottomSpaceToView(self.locBottomLineLbl,0)
        .leftSpaceToView(self.mySV, 0)
        .topSpaceToView(self.mySV, 0);
    }else{
        self.locBottomLineLbl.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.mySV, 0)
        .topSpaceToView(self.locationLbl, 3);
        
        self.eventView.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .bottomSpaceToView(self.locBottomLineLbl,-6)
        .leftSpaceToView(self.mySV, 0)
        .topSpaceToView(self.mySV, 0);
    }
    
 
    
    self.dealView.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width)
    .leftSpaceToView(self.mySV,0)
    .topSpaceToView(self.eventView,8)
    .rightSpaceToView(self.mySV,0)
    .heightIs(113);
    
    self.descContentLbl.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width - 78)
    .autoHeightRatio(0)
    .leftSpaceToView(self.dealDescTitle,3)
    .topSpaceToView(self.descTopLineLbl,10);

}

- (IBAction)addrShowDesBtnAction:(UIButton *)sender {
    if (!self.isShowAddr) {
        [UIView animateWithDuration:0.5 animations:^{
            self.locationLbl.numberOfLines = 0;
            
        }];
        self.isShowAddr = !self.isShowAddr;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.locationLbl.numberOfLines = 1;
        }];
        self.isShowAddr = !self.isShowAddr;
    }
}

//报警处理记录
- (void)getOrderDealListAction {
    
    [EventManagementApi apiWithOrderDealListOrderId:self.orderIdStr alarmOrderListArr:self.alarmOrderListArr successBlock:^{

        if(self.alarmOrderListArr.count > 0) {
            [self.imgSanjiaoJilu setHidden:NO];
            
             AlarmOrderLogListModel *amodel = self.alarmOrderListArr[0];
            self.unitNameLbl.text = amodel.issuedUnitUser;
            [EventManagementApi apiWtihMediaList:self.arrAllMedia orderId:amodel.logId sucBlock:^{
                self.mediaNumLbl.text = [NSString stringWithFormat:@"%zd",[self.arrAllMedia count]];
                
                //可实现滑动
                [self.mediasv setContentSize:CGSizeMake(138*[self.arrAllMedia count], 157)];
                //展示富媒体
                if(self.arrAllMedia.count == 0){
                    self.mediaView.sd_layout
                    .widthIs([UIScreen mainScreen].bounds.size.width)
                    .leftSpaceToView(self.mySV,0)
                    .topSpaceToView(self.dealView,8)
                    .rightSpaceToView(self.mySV,0)
                    .heightIs(38);
                }else{
                    self.mediaView.sd_layout
                    .widthIs([UIScreen mainScreen].bounds.size.width)
                    .leftSpaceToView(self.mySV,0)
                    .topSpaceToView(self.dealView,8)
                    .rightSpaceToView(self.mySV,0)
                    .heightIs(213);
                    [self.imgSanjiaoMedia setHidden:NO];
                }
                
                self.dealListView.sd_layout
                .widthIs([UIScreen mainScreen].bounds.size.width)
                .leftSpaceToView(self.mySV,0)
                .topSpaceToView(self.mediaView,10)
                .rightSpaceToView(self.mySV,0)
                .heightIs(38);
                
                //展示媒体
                [self viewMedia];
                if(![self.strFromType isEqualToString:@"工单"]){
                    [self.alarmOrderListArr removeObjectAtIndex:0];
                }
                
                [self.mytb reloadData];
                
                self.mytb.sd_layout
                .widthIs([UIScreen mainScreen].bounds.size.width)
                .leftSpaceToView(self.mySV,0)
                .topSpaceToView(self.dealListView,0)
                .rightSpaceToView(self.mySV,0)
                .heightIs(self.alarmOrderListArr.count * 115);
                
                // 更新frame，获取到scrollView的contentsize
                [self.eventView updateLayout];
                [self.dealView updateLayout];
                [self.mediaView updateLayout];
                [self.dealListView updateLayout];
                [self.mytb updateLayout];
                
                [self.mySV setContentSize:CGSizeMake(self.view.width, self.eventView.frame.size.height+self.dealView.frame.size.height+self.mediaView.frame.size.height+self.dealListView.frame.size.height+self.mytb.frame.size.height+25)];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
