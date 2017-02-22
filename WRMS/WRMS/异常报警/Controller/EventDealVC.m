//
//  EventDealVC.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/28.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "EventDealVC.h"
#import "YYAnimatedImageView.h"
#import "YYWebImage.h"
#import "LogItemModel.h"
#import "RichMediaModel.h"

#define  PIC_WIDTH 120
#define  PIC_HEIGHT 120
#define  INSETS 18

@interface EventDealVC ()
@property(nonatomic,strong)IBOutlet UIView *viewBG;
@property(nonatomic,strong)IBOutlet UIScrollView *mysv;
/** 媒体展示的scrollView*/
@property(nonatomic,strong)IBOutlet UIScrollView *mediasv;
/** 状态*/
@property(nonatomic,strong)IBOutlet UILabel *labelSatus;
/** 用户*/
@property(nonatomic,strong)IBOutlet UILabel *labelUser;
/** 处理时间*/
@property(nonatomic,strong)IBOutlet UILabel *labelTime;
/** 媒体数量*/
@property(nonatomic,strong)IBOutlet UILabel *mediaNum;
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
/** 媒体三角图片*/
@property(nonatomic,strong)IBOutlet UIImageView *imgSanjiaoMedia;
/** 总富媒体个数*/
@property(nonatomic,strong)NSMutableArray *arrAllMedia;
@end

@implementation EventDealVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"报警记录详情";
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
    self.arrMediaMp3 = [[NSMutableArray alloc]init];
    self.arrMediaMp4 = [[NSMutableArray alloc]init];
    self.arrMediaPic = [[NSMutableArray alloc]init];
    self.arrAllMedia = [[NSMutableArray alloc]init];
    
    //设置文本
    [self setText];
    [EventManagementApi apiWtihMediaList:self.arrAllMedia orderId:self.eModel.logId sucBlock:^{
        self.mediaNum.text =[NSString stringWithFormat:@"%zd",self.arrAllMedia.count];
        //展示富媒体
        [self viewMedia];
        if(self.arrAllMedia.count == 0) {
            [self.viewBG setFrame:CGRectMake(0, 16, self.viewBG.frame.size.width, 158)];
            [self.mediasv setFrame:CGRectMake(self.mediasv.origin.x, self.mediasv.origin.y, self.mediasv.size.width, 0)];
        }else{
            [self.imgSanjiaoMedia setHidden:NO];
        }
    }];
    
    
}

#pragma mark - event Responses
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
    }
    
    if ([typestr integerValue ]== 2) {//音频
        //预览音频
        ZXVideoPlayerViewController *videoVC = [[ZXVideoPlayerViewController alloc]init];
        [self presentViewController:videoVC animated:YES completion:nil];
        videoVC.videoUrl =[NSString stringWithFormat:@"%@",urlstr];
    }
}


- (IBAction)showOrHideenMeidaViewAction:(id)sender {
    UIButton *btn  = (UIButton *)sender;
    BOOL isSelect = btn.selected;
    if (!isSelect) {
        [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8
              initialSpringVelocity:0 options:0 animations:^{
                  [self.viewBG setFrame:CGRectMake(0, 16, self.viewBG.frame.size.width, 158)];
                  [self.mediasv setFrame:CGRectMake(self.mediasv.origin.x, self.mediasv.origin.y, self.mediasv.size.width, 0)];
              } completion:NULL];
        [btn setSelected:YES];
    }else{
        [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8
              initialSpringVelocity:0 options:0 animations:^{
                  [self.viewBG setFrame:CGRectMake(0, 16, self.viewBG.frame.size.width, 333)];
                  [self.mediasv setFrame:CGRectMake(self.mediasv.origin.x, self.mediasv.origin.y, self.mediasv.size.width, 150)];
              } completion:NULL];
        
        [btn setSelected:NO];
    }
}

#pragma mark - private methods
//设置文本
- (void)setText {
    self.labelSatus.text = self.eModel.statusName;
    self.labelUser.text = self.eModel.createUserAccnt;
    self.labelTime.text = self.eModel.createTime;
}

//获取工单记录详情里的附带媒体方法
- (void)getRichMediaAction {
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:self.eModel.logId forKey:@"logId"];
    [dictonary setValue:@"" forKey:@"type"];
    
    //请求
    [YNRequest YNPost:LBS_QueryAlarmOrderLogItem parameters:dictonary success:^(NSDictionary *dic) {
        NSString *codeStr     = [dic objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *rowsDic = [dic objectForKey:@"rows"];
            if ([rowsDic count] == 0)
            {
                self.viewBG.frame = CGRectMake(self.viewBG.frame.origin.x, self.viewBG.frame.origin.y, self.viewBG.frame.size.width, self.viewBG.frame.size.height - 160);
            }
            for (NSDictionary *mydic in rowsDic)
            {
                RichMediaModel *rmediamodel = [[RichMediaModel alloc]initWithDict:mydic];
                [self.arrAllMedia addObject:rmediamodel];
            }
            //展示富媒体
            [self viewMedia];
        }
    } fail:^{
        [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
    }];
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
                                        //                                     progress = (float)receivedSize / expectedSize;
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
    
    //可实现滑动
    [self.mediasv setContentSize:CGSizeMake(138*[self.arrAllMedia count], 157)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
