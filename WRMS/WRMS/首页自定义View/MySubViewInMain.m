//
//  MySubViewInMain.m
//  WRMS
//
//  Created by mymac on 16/8/25.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "MySubViewInMain.h"

@implementation MySubViewInMain

- (id)initWithFrame:(CGRect)frame imageStr:(NSString *)imageStr title:(NSString *)title {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat imageHeigt = frame.size.width / 3;
        
        self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
        self.iconImageView.frame = CGRectMake(imageHeigt, (frame.size.height - imageHeigt) / 2, imageHeigt, imageHeigt);
        [self addSubview:self.iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(5, frame.size.height - 20, frame.size.width, 15);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        self.clickBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.clickBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.clickBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
