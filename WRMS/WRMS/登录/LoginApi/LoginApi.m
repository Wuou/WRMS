//
//  LoginApi.m
//  LeftSlide
//
//  Created by mymac on 16/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi

+ (void)apiLoginSystemWithAccount:(NSString *)account
                         password:(NSString *)password
                loginSuccessBlock:(LoginSuccessBlock)block {
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:(SVProgressHUDMaskTypeClear)];
    NSString *name = account;
    NSString *psw  = password;
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    psw  = [psw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pswMd5 = [SecurityUtil encryptMD5String:psw];
    
    //开始请求
    //创建JSON
    NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:name forKey:@"userAccnt"];
    [dictonary setValue:pswMd5 forKey:@"userPwd"];
    [dictonary setValue:@"ynxx_" forKey:@"platform"];
    
    [YNRequest YNPost:LBS_UserLogin
           parameters:dictonary
              success:^(NSDictionary *dic) {
                  
                  NSString *codeStr = [dic objectForKey:@"rcode"];
//                  NSLog(@"%@", [dic objectForKey:@"rmessage"]);
                  if ([codeStr isEqualToString:@"0x0000"]) {
                      
                      [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                      NSArray *rowsDic = [dic objectForKey:@"rows"];
                      for (NSDictionary *mydic in rowsDic) {
                          NSString *typeStr = [mydic objectForKey:@"accntType"];
                          NSString *unitidStr = [mydic objectForKey:@"unitId"];
                          NSString *unitnameStr = [mydic objectForKey:@"unitName"];
                          NSString *unameStr = [mydic objectForKey:@"userName"];
                          [utils setUname:unameStr];
                          [utils setUnitID:unitidStr];
                          [utils setUnitName:unitnameStr];
                          [utils setUserType:typeStr];
                          [utils setLogin:name password:psw];
                          [utils setLoginOk];
                          [utils setYWPsw:pswMd5];
                          
                          [[NSNotificationCenter defaultCenter]
                           postNotificationName:@"RefreMenuName" object:nil userInfo:nil];
                          [[NSNotificationCenter defaultCenter]
                           postNotificationName:@"upRegAndLogin" object:nil userInfo:nil];
                      }
                      block();
                  }else{
                      [SVProgressHUD showErrorWithStatus:@"用户名或密码错误,请重新输入"];
                  }
                  
              } fail:^{
                  
              }];
}

@end
