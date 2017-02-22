
//
//  PersonInfoVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "PersonInfoVC.h"
#import "utils.h"
#import "AppDelegate.h"

@interface PersonInfoVC ()
@property(nonatomic,strong)IBOutlet UIImageView *imgtitle;
@end

@implementation PersonInfoVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户信息";
        // Custom initialization
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
      }
    
    return self;
}

- (void)viewDidLoad {
    
    [self.imgtitle setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 2.34)];
    
    [super viewDidLoad];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 25, 25);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"editPinfo"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(toUpdatePswAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.labelAccount.text =[NSString stringWithFormat:@"账号：%@",[utils getlogName]];
    self.labelName.text =[utils getUname];
    self.labelUnitName.text = [NSString stringWithFormat:@"%@",[utils getUnitName]];
}

#pragma mark - event response
/**
 *  修改密码
 *
 *  @param sender 修改密码
 */
- (IBAction)toUpdatePswAction:(id)sender {
    UpdatePswVC *upvc =[[UpdatePswVC alloc]init];
    [self.navigationController pushViewController:upvc animated:YES];
}
/**
 *  切换账号
 *
 *  @param sender 切换账号
 */
- (IBAction)changeIDAction:(id)sender {
    
    TDengluVC *lvc =[[TDengluVC alloc]init];
    [self presentViewController:lvc animated:YES completion:nil];
}


#pragma mark - private method
- (void)refreshName {
    self.labelAccount.text =[NSString stringWithFormat:@"账号：%@",[utils getlogName]];
    self.labelName.text =[utils getUname];
    self.labelUnitName.text = [NSString stringWithFormat:@"所属单位：%@",[utils getUnitName]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
