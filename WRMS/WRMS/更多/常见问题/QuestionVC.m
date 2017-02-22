//
//  QuestionVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "QuestionVC.h"
#import "AppDelegate.h"

@interface QuestionVC (){
NSMutableArray *_sectionArr;

NSMutableArray *_rowArr;
//BOOL实质是int类型默认0（NO）
BOOL flag[3];
}
@end

@implementation QuestionVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    [self.view addSubview:_myTableView];
    //设置两个数组数据
    [self setArr];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - tableView delegate dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 80;
}

//设置区头的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(23, 0, self.view.frame.size.width-30, 80)];
    lab.text = _sectionArr[section];
    lab.textColor=[UIColor darkGrayColor];
    lab.numberOfLines=0;
    [view addSubview:lab];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 27, 15, 15)];
        img.image = [UIImage imageNamed:@"arrowRight1"];
    [view addSubview:img];
    //alloc只会创建system 不能进行修改类型（没有该属性）
    //buttonWithType
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section;
    [view addSubview:btn];
    if (flag[section]) {
        img.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (flag[section]) {
        return [_rowArr[section] count];
    }
    return 0;
}
/*
 表的重用机制：
 
 当有cell滑到屏幕内的时候，首先从冲用池里找，如果找到就拿来用；找不到的时候就按照给定的类型进行创建
 
 当cell滑出屏幕时，系统会自动把它放到重用池中，以便下次使用
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =_rowArr[indexPath.section][indexPath.row];
    cell.textLabel.numberOfLines=0;
    cell.selected = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - event responses
-(void)btnClick:(UIButton *)btn {
    
    flag[btn.tag] = !flag[btn.tag];
    [_myTableView reloadData];
}

#pragma mark - private methods
- (void)setArr {
    _sectionArr= [[NSMutableArray alloc] initWithObjects:@"一.登录密码忘了，提示“账号或密码错误”怎么办？",@"二.地图放大不显示线路是什么原因？",@"三.在地图上查看附件的水位监测点数量为什么不够？",@"四.为什么我跟其他同事下载同样的客户端登录进去后显示的页面却不一样？",@"五.为什么我的网络正常，却获取不到周边的水位监测点信息？", nil];
    
    NSArray *arr1 = [[NSArray alloc] initWithObjects:@"答：如果你的登录密码忘了，可以找系统管理员，管理员可以为您重新设置密码。", nil];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:@"答：如果地图级别太大会不显示线和区域，建议您把地图级别再调小一点看看。",nil];
    NSArray *arr3 = [[NSArray alloc] initWithObjects:@"答：地图的最大精确度是40米，如果40米内有数个监测点，这样在地图上会重叠在一起，所以视觉上数量会减少。",nil];
    NSArray *arr5 = [[NSArray alloc] initWithObjects:@"答：手机客户端是根据登录用户的权限不同而使用的功能也有相应的限制，如有问题请联系单位负责人。",nil];
    NSArray *arr6 = [[NSArray alloc] initWithObjects:@"答：请查看自己的手机GPS是否打开，蓝牙是否可见，并正常连接。",nil];
    _rowArr = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3,arr5,arr6,nil];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
