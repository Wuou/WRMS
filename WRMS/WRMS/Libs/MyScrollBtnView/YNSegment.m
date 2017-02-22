//
//  MyScrollBtnView.m
//  ScrollButtonDeom
//
//  Created by Devin on 16/3/22.
//  Copyright © 2016年 Devin. All rights reserved.
//

#import "YNSegment.h"
#import "UIColor-Expanded.h"

@implementation YNSegment
{
    UIView *_backgroundV;
    UIButton *_btn;
}

- (instancetype)initWithFrame:(CGRect)frame withBtnArr:(NSArray *)arr{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6.f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.masksToBounds = YES;
        
        CGFloat width = frame.size.width / arr.count;
        
        _backgroundV = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, width, frame.size.height))];
        _backgroundV.backgroundColor = [UIColor colorWithHexString:@"3c3c3c"];
        _backgroundV.layer.cornerRadius = 6.f;
        _backgroundV.layer.masksToBounds = YES;
        [self addSubview:_backgroundV];
        
        for (int i = 0; i < arr.count; i++) {
            
            _btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
            [_btn setTitle:arr[i] forState:(UIControlStateNormal)];
            _btn.titleLabel.font = [UIFont systemFontOfSize:14];
            _btn.backgroundColor = [UIColor clearColor];
            _btn.layer.cornerRadius = 6.f;
            _btn.tag = 100 + i;
            [_btn addTarget:self action:@selector(scrollBtnACtion:) forControlEvents:(UIControlEventTouchUpInside)];
            [_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateHighlighted)];
            if (i == 0) {
                
                [_btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                _btn.enabled = NO;
            }else{
                
                [_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                _btn.enabled = YES;
            }
            
            [self addSubview:_btn];
        }
    }
    return self;
}

- (void)scrollBtnACtion:(UIButton *)btn{
    
    NSInteger index = btn.tag - 100;
    self.myBlock(index);
    
    [UIView animateWithDuration:0.3f animations:^{
       
        _backgroundV.frame = btn.frame;
    }];
    btn.enabled = NO;
    
    // 动画改编字体颜色
    [UIView animateWithDuration:0.1f animations:^{
        
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }];
    
    for (id object in [self subviews]) {
        
        if ([object isKindOfClass:[UIButton class]]) {
            
            UIButton *otherBtn = (UIButton *)object;
            if (otherBtn != btn) {
                
                [UIView animateWithDuration:0.1f animations:^{
                    
                    [otherBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                }];
                otherBtn.enabled = YES;
            }
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
