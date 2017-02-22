//
//  QuestionVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
@interface QuestionVC : UIViewController<HeadViewDelegate>{
    
    NSInteger _currentSection;
    NSInteger _currentRow;
}
/** 创建可变数组*/
@property(nonatomic, retain) NSMutableArray* headViewArray;
/** 显示列表*/
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
