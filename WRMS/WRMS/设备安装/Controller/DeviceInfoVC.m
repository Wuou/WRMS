//
//  DeviceInstallThree.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/22.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DeviceInfoVC.h"
#import "UIView+SDAutoLayout.h"

@interface DeviceInfoVC ()

/** 背景滚动视图*/
@property (strong, nonatomic) IBOutlet UIScrollView *mySC;
/** 类别*/
@property (strong, nonatomic) IBOutlet UILabel *strcovers;
/** 型号*/
@property (strong, nonatomic) IBOutlet UILabel *strcoversTypeName;
/** 设备编号*/
@property (strong, nonatomic) IBOutlet UILabel *strmchnId;
/** imei*/
@property (strong, nonatomic) IBOutlet UILabel *strcodeImei;
/** 水位位置*/
@property (strong, nonatomic) IBOutlet UILabel *adrss;
/** 所属单位*/
@property (strong, nonatomic) IBOutlet UILabel *strunitName;
/** 安装时间*/
@property (strong, nonatomic) IBOutlet UILabel *strinstallTime;
/** 水位状态*/
@property (strong, nonatomic) IBOutlet UILabel *strstatusName;
/** 备注信息*/
@property (strong, nonatomic) IBOutlet UITextView *strremark;
/** 水位编号*/
@property(nonatomic,strong)IBOutlet UILabel *labelID;
/** 辅助编号*/
@property(nonatomic,strong)IBOutlet UILabel *labelFuzhu;

@property (strong, nonatomic) IBOutlet UIView *contentView; // 内容View
@property (strong, nonatomic) IBOutlet UILabel *adrSegLine; // 地址下面的分割线
@property (strong, nonatomic) IBOutlet UILabel *remarkTitle; // 备注信息标题

@end

@implementation DeviceInfoVC
#pragma mark - life cycle
/**
 *  属性的基本设置, 初始化等
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title                  = @"水位设备信息";
    _mySC.contentSize           = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.strremark.frame) + 50);
    _mySC.indicatorStyle        = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:_mySC];
    
    self.adrss.numberOfLines    = 3;
    self.adrss.font             = [UIFont systemFontOfSize:14];

    self.strcovers.text         = self.wmodel.pointName;
    self.strcoversTypeName.text = self.wmodel.pointTypeName;
    self.strmchnId.text         = self.wmodel.waterMchnId;
    self.strcodeImei.text       = self.wmodel.strcodeImei;
    self.strunitName.text       = self.wmodel.strunitName;
    self.strinstallTime.text    = self.wmodel.strinstallTime;
    self.strstatusName.text     = self.wmodel.waterMchnStateName;
    self.strremark.text         = self.wmodel.strremark;
    self.adrss.text             = self.wmodel.strlocation;
    self.labelFuzhu.text        = self.wmodel.coversIdCustom;
    self.labelID.text           = self.wmodel.pointId;
    
    // 求得地址的frame
    CGFloat adrssHeight = [self getHeightWithContent:self.adrss.text width:[UIScreen mainScreen].bounds.size.width - 93];
    
    self.adrss.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width - 90)
    .heightIs(adrssHeight)
    .leftSpaceToView(self.contentView, 85)
    .topSpaceToView(self.labelFuzhu, 10);
    [self.adrss sizeToFit];
    
    // 求得地址下面分割线的frame
    if (self.adrss.text.length == 0)
    {
        self.adrSegLine.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.labelFuzhu, 38);
    }else{
        self.adrSegLine.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.adrss, 8);
    }
    
    // 求备注标题和备注信息的frame
    self.remarkTitle.sd_layout.widthIs(82)
    .heightIs(38)
    .leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.adrSegLine, 0);
    
    self.strremark.sd_layout.widthIs(227)
    .heightIs(64)
    .leftSpaceToView(self.contentView, 85)
    .topSpaceToView(self.adrSegLine, 1);
}

// 自适应高度
- (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width
{
    CGSize size       = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect       = [content boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
}


- (void)didReceiveMemoryWarning
{
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
