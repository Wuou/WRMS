//
//  MessageNotificationinfoVC.h
//  LeftSlide
//
//  Created by mymac on 15/11/6.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotificationinfoVC : UIViewController
//内容输入框
@property (strong, nonatomic) IBOutlet UITextView *tvContent;
//内容传值
@property(nonatomic,strong)NSString *strContent;
//内容标题
@property(nonatomic,strong)NSString *strTitle;

@end
