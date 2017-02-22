//
//  DateListVC.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/10.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateListVC : UIViewController

/** 从首页传过来的数据分析二级列表数组*/
@property (nonatomic,strong) NSMutableArray *arrName;
/** 存储图片的数组*/
@property (nonatomic,strong) NSMutableArray *arrPic;

@end
