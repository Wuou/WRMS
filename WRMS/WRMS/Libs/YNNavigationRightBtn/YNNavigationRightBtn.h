//
//  NavigationRightBtn.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^rightItemSucBlock)();

@interface YNNavigationRightBtn : UIButton
/**
 *  naviagationbar右上角点击按钮
 *
 *  @param title      标题
 *  @param bgImg      icon
 *  @param controller controller
 *
 *  @return self
 */
- (instancetype)initWith:(NSString *)title
             img:(NSString *)bgImg
          contro:(UIViewController *)controller;

@property (nonatomic, copy) rightItemSucBlock clickBlock;

@end
