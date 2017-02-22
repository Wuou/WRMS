//
//  NTViewController.m
//  tabbarDemo
//
//  Created by MD101 on 14-10-8.
//  Copyright (c) 2014年 TabBarDemo. All rights reserved.
//

#import "NTViewController.h"
#import "NTButton.h"
#import "UIColor-Expanded.h"
#import "ViewController.h"
#import "MoreVC.h"
#import "UIColor-Expanded.h"
#import "BaseNavigationViewController.h"
#import "TDengluVC.h"

@interface NTViewController (){

    UIImageView *_tabBarView;//自定义的覆盖原先的tarbar的控件
    
    NTButton * _previousBtn;//记录前一次选中的按钮
    UIButton *_labelBadge;
    NSInteger _allNum;
}

@end

@implementation NTViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor grayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLogin) name:@"cancelLogin" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 
    for (UIView* obj in self.tabBar.subviews) {
        if (obj != _tabBarView) {//_tabBarView 应该单独封装。
            [obj removeFromSuperview];
        }
//        if ([obj isKindOfClass:[]]) {
//            
//        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    _tabBarView = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    _tabBarView.userInteractionEnabled = YES;
    _tabBarView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:.2].CGColor;
    _tabBarView.layer.borderWidth = 0.3;
    
    [self.tabBar addSubview:_tabBarView];

    ViewController *first = [[ViewController alloc]init];
    UINavigationController * navi1 = [[BaseNavigationViewController alloc]initWithRootViewController:first];
    
    MoreVC * second = [[MoreVC alloc]init];
    UINavigationController * navi2 = [[BaseNavigationViewController alloc]initWithRootViewController:second];
    
    self.viewControllers = [NSArray arrayWithObjects:navi1,navi2, nil];
    
    [self creatButtonWithNormalName:@"homeNormal" andSelectName:@"homeSelect" andTitle:@"首页" andIndex:0];
    [self creatButtonWithNormalName:@"moreNormal" andSelectName:@"moreSelect" andTitle:@"更多" andIndex:1];
    
    NTButton * button = _tabBarView.subviews[0];
    [self changeViewController:button];
    
    // Do any additional setup after loading the view.
}

/**
 *  接收到通知退出登录
 */
- (void)exitLogin {
    
    NTButton * button = _tabBarView.subviews[0];
    [self changeViewController:button];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        TDengluVC *loginVC = [[TDengluVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    });
}

#pragma mark 创建一个按钮

- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index{
    
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    customButton.tag = index;

    CGFloat buttonW = _tabBarView.frame.size.width / 2;
    CGFloat buttonH = _tabBarView.frame.size.height;
    
    customButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 * index, 0, buttonW, buttonH);
    [customButton setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    //这里应该设置选中状态的图片。
    [customButton setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    
    [customButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    
    customButton.imageView.contentMode = UIViewContentModeTop;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    customButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [customButton setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    
    [customButton setTitleColor:[UIColor colorWithHexString:@"00c0f1"] forState:UIControlStateSelected];
    customButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    [customButton setTitle:title forState:UIControlStateNormal];
    [_tabBarView addSubview:customButton];
    
    if(index == 0)//设置第一个选择项。（默认选择项）  
    {
        _previousBtn = customButton;
        _previousBtn.selected = YES;
    }
}

#pragma mark 按钮被点击时调用
- (void)changeViewController:(NTButton *)sender
 {
     if(self.selectedIndex != sender.tag){ // ®
         self.selectedIndex = sender.tag; //切换不同控制器的界面
         _previousBtn.selected = ! _previousBtn.selected;
         _previousBtn = sender;
         _previousBtn.selected = YES;
         
     }
}

#pragma mark 是否隐藏tabBar
// 
-(void)isHiddenCustomTabBarByBoolean:(BOOL)boolean{
    
    _tabBarView.hidden=boolean;
}

@end
