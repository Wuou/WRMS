//
//  JBChartTableCell.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 定义枚举值*/
typedef NS_ENUM(NSInteger, JBChartTableCellType){
	JBChartTableCellTypeLineChart,
    JBChartTableCellTypeBarChart,
    JBChartTableCellTypeAreaChart
};

@interface JBChartTableCell : UITableViewCell

@property (nonatomic, assign) JBChartTableCellType type;

@end
