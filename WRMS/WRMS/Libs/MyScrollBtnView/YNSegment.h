//
//  MyScrollBtnView.h
//  ScrollButtonDeom
//
//  Created by Devin on 16/3/22.
//  Copyright © 2016年 Devin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyIndexBlock)(NSInteger i);

@interface YNSegment : UIView

// 传输数组即为你需要设定的按钮
- (instancetype)initWithFrame:(CGRect)frame withBtnArr:(NSArray *)arr;


// 生成对象后调用此block即可调用点击方法
@property (nonatomic, copy) MyIndexBlock myBlock;

@end
