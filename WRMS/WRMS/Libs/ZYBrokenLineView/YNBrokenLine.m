//
//  BrokenLineView.m
//  MyBrokenLineDemo
//
//  Created by mymac on 16/6/3.
//  Copyright © 2016年 Devin. All rights reserved.
//

#import "YNBrokenLine.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation YNBrokenLine
{
    
    CGPoint _endPoint; // 中心点
}

- (id)initWithStarPoint:(CGPoint)start endPoint:(CGPoint)end frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _endPoint = end;
        
        
        // 先求出已知两点之间的距离
        CGFloat height1 = end.y - start.y;
        CGFloat width1 = end.x - start.x;
        
        // 起点到终点的距离，运用平方根函数
        CGFloat distance1 = sqrt(height1 * height1 + width1 * width1);
        
        // 再求转折点的坐标
        CGFloat height2; // 终点到转折点的高度
        CGFloat width2; // 终点到转折点的宽度
        
        if (end.y > 170 + kWidth / 3) // 在图表的下半部分时候
        {
            CGFloat heightS = fabs(end.y - start.y);
            CGFloat widthS = fabs(end.x - start.x);
            CGFloat rads = atan(widthS / heightS);
            if (rads > M_PI / 4)
            {
                height2 = 45 * height1 / distance1;
                width2 = 45 * width1 / distance1;
            }else{
                height2 = 60 * height1 / distance1;
                width2 = 60 * width1 / distance1;
            }
        }else{
            height2 = 45 * height1 / distance1;
            width2 = 45 * width1 / distance1;
        }
        
        
        // 得到转折点的坐标
        self.secondPoint = CGPointMake(end.x + width2, end.y + height2);
        
        // 将中心点坐标防止与转折点连线的一半处
        CGFloat width3 = self.secondPoint.x - end.x;
        CGFloat height3 = self.secondPoint.y - end.y;
        
        _endPoint.x = self.secondPoint.x - width3 / 2;
        _endPoint.y = self.secondPoint.y - height3 / 2;
        
        // 再求最终点的坐标
        if (end.x > [UIScreen mainScreen].bounds.size.width / 2)
        { // 如果中心点在右边
            self.thirdPoint = CGPointMake(self.secondPoint.x + 40, self.secondPoint.y);
        }else{
            self.thirdPoint = CGPointMake(self.secondPoint.x - 40, self.secondPoint.y);
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context,[UIColor whiteColor].CGColor);
    
    CGContextMoveToPoint(context, _endPoint.x, _endPoint.y);
    CGContextAddLineToPoint(context, self.secondPoint.x, self.secondPoint.y);
    CGContextAddLineToPoint(context, self.thirdPoint.x, self.thirdPoint.y);
    
    CGContextStrokePath(context);
}

@end
