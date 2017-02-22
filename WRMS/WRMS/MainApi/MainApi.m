//
//  MainApi.m
//  LeftSlide
//
//  Created by mymac on 16/5/19.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "MainApi.h"
#import "MenuItemModel.h"

@implementation MainApi

+ (void)apiWithUIViewController:(UIViewController *)UIViewController
                            arr:(NSMutableArray *)menuArr
                   successBlock:(myBlock)returnBlock
                  arrIsNilBlock:(getDataFailBlock)failBlock
{
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:@"0004" forKey:@"sysId"]; //0004 代表iOS
    
    [YNRequest YNPost:LBS_QueryNavigationBySysId parameters:dictonary success:^(NSDictionary *dic) {
        
//        NSLog(@"%@", dic);
        NSString *codeStr     = [dic objectForKey:@"rcode"];
//        NSString *rmessage    = [dic objectForKey:@"rmessage"];
        if ([codeStr isEqualToString:@"0x0000"])
        {
            NSArray *arr = [dic objectForKey:@"rows"];
            
            if (arr.count != 0)
            {
                for (NSDictionary *dic in arr) {
                    MenuItemModel *mm = [[MenuItemModel alloc] init];
                    [mm setValuesForKeysWithDictionary:dic];
                    if (![menuArr containsObject:mm]) {
                        [menuArr addObject:mm];
                    }
                }
                returnBlock();
            }else
            {
                failBlock();
            }
        }else
        {
            if ([codeStr isEqualToString:@"0x0016"]) {
                [utils setLoginAgain];
            }
        }
        [SVProgressHUD dismiss];
    } fail:^{
        failBlock();
        [YNCommonAlert showAlertWith:UIViewController title:kTitle message:kSettingMessage callBackBlock:^(NSInteger btnIndex) {
            if (btnIndex == 1) {
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }else{
                    NSURL *setURL = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=General"]];
                    [[UIApplication sharedApplication] openURL:setURL];
                }
            }
        } cancelButtonTitle:kCancel structiveButtonTitle:nil otherButtonTitles:kSetting, nil];
        [SVProgressHUD dismiss];
    }];
}


@end
