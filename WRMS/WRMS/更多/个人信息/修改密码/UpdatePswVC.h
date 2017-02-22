//
//  UpdatePswVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePswVC : UIViewController
/** 旧密码输入框*/
@property (strong, nonatomic) IBOutlet UITextField *oldPwd;
/** 新密码输入框*/
@property (strong, nonatomic) IBOutlet UITextField *NewPwd;
/** 确认新密码输入框*/
@property (strong, nonatomic) IBOutlet UITextField *NewNewPwd;
/** 修改密码按钮*/
@property (strong, nonatomic) IBOutlet UIButton *conBt;
/** 获取旧密码*/
@property(nonatomic,strong)NSString *strOldPwd;
/** 获取新密码*/
@property(nonatomic,strong)NSString *strNewPwd;
/** 旧密码输入框右侧眼睛按钮*/
@property (strong, nonatomic) IBOutlet UIButton *pwdBtn1;
/** 新密码输入框右侧眼睛按钮*/
@property (strong, nonatomic) IBOutlet UIButton *pwdBtn2;
/** 确认新密码输入框右侧眼睛按钮*/
@property (strong, nonatomic) IBOutlet UIButton *pwdBtn3;

@end
