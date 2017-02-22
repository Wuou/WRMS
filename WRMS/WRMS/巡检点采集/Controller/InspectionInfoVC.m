//
//  InspectionInfoVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/11/5.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "InspectionInfoVC.h"
#import "AddInspectionVC.h"
#import "RichMediaModel.h"

@interface InspectionInfoVC () <UITextFieldDelegate>
@property(nonatomic,strong)YNNavigationRightBtn *rightBtn;

/** 附件标题*/
@property (strong, nonatomic) IBOutlet UILabel *mediaLabel;
/** 附件数量*/
@property (strong, nonatomic) IBOutlet UILabel *mediaNumLabel;
/** 附件下方分割线*/
@property (strong, nonatomic) IBOutlet UILabel *mediaLineLabel;

/** 展示媒体的scrollView*/
@property(nonatomic,strong)IBOutlet UIScrollView *mediasv;
/** 从服务器获取到的图片数量*/
@property (strong, nonatomic) NSMutableArray *picArr;
/** 用来展示照片的数组*/
@property(nonatomic,strong)NSMutableArray *arrMediaPic;

@end

#define  PIC_WIDTH 120
#define  PIC_HEIGHT 120
#define  INSETS 18
@implementation InspectionInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"监测点详情";
        // Custom initialization
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setText];
    [self setSubviewsAutoLayout];
    self.tf_labelId.delegate = self;
    
    _rightBtn = [[YNNavigationRightBtn alloc]initWith:@"" img:@"edit" contro:self];
    __weak typeof(self) weakSelf = self;
    _rightBtn.clickBlock = ^(){
        
        // 只有当图片下载完成之后才可以点击修改按钮，否则无法修改
        AddInspectionVC *advc =[[AddInspectionVC alloc]init];
        advc.fromType = @"update";
        advc.pointModel = weakSelf.pmodel;
        [weakSelf.navigationController pushViewController:advc animated:YES];
    };
    
    self.picArr = [NSMutableArray array];
    self.arrMediaPic = [NSMutableArray array];
    // 下载图片
    [self updatePic];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Private Methods
/**
 *  给界面上的控件赋值
 */
- (void)setText {
    
    self.tf_labelId.text               = self.pmodel.pointId;
    self.label_Name.text               = self.pmodel.pointName;
    self.label_Latitude.text           = self.pmodel.latitude;
    self.label_Lontitude.text          = self.pmodel.longitude;
    self.label_Address.text            = self.pmodel.location;
    self.label_PointTypeName.text      = self.pmodel.pointTypeName;
    self.label_WaterHeight.text        = [NSString stringWithFormat:@"%.2f",self.pmodel.waterHeight];
    self.label_WaterMchnStateName.text = self.pmodel.waterMchnStateName;
    self.labelWaterMchnId.text         = self.pmodel.waterMchnId;
    self.labelWaterIMEI.text           = self.pmodel.codeImei;
    self.labelTime.text                = self.pmodel.createTime;
    self.label_Desc.text               = self.pmodel.remark;
}

/**
 *  界面控件自适应布局
 */
- (void)setSubviewsAutoLayout {
    // 地址
    self.label_Address.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width - 107)
    .autoHeightRatio(0)
    .leftSpaceToView(self.labelAddressTitle, 10)
    .topSpaceToView(self.labelTime, 10);
    
    // 地址下面分割线
    if (self.label_Address.text.length == 0)
    {
        self.labelLineAddress.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.viewBG, 0)
        .topSpaceToView(self.labelAddressTitle, 0);
    }else{
        self.labelLineAddress.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.viewBG, 0)
        .topSpaceToView(self.label_Address, 10);
    }
    
    // 求备注标题和备注信息
    self.labelDescTitle.sd_layout
    .widthIs(89)
    .heightIs(38)
    .leftSpaceToView(self.viewBG, 8)
    .topSpaceToView(self.labelLineAddress, 0);
    
    self.label_Desc.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width - 107)
    .autoHeightRatio(0)
    .leftSpaceToView(self.labelDescTitle, 10)
    .topSpaceToView(self.labelLineAddress,10);
    
    if (self.label_Desc.text.length == 0) {
        
        self.labelLineDesc.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.viewBG, 0)
        .topSpaceToView(self.labelDescTitle, 0);
        
    }else{
        
        self.labelLineDesc.sd_layout
        .widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.viewBG, 0)
        .topSpaceToView(self.label_Desc, 10);
    }
    
    self.mediaLabel.sd_layout.widthIs(89)
    .heightIs(38)
    .leftSpaceToView(self.viewBG, 8)
    .topSpaceToView(self.labelLineDesc, 0);
    
    self.mediaNumLabel.sd_layout.widthIs(18)
    .heightIs(18)
    .rightSpaceToView(self.viewBG, 25)
    .topSpaceToView(self.labelLineDesc, 10);
    
    self.mediaLineLabel.sd_layout.widthIs(kWidth)
    .heightIs(1)
    .leftSpaceToView(self.viewBG, 0)
    .topSpaceToView(self.mediaLabel, 0);
    
    [self.mediaLineLabel updateLayout];
    
    self.viewBG.sd_layout
    .widthIs([UIScreen mainScreen].bounds.size.width)
    .heightIs(self.mediaLineLabel.frame.origin.y + 1)
    .leftSpaceToView(self.infoScrollView, 0)
    .topSpaceToView(self.infoScrollView, 16);
    
    // 更新背景视图的frame，可正常取值
    [self.viewBG updateLayout];
    
    NSLog(@"高度%f",self.labelLineDesc.frame.origin.y);
    
    self.infoScrollView.contentSize  = CGSizeMake([UIScreen mainScreen].bounds.size.width,self.viewBG.frame.size.height + 33);
}

/**
 *  下载图片
 */
- (void)updatePic {
    
    [InspectionApi apiWtihPicList:self.picArr
                          pointID:self.pmodel.pointId
                         sucBlock:^{
                             
                             self.mediaNumLabel.text = [NSString stringWithFormat:@"%zd",[self.picArr count]];
                             
                             //展示富媒体
                             if(self.picArr.count == 0){
                                 self.mediasv.frame = CGRectMake(0, self.mediaLineLabel.frame.origin.y + 25, kWidth, 0);
                             }else{
                                 self.mediasv.frame = CGRectMake(0, self.mediaLineLabel.frame.origin.y + 25, kWidth, 156);
                             }
                             
                             //可实现滑动
                             self.mediasv.contentSize = CGSizeMake(self.picArr.count * 138, 156);
                             
                             //展示媒体
                             [self viewMedia];
                             
                             self.infoScrollView.contentSize  = CGSizeMake([UIScreen mainScreen].bounds.size.width,self.viewBG.frame.size.height + self.mediasv.frame.size.height + 33);
                         }];
}

//展示富媒体
- (void)viewMedia {
    
    int i;
    int n = 0;
    LYPhoto *photo;
    
    //添加Button,照片可点击
    for(i = 0; i< [self.picArr count];i++)
    {
        RichMediaModel *rmediamodel = [self.picArr objectAtIndex:i];
        
        YYAnimatedImageView *webImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(INSETS+n, INSETS, PIC_WIDTH,PIC_HEIGHT)];
        webImageView.userInteractionEnabled = YES;
        [self.mediasv addSubview:webImageView];
        n = n+129;
        
        //照片
        [webImageView yy_setImageWithURL:[NSURL URLWithString:rmediamodel.mconUrl]
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
        
        UIButton *buttonview = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonview.tag = 10000 + i;
        //设置button的大小
        buttonview.frame = CGRectMake(0, 0, PIC_WIDTH,PIC_HEIGHT);
        [buttonview addTarget:self action:@selector(buttonMediaAction:) forControlEvents:UIControlEventTouchUpInside];
        [webImageView addSubview:buttonview];
        
        photo = [LYPhoto photoWithImageView:webImageView placeHold:webImageView.image photoUrl:rmediamodel.mconUrl];
        [self.arrMediaPic addObject:photo];
    }
}

/**
 *  点击图片
 *
 *  @param sender 按钮
 */
- (void)buttonMediaAction:(UIButton *)btn {
    
    NSInteger picindex = btn.tag -10000;
    if(picindex < 0){
        picindex = 0;
    }
    [LYPhotoBrowser showPhotos:self.arrMediaPic currentPhotoIndex: picindex countType:LYPhotoBrowserCountTypeCountLabel];
}

/**
 *  复制监测点编号
 *
 *  @param string 复制信息
 */
- (void)copyToMessage:(NSString *)string {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Event Response
//复制监测点编号到剪切板
- (IBAction)copyWaterIdAction:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *str            = self.tf_labelId.text;
    [pasteboard setString:str];
    if (pasteboard) {
        [self copyToMessage:@"监测点编号已复制"];
    }else {
        [self copyToMessage:@"监测点编号复制失败"];
    }
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
