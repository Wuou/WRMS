//
//  FeedBackVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
@interface FeedBackVC : UIViewController
/** 意见反馈输入框*/
@property (strong, nonatomic) IBOutlet UITextView *fbContentTextView;
/** 用户电话输入框*/
@property (strong, nonatomic) IBOutlet UITextField *userTelTextField;
/** 用户姓名输入框*/
@property (strong, nonatomic) IBOutlet UITextField *createrTextField;
/** 意见反馈框*/
@property(nonatomic,strong)NSString *fbContentTextViewStr;
/** 获取用户电话*/
@property(nonatomic,strong)NSString *userTelTextFieldStr;
/** 获取用户姓名*/
@property(nonatomic,strong)NSString *createrTextFieldStr;
/** 提交时间*/
@property (nonatomic,strong)NSString *createTimeStr;
/** 上下滑动scrollow*/
@property (strong, nonatomic) IBOutlet UIScrollView *mySv;
/** 提交按钮*/
@property (strong, nonatomic) IBOutlet UIButton *btUp;


@end
