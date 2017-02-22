//
//  AboutVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "AboutVC.h"
#import "AppDelegate.h"
#import "YNOfficeWebVC.h"

@interface AboutVC ()
@property (nonatomic,strong) IBOutlet UIImageView *imgIcon;
@end

@implementation AboutVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    self.strVersion.text = [NSString stringWithFormat:@"    软件版本：%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - event response
//拨打客服电话
-(IBAction)toTelService:(id)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:02968255493"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)toJoinOfficialWeb:(id)sender {
    YNOfficeWebVC *officeVC = [[YNOfficeWebVC alloc]init];
    [self.navigationController pushViewController:officeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
