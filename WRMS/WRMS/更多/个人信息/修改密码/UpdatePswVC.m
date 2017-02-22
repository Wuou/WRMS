//
//  UpdatePswVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "UpdatePswVC.h"
#import "TDengluVC.h"

@interface UpdatePswVC ()<UITextFieldDelegate>

@end

@implementation UpdatePswVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"修改密码";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮属性
    [self setupBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - event responses
- (IBAction)contChilk:(UIButton *)sender {
    if ( _oldPwd.text== nil || [_oldPwd.text isEqualToString:@""] || _NewNewPwd.text == nil || [_NewNewPwd.text isEqualToString:@""] ) {
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }else{
        if (![_NewPwd.text isEqualToString:_NewNewPwd.text]){
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
        }else{
            if (_NewPwd.text.length < 6 ||_NewNewPwd.text.length < 6){
                [SVProgressHUD showErrorWithStatus:@"新输入密码个数小于6位"];
            }else{
                [SVProgressHUD showWithStatus:@"修改中..."];
                self.strOldPwd=_oldPwd.text;
                self.strNewPwd=_NewNewPwd.text;
                
                //创建JSON
                NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
                //创建链表
                [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
                [dictonary setValue:_strOldPwd forKey:@"oldPwd"];
                [dictonary setValue:self.strNewPwd forKey:@"newPwd"];
                //请求网络
                [YNRequest YNPost:LBS_UpdateUserPwd parameters:dictonary success:^(NSDictionary *dic) {
                    
                    NSString *codeStr = [dic objectForKey:@"rcode"];
                    NSString *msgStr  = [dic objectForKey:@"rmessage"];
                    if ([codeStr isEqualToString:@"0x0000"]) {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3] animated:YES];
                        // 修改成功0.5后返回到根页面
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"ModifyPsw" object:nil userInfo:nil];
                        });
                        
                    }else{
                        
                        if ([codeStr isEqualToString:@"0x0016"])
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [utils setLoginAgain];
                            });
                        }else{
                            [SVProgressHUD showErrorWithStatus:msgStr];
                        }
                    }
                } fail:^{
                }];
            }
        }
    }
}
#pragma mark --- 三个按钮实现方法
- (IBAction)oldVisible:(id)sender {
    if (self.oldPwd.secureTextEntry == YES) {
        self.oldPwd.secureTextEntry = NO;
    }else{
        self.oldPwd.secureTextEntry = YES;
    }
}
- (IBAction)newVisible:(id)sender {
    if (self.NewPwd.secureTextEntry == YES) {
        self.NewPwd.secureTextEntry = NO;
    }else{
        self.NewPwd.secureTextEntry = YES;
    }
}
- (IBAction)newNewVisible:(id)sender {
    if (self.NewNewPwd.secureTextEntry == YES) {
        self.NewNewPwd.secureTextEntry = NO;
    }else{
        self.NewNewPwd.secureTextEntry = YES;
    }
}

#pragma mark --- UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField viewWithTag:101]) {
        self.pwdBtn1.hidden = NO;
    }
    if ([textField viewWithTag:102]) {
        self.pwdBtn2.hidden = NO;
    }
    if ([textField viewWithTag:103]) {
        self.pwdBtn3.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField viewWithTag:101]) {
        self.pwdBtn1.hidden = YES;
    }
    if ([textField viewWithTag:102]) {
        self.pwdBtn2.hidden = YES;
    }
    if ([textField viewWithTag:103]) {
        self.pwdBtn3.hidden = YES;
    }
}
#pragma mark - private methods
- (void)setupBtn {

    [self.conBt.layer setCornerRadius:6];
    self.pwdBtn1.hidden = YES;
    self.pwdBtn2.hidden = YES;
    self.pwdBtn3.hidden = YES;
    self.oldPwd.secureTextEntry = YES;
    self.NewPwd.secureTextEntry = YES;
    self.NewNewPwd.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
