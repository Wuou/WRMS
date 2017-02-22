//
//  MessageNotificationVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MessageNotificationVC.h"
#import "MessageNotificationVCCell.h"
#import "MessageNotificationinfoVC.h"
#import "MessageNotificationApi.h"
#import "MsgModel.h"

static NSString *identity = @"msgNotificationList";
@interface MessageNotificationVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *messageNotificationArr;
@end

@implementation MessageNotificationVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"我的通知";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        self.isJPush = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                     name:@"getCodeAgained" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.isJPush) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backUpVC:)];
    }
    
    self.messageNotificationArr = [[NSMutableArray alloc]init];
    [self setMJRefresh];
    
    [self.oneTabelView registerNib:[UINib nibWithNibName:@"MessageNotificationVCCell" bundle:nil] forCellReuseIdentifier:@"MessageNotificationVCCell"];
    self.oneTabelView.tableFooterView =[[UIView alloc]init];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - tableView delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageNotificationArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 92;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MessageNotificationVCCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotificationVCCell" ];
    MsgModel *mmodel = self.messageNotificationArr[indexPath.row];
    cell.msgModel = mmodel;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:self.oneTabelView]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgModel *mmodel = [self.messageNotificationArr objectAtIndex:indexPath.row];
    MessageNotificationinfoVC * minfoVC = [[MessageNotificationinfoVC alloc]init];
    minfoVC.strTitle = mmodel.title;
    minfoVC.strContent = mmodel.content;
    [self.navigationController pushViewController:minfoVC animated:YES];
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.oneTabelView deselectRowAtIndexPath:[self.oneTabelView indexPathForSelectedRow] animated:YES];
    });
}

#pragma mark - private method
/**
 接收推送点击事件返回上级

 @param btn 导航栏左按钮
 */
- (void)backUpVC:(UIBarButtonItem *)btn {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanTheNotificationRecord" object:nil];
    });
}

/**
 验证码过期重新验证
 */
- (void)getCodeAgained {
    
    [self.oneTabelView.header beginRefreshing];
}

- (void)getMessageNotificationList{
    
   [MessageNotificationApi apiWithGetMessageNotificateionListMsgArr:self.messageNotificationArr pageNum:self.pageNum tableView:self.oneTabelView pageChange:^{
       self.pageNum -= 1;
   }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.oneTabelView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

/**
 *  初始化MJRefresh
 */
- (void)setMJRefresh
{
    //  下拉刷新控件
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        
        [self.messageNotificationArr removeAllObjects];
        self.pageNum = 1;
        [self getMessageNotificationList];
    }];
    
    MJChiBaoZiFooter *footer = [MJChiBaoZiFooter footerWithRefreshingBlock:^{
        
        self.pageNum +=1;
        [self getMessageNotificationList];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    header.autoChangeAlpha = YES;
    footer.autoChangeAlpha = YES;
    footer.automaticallyRefresh = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    self.oneTabelView.header = header;
    self.oneTabelView.footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
