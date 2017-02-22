//
//  JBBarChartViewController.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/5/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBaseChartViewController.h"

@interface JBBarChartViewController : JBBaseChartViewController

/** 类型，比如报警工单状态、报警类别汇总*/
@property (nonatomic,strong) NSString *strType;
/** segement 两个分类名字的第一个名字*/
@property (nonatomic,strong) NSString *naviTitle1;
/** segement 两个分类名字的第二个名字*/
@property (nonatomic,strong) NSString *naviTitle2;

@end
