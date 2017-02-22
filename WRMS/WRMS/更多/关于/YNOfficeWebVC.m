//
//  YNOfficeWebVC.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "YNOfficeWebVC.h"

@interface YNOfficeWebVC ()

@end

@implementation YNOfficeWebVC
#pragma mark - life cycle
- (void)viewDidLoad {
    self.title = @"陕西永诺信息科技有限公司官网";
    [super viewDidLoad];
    [self layoutSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - private methods
- (void)layoutSubviews {
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    NSURL *url = [[NSURL alloc]initWithString:@"http://www.yongnuo-tech.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    [self.view addSubview:self.webView];
}

- (void)leftButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
