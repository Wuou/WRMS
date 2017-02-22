//
//  MyTextField.m
//  LoginInterface
//
//  Created by Allen on 15/8/14.
//  Copyright (c) 2015年 Allen. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField


#pragma mark - 重写clearButton位置
-(CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(CGRectGetMaxX(bounds) - 30, bounds.origin.y + 12, 14, 14);
}


#pragma mark - 重写leftView位置
-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 6, 24, 24);
}


#pragma mark - 重写rightView位置
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    return CGRectMake(CGRectGetMaxX(bounds) - 26, bounds.origin.y + 17, 12, 6);
}


#pragma mark - 重写placeHolder位置
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 5, bounds.size.height);
}


#pragma mark - 重写文本编辑位置
-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 5, bounds.size.height);
}


#pragma mark - 重写text文本位置
-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 5, bounds.size.height);
}

@end
