//
//  ServicerInfoVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "ServicerInfoVC.h"
#import "AppDelegate.h"

@interface ServicerInfoVC ()

@end

@implementation ServicerInfoVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"服务商信息";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"029-68255493"];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"30c2ff"] range:contentRange];
    [self.callPhoneBtn setAttributedTitle:content forState:(UIControlStateNormal)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - event responses
- (IBAction)makingCalls:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:029-68255493"];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
