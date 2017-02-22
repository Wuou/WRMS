//
//  SettingVC.m
//  WRMS
//
//  Created by mymac on 16/8/26.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "SettingVC.h"
#import "UpdatePswVC.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTV;

@end

@implementation SettingVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"设置";
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTV.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    [self.myTV setSeparatorInset:(UIEdgeInsetsMake(60, 10, 0, 10))];
    [self.myTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITabelView Delegaet & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    cell.textLabel.text = @"修改密码";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdatePswVC *updatePswVC = [[UpdatePswVC alloc] init];
    [self.navigationController pushViewController:updatePswVC animated:YES];
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myTV deselectRowAtIndexPath:[self.myTV indexPathForSelectedRow] animated:YES];
    });
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
