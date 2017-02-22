//
//  MessageNotificationVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotificationVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *oneTabelView;
/** 当前分页数*/
@property (nonatomic, assign) NSInteger            pageNum;

@property (nonatomic, assign) BOOL isJPush;

@end
