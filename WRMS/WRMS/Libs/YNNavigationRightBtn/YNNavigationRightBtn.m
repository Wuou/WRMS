//
//  NavigationRightBtn.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNNavigationRightBtn.h"

@implementation YNNavigationRightBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWith:(NSString *)title
                     img:(NSString *)bgImg
                  contro:(UIViewController *)controller{
    self = [super initWithFrame:CGRectMake(0,0,44,44)];
    if (self ) {
        UIButton *rightBtn                   = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rightBtn setImage:[UIImage imageNamed:bgImg]forState:UIControlStateNormal];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        rightBtn.titleLabel.font             = [UIFont systemFontOfSize:32];
        [rightBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        rightBtn.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentRight;
        [rightBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *rightItem               = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        controller.navigationItem.rightBarButtonItem = rightItem;
    }
    return self;
}

-(void)clickAction{
    _clickBlock();
}
@end
