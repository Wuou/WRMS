//
//  DeviceInstallInfoVC.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/18.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DeviceInstall.h"
#import "SVProgressHUD.h"
#import "YNRequestWithArgs.h"
#import "utils.h"
#import "DeviceListVC.h"
#import "UIView+SDAutoLayout.h"
#import "MyTextField.h"
#import "YNRequest.h"
#import "DeviceInstallApi.h"

@interface DeviceInstall () <UITextFieldDelegate>

/** 背景滚动视图*/
@property (strong, nonatomic) IBOutlet UIScrollView *mySC;
/** id信息框*/
@property (strong, nonatomic) IBOutlet MyTextField  *TFmchnId;
/** IMEI信息框*/
@property (strong, nonatomic) IBOutlet MyTextField  *TFcodeImei;
/** 水位编号*/
@property (strong, nonatomic) IBOutlet UILabel      *coversId;
/** 类别*/
@property (strong, nonatomic) IBOutlet UILabel      *strcovers;
/** 型号*/
@property (strong, nonatomic) IBOutlet UILabel      *strcoversTypeName;
/** 所属单位*/
@property (strong, nonatomic) IBOutlet UILabel      *strunitName;
/** 安装时间*/
@property (strong, nonatomic) IBOutlet UILabel      *strinstallTime;
/** 水位状态*/
@property (strong, nonatomic) IBOutlet UILabel      *strstatusName;
/** 备注信息*/
@property (strong, nonatomic) IBOutlet UILabel      *strremark;
/** 辅助编号*/
@property (nonatomic,strong ) IBOutlet UILabel      *labelFuzhuNo;
/** 确定按钮*/
@property (nonatomic,strong ) IBOutlet UIButton     *btnOk;

/** 各种控件对应的标题*/
@property (strong, nonatomic) IBOutlet UILabel      *jinggaibianhao;
@property (strong, nonatomic) IBOutlet UILabel      *jinggaileibie;
@property (strong, nonatomic) IBOutlet UILabel      *jinggaixinghao;
@property (strong, nonatomic) IBOutlet UILabel      *shebeibianhao;
@property (strong, nonatomic) IBOutlet UILabel      *suoshudanwei;
@property (strong, nonatomic) IBOutlet UILabel      *anzhuangshijian;
@property (strong, nonatomic) IBOutlet UILabel      *jinggaizhuangtai;
@property (strong, nonatomic) IBOutlet UILabel      *beizhuxinxi;
@property (strong, nonatomic) IBOutlet UILabel      *fuzhubianhao;

/** 为了区分从水位采集过来的跳转所定义的变量*/
@property (nonatomic,strong ) NSString     *fromType;
@end

@implementation DeviceInstall
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title                            = @"设备安装";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

/**
 *  基本的属性设置
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setText];
    [self.btnOk.layer setCornerRadius:6]; // 给button做一个圆角
    
    _mySC.indicatorStyle        = UIScrollViewIndicatorStyleWhite;// 改变滚动指示的风格
    
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.btnOk setFrame:CGRectMake(self.btnOk.frame.origin.x, self.strremark.frame.origin.y+self.strremark.frame.size.height + 200 - 50, self.btnOk.frame.size.width, self.btnOk.frame.size.height)];
        _mySC.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 92 - 66 - 38);
    }else
    {
        _mySC.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,CGRectGetMaxY(_strremark.frame) + 100);
        self.btnOk.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width - 16)
        .heightIs(44)
        .leftSpaceToView(_mySC, 8)
        .topSpaceToView(_strremark, 40);
    }
    
    [self.view addSubview:_mySC];
}

/**
 *  标题语言设置
 *
 *  @param animated animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_btnOk setTitle:@"确定" forState:(UIControlStateNormal)];
}

#pragma mark -- textfield delegate
/**
 *  id输入后判断是否存在IMEI
 *
 *  @param textField UITextField
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //去除多余空格
    NSString *TFmchnIdStr = self.TFmchnId.text;
    TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DeviceInstallApi apiWithIMEIisExit:TFmchnIdStr successBlock:^(NSDictionary *dic){
        
        NSArray *rowsDic = [dic objectForKey:@"rows"];
        for (NSDictionary *mydic in rowsDic)
        {
            self.TFcodeImei.text= [mydic objectForKey:@"codeImei"];
        }
    } returnBlock:^{
        self.TFcodeImei.text = nil;
        [self.TFmchnId setText:@""];
    }];
}

#pragma mark - event response
/**
 *  获取终端信息
 *
 *  @param sender sender
 */
- (IBAction)SelectMchiByCovID:(id)sender
{
    //去除多余空格
    NSString *TFmchnIdStr = self.TFmchnId.text;
    TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DeviceInstallApi apiWithIMEIisExit:TFmchnIdStr successBlock:^(NSDictionary *dic){
        
        NSArray *rowsDic = [dic objectForKey:@"rows"];
        for (NSDictionary *mydic in rowsDic)
        {
            self.TFcodeImei.text= [mydic objectForKey:@"codeImei"];
        }
    } returnBlock:^{
    }];
}

/**
 *  点击确定按钮
 *
 *  @param sender UIButton
 */
- (IBAction)deviceInstallAction:(UIButton *)sender
{
    //去除多余空格
    NSString *TFmchnIdStr = self.TFmchnId.text;
    TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DeviceInstallApi apiWithInstallDevice:TFmchnIdStr strcoversId:self.dmodel.pointId strCodeImei:self.TFcodeImei.text successBlock:^{
        [self performSelector:@selector(toPopDeviceListVC) withObject:nil afterDelay:0.5f];
    }];
}

#pragma mark - private methods
//Uiview 赋值
- (void)setText
{
    self.coversId.text          = self.dmodel.pointId;
    self.strcovers.text         = self.dmodel.pointTypeName;
    self.strcoversTypeName.text = self.dmodel.pointName;
    self.strunitName.text       = self.dmodel.strunitName;
    self.strinstallTime.text    = self.dmodel.strinstallTime;
    self.strstatusName.text     = self.dmodel.strinstallTime;
    self.strremark.text         = self.dmodel.strremark;
    self.labelFuzhuNo.text      = self.dmodel.coversIdCustom;
}

/**
 *  返回上级界面, 发送通知
 */
- (void)toPopDeviceListVC
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"N2",@"DeviceType",@"已安装",@"StateName",@"0002",@"State",self.TFmchnId.text,@"MchnId",self.TFcodeImei.text,@"imei",nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshDeviceList" object:nil userInfo:dictionary];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
