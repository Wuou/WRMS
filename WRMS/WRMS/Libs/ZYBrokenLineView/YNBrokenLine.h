//
//  BrokenLineView.h
//  MyBrokenLineDemo
//
//  Created by mymac on 16/6/3.
//  Copyright © 2016年 Devin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNBrokenLine : UIView

- (id)initWithStarPoint:(CGPoint)start
               endPoint:(CGPoint)end
                  frame:(CGRect)frame;

@property (nonatomic, assign) CGPoint secondPoint;
@property (nonatomic, assign) CGPoint thirdPoint;

@end
