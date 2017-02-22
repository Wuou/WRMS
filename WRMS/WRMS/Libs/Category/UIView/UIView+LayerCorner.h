//
//  UIView+LayerCorner.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/11.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayerCorner)
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@end
