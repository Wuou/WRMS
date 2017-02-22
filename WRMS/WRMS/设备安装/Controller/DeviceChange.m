//
//  DeviceInstallInfoTwoVC.m
//  LeftSlide
//
//  Created by 杨景超 on 15/12/22.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "DeviceChange.h"
#import "SVProgressHUD.h"
#import "YNRequestWithArgs.h"
#import "DeviceListVC.h"
#import "utils.h"
#import "UIView+SDAutoLayout.h"
#import "MyTextField.h"
#import "YNRequest.h"

@interface DeviceChange () <UITextFieldDelegate>

/** 背景滚动视图*/
@property (strong, nonatomic) IBOutlet UIScrollView *mySC;
/** 设备检测按钮*/
@property (strong, nonatomic) IBOutlet UIButton     *chlik;
/** 水位编号*/
@property (strong, nonatomic) IBOutlet UILabel      *coversId;
/** 类别*/
@property (strong, nonatomic) IBOutlet UILabel      *strcovers;
/** 型号*/
@property (strong, nonatomic) IBOutlet UILabel      *strcoversTypeName;
/** 设备编号信息框*/
@property (strong, nonatomic) IBOutlet MyTextField  *TFmchnId;
/** IMEI信息框*/
@property (strong, nonatomic) IBOutlet MyTextField  *TFcodeImei;
/** 确定按钮*/
@property (nonatomic,strong ) IBOutlet UIButton     *btnOk;
/** TFmchnId*/
@property (strong, nonatomic) IBOutlet UILabel      *strmchnId;
/** IMEI*/
@property (strong, nonatomic) IBOutlet UILabel      *strcodeImei;
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

/** 为了区分从水位采集过来的跳转所定义的变量*/
@property (nonatomic,strong ) NSString     *fromType;
/** 是否检查完成*/
@property (nonatomic,assign ) BOOL         isCheckedOK;

@end

@implementation DeviceChange

#pragma mark - life cycle
/**
 *  基本属性的设置
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnOk.layer setCornerRadius:6];
    [self.chlik.layer setCornerRadius:6];
    
    self.title = @"设备更换";
    
    // 判断移动设备是否是4s
    if([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.btnOk setFrame:CGRectMake(self.btnOk.frame.origin.x, self.strremark.frame.origin.y + self.strremark.frame.size.height + 200 - 54, self.btnOk.frame.size.width, self.btnOk.frame.size.height)];
        _mySC.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 170 - 66);
    }else
    {
        _mySC.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(_strremark.frame) + 100);
        self.btnOk.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width - 16)
        .heightIs(44)
        .leftSpaceToView(_mySC, 8)
        .topSpaceToView(_strremark, 40);
    }
    
    // 设置滚动指示风格
    _mySC.indicatorStyle        = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:_mySC];
    [self setText];
}

#pragma mark -- textfeild delegate
/**
 *  输入设备编号后自动生成IMEI
 *
 *  @param textField UITextField
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.TFmchnId.text != nil || ![self.TFmchnId.text isEqualToString:@""])
    {
        NSString *TFmchnIdStr = self.TFmchnId.text;
        TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setValue:TFmchnIdStr forKey:@"mchnId"];
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
        
        //请求
        [YNRequest YNPost:LBS_QueryMchnList parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr     = [dic objectForKey:@"rcode"];
            NSString *msgStr      = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"])
            {
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic)
                {
                    self.TFcodeImei.text = [mydic objectForKey:@"codeImei"];
                }
            }else
            {
                if ([codeStr isEqualToString:@"0x0016"])
                {
                    //                    [SVProgressHUD showErrorWithStatus:codeAuthMsg];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
                
                
                self.TFcodeImei.text = nil;
                [self.TFmchnId setText:@""];
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
            
        }];
    }
}

#pragma mark - event response
//查询设备id对应的imei
- (IBAction)SelectMchiByCovID:(id)sender
{
    if (self.TFmchnId.text != nil || ![self.TFmchnId.text isEqualToString:@""])
    {
        NSString *TFmchnIdStr = self.TFmchnId.text;
        TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        [dictonary setValue:TFmchnIdStr forKey:@"mchnId"];
        [dictonary setValue:[utils getUnitID] forKey:@"unitId"];
        
        //请求
        [YNRequest YNPost:LBS_QueryMchnList parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr     = [dic objectForKey:@"rcode"];
            NSString *msgStr      = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"])
            {
                NSArray *rowsDic = [dic objectForKey:@"rows"];
                for (NSDictionary *mydic in rowsDic)
                {
                    self.TFcodeImei.text = [mydic objectForKey:@"codeImei"];
                }
            }else
            {
                if ([codeStr isEqualToString:@"0x0016"])
                {
                    //                    [SVProgressHUD showErrorWithStatus:codeAuthMsg];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
                
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
        }];
    }
}


/**
 *  点击确定按钮
 *
 *  @param sender UIButton
 */
- (IBAction)deviceChangeAction:(UIButton *)sender
{
    if ([self.TFmchnId.text isEqualToString:@""] || [self.TFmchnId.text isEqualToString:@" "])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入设备编号"];
    }else
    {
        NSString *TFmchnIdStr = self.TFmchnId.text;
        NSString *codeImeiStr = self.TFcodeImei.text;
        TFmchnIdStr = [TFmchnIdStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //创建JSON
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        
        [dictonary setValue:self.coversId.text forKey:@"pointId"];
        [dictonary setValue:TFmchnIdStr forKey:@"waterMchnId"];
        [dictonary setValue:codeImeiStr forKey:@"codeImei"];
        [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
        
        //请求
        [YNRequest YNPost:LBS_UpdateMonitorPointMchn parameters:dictonary success:^(NSDictionary *dic) {
            
            NSString *codeStr     = [dic objectForKey:@"rcode"];
            NSString *msgStr      = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"])
            {
                [SVProgressHUD showSuccessWithStatus:@"更换成功"];
                [self performSelector:@selector(toDeviceListVC) withObject:nil afterDelay:0.5f];
                
            }else
            {
                if ([codeStr isEqualToString:@"0x0016"])
                {
                    //                    [SVProgressHUD showErrorWithStatus:codeAuthMsg];
                }else{
                    [SVProgressHUD showErrorWithStatus:msgStr];
                }
                
                
            }
            
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
        }];
    }
}

#pragma mark - private methods
//Uiview 赋值
- (void)setText
{
    // 给界面属性传值
    self.coversId.text          = self.dmodel.pointId;
    self.strcovers.text         = self.dmodel.pointTypeName;
    self.strcoversTypeName.text = self.dmodel.pointName;
    self.strmchnId.text         = self.dmodel.waterMchnId;
    self.strcodeImei.text       = self.dmodel.strcodeImei;
    self.strunitName.text       = self.dmodel.strunitName;
    self.strinstallTime.text    = self.dmodel.strinstallTime;
    self.strstatusName.text     = self.dmodel.strstatusName;
    self.strremark.text         = self.dmodel.strremark;
    self.labelFuzhuNo.text      = self.dmodel.coversIdCustom;
}



/**
 *  返回上级页面并发送通知
 */
- (void)toDeviceListVC
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"N2",@"DeviceType",@"已安装",@"StateName",@"0002",@"State",self.TFmchnId.text,@"MchnId",self.TFcodeImei.text,@"imei",nil];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshDeviceList" object:nil userInfo:dictionary];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
