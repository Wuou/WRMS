//
//  MoreVC.m
//  WRMS
//
//  Created by mymac on 16/8/18.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "MoreVC.h"
#import "TDengluVC.h"
#import "PersonInfoVC.h"
#import "ServicerInfoVC.h"
#import "FeedBackVC.h"
#import "QuestionVC.h"
#import "AboutVC.h"
#import "SettingVC.h"

@interface MoreVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTV;

/** 图标数组*/
@property (strong, nonatomic) NSMutableArray *imageArr;
/** 标题数组*/
@property (strong, nonatomic) NSMutableArray *textArr;

/** 用户名*/
@property (strong, nonatomic) UILabel *nameLabel;
/** 个人账户*/
@property (strong, nonatomic) UILabel *accountLabel;

/** 单位信息*/
@property (strong, nonatomic) UILabel *companyNameLabel;

@end

@implementation MoreVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"更多";
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshPersonInfo) name:@"RefreMenuName" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imageArr = [NSMutableArray arrayWithObjects:@"serviceInfo", @"about", @"advice", @"FAQ", @"setting", nil];
    self.textArr = [NSMutableArray arrayWithObjects:@"服务商信息", @"关于", @"意见反馈", @"常见问题", @"退出登录", nil];
    
    CGFloat height = (kHeight - 112) / 3;
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"topImageInMore"];
    [self.view addSubview:topImageView];
    
    // 在图片上面添加个人信息
    [self setPersonInfoInTop:topImageView];
        
    topImageView.sd_layout.widthIs(kWidth)
    .heightIs(height)
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 64);
    
    self.myTV.sd_layout.widthIs(kWidth)
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, height)
    .bottomSpaceToView(self.view, 0);
    
    self.myTV.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    [self.myTV setSeparatorInset:(UIEdgeInsetsMake(60, 10, 0, 10))];
    [self.myTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (kHeight == 480) {
        self.myTV.scrollEnabled = YES;
    }else{
        self.myTV.scrollEnabled = NO;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:(UIBarButtonItemStylePlain) target:self action:@selector(clickSetting)];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark --- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.01;
    }else if (section == 1){
        return 5;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return 0.01;
    }else{
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 1;
    }else{
        
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = self.textArr[0];
            cell.imageView.image = [UIImage imageNamed:self.imageArr[0]];
        }else{
            cell.textLabel.text = self.textArr[1];
            cell.imageView.image = [UIImage imageNamed:self.imageArr[1]];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = self.textArr[2];
            cell.imageView.image = [UIImage imageNamed:self.imageArr[2]];
        }else {
            cell.textLabel.text = self.textArr[3];
            cell.imageView.image = [UIImage imageNamed:self.imageArr[3]];
        }
    }else {
        cell.textLabel.text = self.textArr[4];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            
            ServicerInfoVC *serviceVC = [[ServicerInfoVC alloc] init];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
        if (indexPath.row == 1) {
            
            AboutVC *aboutVC = [[AboutVC alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            FeedBackVC *feedVC = [[FeedBackVC alloc] init];
            [self.navigationController pushViewController:feedVC animated:YES];
        }
        if (indexPath.row == 1) {
            
            QuestionVC *questionVC = [[QuestionVC alloc] init];
            [self.navigationController pushViewController:questionVC animated:YES];
        }
    }
    if (indexPath.section == 2) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您是否确定退出登录?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            // 取消登录状态
            [utils cancelLogin];
            // 发送退出登录通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelLogin" object:nil];
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:confirmAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
    }
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myTV deselectRowAtIndexPath:[self.myTV indexPathForSelectedRow] animated:YES];
    });
}

#pragma mark - Private Methods
- (void)setPersonInfoInTop:(UIImageView *)topImageView {
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"personIcon"];
    [topImageView addSubview:iconImage];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = [utils getUname];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [topImageView addSubview:self.nameLabel];
    
    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.text = [NSString stringWithFormat:@"个人账号：%@", [utils getlogName]];
    self.accountLabel.textColor = [UIColor whiteColor];
    self.accountLabel.textAlignment = NSTextAlignmentCenter;
    self.accountLabel.font = [UIFont systemFontOfSize:14];
    [topImageView addSubview:self.accountLabel];
    
    self.companyNameLabel = [[UILabel alloc] init];
    self.companyNameLabel.text = [utils getUnitName];
    self.companyNameLabel.textColor = [UIColor whiteColor];
    self.companyNameLabel.textAlignment = NSTextAlignmentCenter;
    self.companyNameLabel.font = [UIFont systemFontOfSize:14];
    [topImageView addSubview:self.companyNameLabel];
    
    self.companyNameLabel.sd_layout.widthIs(kWidth)
    .heightIs(14)
    .leftSpaceToView(topImageView, 0)
    .bottomSpaceToView(topImageView, 10);
    
    self.accountLabel.sd_layout.widthIs(kWidth)
    .heightIs(14)
    .leftSpaceToView(topImageView, 0)
    .bottomSpaceToView(self.companyNameLabel, 5);
    
    self.nameLabel.sd_layout.widthIs(kWidth)
    .heightIs(14)
    .leftSpaceToView(topImageView, 0)
    .bottomSpaceToView(self.accountLabel, 5);
    
    CGFloat height = (kHeight - 112) / 3 - 10 - 14 - 5 -14 - 5 - 14 - 5 - 10;
    
    iconImage.sd_layout.widthIs(height)
    .heightIs(height)
    .bottomSpaceToView(self.nameLabel, 5)
    .centerXEqualToView(topImageView);
}

/**
 *  登录成功后刷新用户信息
 */
- (void)refreshPersonInfo {
    
    self.nameLabel.text = [utils getUname];
    self.accountLabel.text = [NSString stringWithFormat:@"个人账号：%@", [utils getlogName]];
    self.companyNameLabel.text = [utils getUnitName];
}

#pragma mark - Event Response
- (void)clickSetting {
    
    SettingVC *settingVC = [[SettingVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
