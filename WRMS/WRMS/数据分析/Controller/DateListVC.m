//
//  DateListVC.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/10.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "DateListVC.h"
#import "JBBarChartViewController.h"
#import "SCViewController.h"

@interface DateListVC ()

/** 展示信息列表*/
@property(nonatomic,strong)IBOutlet UITableView *myTB;
@end

@implementation DateListVC
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title                            = @"数据分析";
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

/**
 *  取消右滑返回上级页面的手势
 *
 *  @param animated animated
 */


/**
 *  注册单元格
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myTB registerClass:[UITableViewCell class] forCellReuseIdentifier:@"dataList"];
    self.myTB.tableFooterView = [[UIView alloc]init];
    [self.myTB reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataList"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.arrPic.count > 0 && self.arrName.count > 0) {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:self.arrPic[0]];
                cell.textLabel.text = self.arrName[0];
            }else if (indexPath.row ==1)
            {
                cell.imageView.image = [UIImage imageNamed:self.arrPic[1]];
                cell.textLabel.text = self.arrName[1];
            }
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:self.arrPic[2]];
                cell.textLabel.text = self.arrName[2];
            }else if (indexPath.row ==1)
            {
                cell.imageView.image = [UIImage imageNamed:self.arrPic[3]];
                cell.textLabel.text = self.arrName[3];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
//            JBBarChartViewController *jbcvc = [[JBBarChartViewController alloc] init];
//            jbcvc.title      = @"水位趋势月统计";
//            jbcvc.strType    = @"水位趋势月";
//            jbcvc.naviTitle1 = @"平均水位高度";
//            jbcvc.naviTitle2 = @"自检终端数量";
//            [self.navigationController pushViewController:jbcvc animated:YES];
            SCViewController *scVC = [[SCViewController alloc] init];
            scVC.title = @"水位趋势月统计";
            [self.navigationController pushViewController:scVC animated:YES];
        }else{
//            JBBarChartViewController *jbcvc = [[JBBarChartViewController alloc] init];
//            jbcvc.title      = @"水位趋势日统计";
//            jbcvc.strType    = @"水位趋势日";
//            jbcvc.naviTitle1 = @"平均水位高度";
//            jbcvc.naviTitle2 = @"自检终端数量";
//            [self.navigationController pushViewController:jbcvc animated:YES];
            SCViewController *scVC = [[SCViewController alloc] init];
            scVC.title = @"水位趋势日统计";
            [self.navigationController pushViewController:scVC animated:YES];
        }
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
//            JBBarChartViewController *jbcvc = [[JBBarChartViewController alloc] init];
//            jbcvc.title      = @"水位报警工单月统计";
//            jbcvc.strType    = @"水位报警工单月";
//            jbcvc.naviTitle1 = @"完成工单数";
//            jbcvc.naviTitle2 = @"执行效率";
//            [self.navigationController pushViewController:jbcvc animated:YES];
            SCViewController *scVC = [[SCViewController alloc] init];
            scVC.title = @"水位报警工单月统计";
            [self.navigationController pushViewController:scVC animated:YES];
        }else{
//            JBBarChartViewController *jbcvc = [[JBBarChartViewController alloc] init];
//            jbcvc.title      = @"水位报警工单日统计";
//            jbcvc.strType    = @"水位报警工单日";
//            jbcvc.naviTitle1 = @"完成工单数";
//            jbcvc.naviTitle2 = @"执行效率";
//            [self.navigationController pushViewController:jbcvc animated:YES];
            SCViewController *scVC = [[SCViewController alloc] init];
            scVC.title = @"水位报警工单日统计";
            [self.navigationController pushViewController:scVC animated:YES];
        }
    }
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myTB deselectRowAtIndexPath:[self.myTB indexPathForSelectedRow] animated:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
