//
//  CommonAlertVC.m
//  LeftSlide
//
//  Created by mymac on 16/5/18.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNCommonAlert.h"

@implementation YNCommonAlert

+ (void)showAlertWith:(UIViewController *)viewController
                title:(NSString *)title
              message:(NSString *)message
        callBackBlock:(CallBackBlock)block
    cancelButtonTitle:(NSString *)cancelBtnTitle
 structiveButtonTitle:(NSString *)destructiveBtnTitle
    otherButtonTitles:(NSString *)otherBtnTitles, ...{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // 添加按钮
    if (cancelBtnTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        [alertController addAction:cancelAction];
    }
    if (destructiveBtnTitle)
    {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            
            if (cancelBtnTitle)
            {
                block(1);
            }else{
                block(0);
            }
        }];
        [alertController addAction:destructiveAction];
    }
    if (otherBtnTitles)
    {
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherBtnTitles style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            if (!cancelBtnTitle && !destructiveBtnTitle)
            {
                block(0);
            }else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle))
            {
                block(1);
            }else if (cancelBtnTitle && destructiveBtnTitle)
            {
                block(2);
            }
        }];
        [alertController addAction:otherActions];
        
        // 定义一个指向个数可变的参数列表指针
        va_list args;
        // va_start 得到第一个可变参数地址
        va_start(args, otherBtnTitles);
        
        NSString *title = nil;
        
        int count = 2;
        if (!cancelBtnTitle && !destructiveBtnTitle)
        {
            count = 0;
        }else if ((cancelBtnTitle && !destructiveBtnTitle) || (!cancelBtnTitle && destructiveBtnTitle))
        {
            count = 1;
        }else if (cancelBtnTitle && destructiveBtnTitle)
        {
            count = 2;
        }
        
        // 指向下一个参数地址
        while ((title = va_arg(args, NSString *)))
        {
            count ++;
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                block(count);
            }];
            [alertController addAction:otherAction];
        }
        // 置空指针
        va_end(args);
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

@end
