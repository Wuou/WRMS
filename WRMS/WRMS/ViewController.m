//
//  ViewController.m
//  WRMS
//
//  Created by YangJingchao on 2016/8/15.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "ViewController.h"
#import "TDengluVC.h"
#import "MessageNotificationVC.h"
#import "MySubViewInMain.h"
#import "MenuItemModel.h"
#import "DateListVC.h"

// 定义小模块的边长，设置小模块为正方形模块
#define kSmallLength (([UIScreen mainScreen].bounds.size.height - 113 - 15) / 2 - 5) / 2
#define spacing 5

@interface ViewController ()

/** 背景*/
@property (nonatomic, strong) UIImageView *bgImanegView;

/** 接收服务器数组*/
@property (nonatomic, strong) NSMutableArray *arrMenuRows;

/** 类名数组*/
@property (nonatomic, strong) NSMutableArray *classNameArr;
/** 标题数组*/
@property (nonatomic, strong) NSMutableArray *titleArr;
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *imageArr;
/** 背景颜色数组*/
@property (nonatomic, strong) NSMutableArray *colorArr;

/** 数据分析数组*/
@property (nonatomic, strong) NSMutableArray *dataAlyArr;
/** 数据分析子标题数组*/
@property (nonatomic, strong) NSMutableArray *dataNameArr;
/** 数据分析子图片数组*/
@property (nonatomic, strong) NSMutableArray *dataImageArr;


/** 处置中报警工单个数*/
@property (nonatomic, strong) UILabel *orderNumLabel;
/** 推送消息个数*/
@property (nonatomic, strong) NSString *totalNews;


/** 网络失败后显示的图片*/
@property (nonatomic, strong) UIImageView *failDataImage;
/** 网络失败后的手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/** 右上角信息按钮*/
@property (nonatomic, strong) UIButton *informationCardBtn;

@end

@implementation ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        self.title = @"星网智能水位监测系统";
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelLogin) name:@"ModifyPsw" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshImage) name:@"acceptMessage" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMenuName) name:@"RefreMenuName" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getCodeAgained)
                                                    name:@"getCodeAgained" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clickIconEnter) name:@"clickIconEnter" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(upRegAndLogin)
                                                     name:@"upRegAndLogin" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *jid;
    if ([utils isLogin]) {
        jid = [utils getJpushId];
    }else{
        jid = [JPUSHService registrationID];
    }
    if([utils getJpushId].length)
        NSLog(@"极光推送regId:%@",jid);
    if (jid.length > 2) {
        [utils setJpushId:[JPUSHService registrationID]];
        if ([utils isLogin]) {
            [self upLoadReID];
        }
    }else{
        AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelgate.jpushTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(getRegidOnceThreeMin) userInfo:nil repeats:YES];
    }
    
    // 初始化数组
    self.arrMenuRows  = [NSMutableArray array];
    self.classNameArr = [NSMutableArray array];
    self.titleArr     = [NSMutableArray array];
    self.imageArr     = [NSMutableArray array];
    self.dataAlyArr   = [NSMutableArray array];
    self.dataNameArr  = [NSMutableArray array];
    self.dataImageArr = [NSMutableArray array];
    
    // 初始化未读消息label
    self.orderNumLabel = [[UILabel alloc] init];
    
    // 设置背景颜色
    self.colorArr     = [NSMutableArray arrayWithObjects:@"009c07", @"0a57c1", @"00c0f1", @"9a059f", @"bd1d49", nil];
    
    // 从服务器获取首页的数据
    [self getMenuRows];
    
    // 设置导航栏右侧消息按钮
    self.informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.informationCardBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.informationCardBtn setImage:[UIImage imageNamed:@"message_no"] forState:UIControlStateNormal];
    [self.informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:self.informationCardBtn];
    self.navigationItem.rightBarButtonItem = informationCardItem;
    
    // 网络失败后显示图片
    self.failDataImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failToGetData"]];
    self.failDataImage.frame = CGRectMake((kWidth - 300) / 2, (kHeight - 264) / 2, 300, 200);
    self.failDataImage.hidden = YES;
    [self.view addSubview:self.failDataImage];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // 判断是否登录
    if ([utils isLogin]) {
        
    }else {
        
        TDengluVC *lvc =[[TDengluVC alloc] init];
        lvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:lvc animated:YES completion:nil];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ModifyPsw" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"acceptMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreMenuName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCodeAgained" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickIconEnter" object:nil];
}

#pragma mark - Private Methods
/**
 极光推送定时获取regId
 */
- (void)getRegidOnceThreeMin {
    NSString *jid = [JPUSHService registrationID];
    NSLog(@"循环获取极光推送regId:%@",jid);
    if (jid.length > 2) {
        [utils setJpushId:[JPUSHService registrationID]];
        if ([utils isLogin]) {
            [self upLoadReID];
        }
        
        AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelgate.jpushTimer invalidate];
    }
}

/**
 *  接收修改密码的通知，取消登录
 */
- (void)cancelLogin {
    
    [utils cancelLogin];
    
    TDengluVC *lv = [[TDengluVC alloc] init];
    [self.navigationController presentViewController:lv animated:YES completion:nil];
}

/**
 *  接收推送消息的通知，刷新界面图标和数字（只有当点击通知进入程序才会运行此方法）
 */
- (void)refreshImage {
    
    // 重新设置导航栏右侧按钮的图标
    [self.informationCardBtn setImage:[UIImage imageNamed:@"message_yes"] forState:(UIControlStateNormal)];
    // 重新获取报警工单和异常报警中处置中状态的个数
    [self getCountOfAlarmAndOrder];
}

/**
 *  点击桌面图标进入程序后刷新一下消息个数，判断是否有未读消息（只有点击桌面图标进入程序才会运行此方法）
 */
- (void)clickIconEnter {
    
    // 请求接口，获取异常报警和报警工单中“处理中”状态的个数，显示在界面上，同时获取消息个数
    [self getCountOfAlarmAndOrder];
}

/**
 *  登录成功后重新刷新首页
 */
- (void)refreshMenuName {
    
    // 上传极光推送RID
    [self upLoadReID];
    // 登录成功后请求数据
    [self getMenuRows];
}

/**
 *  接收重新请求的通知
 */
- (void)getCodeAgained {
    
    [self getMenuRows];
}

/**
 接收获取极光regId的通知
 */
- (void)upRegAndLogin {
    
    [self upLoadReID];
}

/**
 *  画视图上的白色分割线
 *
 *  @param bgImageView 背景图片
 */
- (void)drawSegLineWith:(UIImageView *)bgImageView {
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kWidth - kSmallLength - spacing, 0, spacing, kSmallLength * 2 + spacing)];
    line1.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(line1.frame.origin.x + spacing, kSmallLength, kSmallLength, spacing)];
    line2.backgroundColor = [
                             UIColor whiteColor];
    [bgImageView addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, kSmallLength * 2 + spacing, kWidth, spacing)];
    line3.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:line3];
    
    if (self.dataAlyArr.count > 0) {
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, kSmallLength * 3 +                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 spacing * 2, kSmallLength, spacing)];
        line4.backgroundColor = [UIColor whiteColor];
        [bgImageView addSubview:line4];
        
        UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(kSmallLength, kSmallLength * 2 + spacing * 2, spacing, kSmallLength * 2 + spacing)];
        line5.backgroundColor = [UIColor whiteColor];
        [bgImageView addSubview:line5];
    }else{
        
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake((kWidth - spacing) / 2, kSmallLength * 2 + spacing * 2, spacing, kSmallLength * 2 + spacing)];
        line4.backgroundColor = [UIColor whiteColor];
        [bgImageView addSubview:line4];
    }
}

/**
 *  从服务器接收首页数组
 */
- (void)getMenuRows {
    
    // 每次请求之前先清空数组，去除界面
    [self.arrMenuRows removeAllObjects];
    [self.dataAlyArr removeAllObjects];
    [self.titleArr removeAllObjects];
    [self.imageArr removeAllObjects];
    [self.classNameArr removeAllObjects];
    [self.dataNameArr removeAllObjects];
    [self.dataImageArr removeAllObjects];
    [self.bgImanegView removeFromSuperview];
    self.bgImanegView = nil;
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    // 调用封装好的请求接口数据
    [MainApi apiWithUIViewController:self arr:self.arrMenuRows successBlock:^{
        
        // 将数组的值赋给对应的数组
        [self loadMenuView];
    } arrIsNilBlock:^{
        self.failDataImage.hidden = NO;
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getDataAgin)];
        [self.view addGestureRecognizer:self.tap];
    }];
}

/**
 *  给界面上的元素赋值
 */
- (void)loadMenuView {
    
    for (MenuItemModel *model in self.arrMenuRows) {
        
        if ([model.iconCLS isEqualToString:@"icon_data"]) {
            [self.dataAlyArr addObject:model.nodeURL];
        }
    }
    
    for (int i = 0; i < self.arrMenuRows.count; i++) {
        
        MenuItemModel *model = self.arrMenuRows[i];
        
        // 取父节点是水位监测的模块
        if ([model.parentName isEqualToString:@"水位监测"]) {
            
            [self.titleArr addObject:model.navNodeName];
            [self.imageArr addObject:model.iconCLS];
            [self.classNameArr addObject:model.nodeURL];
        }
        // 取父节点是数据分析的模块
        if ([model.parentName isEqualToString:@"数据分析"]) {
            
            MenuItemModel *model = self.arrMenuRows[i];
            [self.dataNameArr addObject:model.navNodeName];
            [self.dataImageArr addObject:model.iconCLS];
        }
    }
    
    // 设置背景图，判断数据分析数组是否有值
    [self setBackImage];
}

/**
 *  设置背景图，判断数据分析数组是否有值进行布局
 */
- (void)setBackImage {
    
    // 首页背景图片
    self.bgImanegView = [[UIImageView alloc] init];
    self.bgImanegView.frame = CGRectMake(5, 69, kWidth - 15, kHeight - 123);
//    self.bgImanegView.image = [UIImage imageNamed:@"homePage"];
    self.bgImanegView.userInteractionEnabled = YES;
    [self.view addSubview:self.bgImanegView];
    
    // 画分割线
    [self drawSegLineWith:self.bgImanegView];
    
    // 设置未读消息label
    self.orderNumLabel.backgroundColor = [UIColor colorWithHexString:@"ff1212"];
    self.orderNumLabel.textColor = [UIColor whiteColor];
    self.orderNumLabel.clipsToBounds = YES;
    self.orderNumLabel.textAlignment = NSTextAlignmentCenter;
    self.orderNumLabel.font = [UIFont systemFontOfSize:14];
    
    // for循环中创建模块
    for (int i = 0; i < 6; i++) {
        
        CGRect subViewFrame;
        if (i == 0) {
            subViewFrame = CGRectMake(0, 0, kWidth - kSmallLength - spacing * 3, kSmallLength * 2 + spacing);
        }else if (i == 1){
            subViewFrame = CGRectMake(kWidth - kSmallLength - spacing * 2, 0, kSmallLength, kSmallLength);
        }else if (i == 2){
            subViewFrame = CGRectMake(kWidth - kSmallLength - spacing * 2, kSmallLength + spacing, kSmallLength, kSmallLength);
        }else if (i == 3){
            if (self.dataAlyArr.count > 0) {
                subViewFrame = CGRectMake(0, kSmallLength * 2 + spacing * 2, kSmallLength, kSmallLength);
            }else{
                subViewFrame = CGRectMake(0, kSmallLength * 2 + spacing * 2, (kWidth - spacing * 3) / 2, kSmallLength * 2 + spacing);
            }
        }else if (i == 4){
            if (self.dataAlyArr.count > 0) {
                subViewFrame = CGRectMake(0, kSmallLength * 3 + spacing * 3, kSmallLength, kSmallLength);
            }else{
                subViewFrame = CGRectMake((kWidth - spacing * 3) / 2 + spacing, kSmallLength * 2 + spacing * 2, (kWidth - spacing * 3) / 2, kSmallLength * 2 + spacing);
            }
        }else{
            if (self.dataAlyArr.count > 0) {
                subViewFrame = CGRectMake(kSmallLength + spacing, kSmallLength * 2 + spacing * 2, kWidth - kSmallLength - spacing * 3, kSmallLength * 2 + spacing);
            }else{
                subViewFrame = CGRectMake(0, 0, 0, 0);
            }
        }
        
        // 根据上面得到的frame初始化模块
        if (i != 5) {
            
            if (self.imageArr.count > 0) {
                
                MySubViewInMain *mySubView = [[MySubViewInMain alloc] initWithFrame:subViewFrame imageStr:self.imageArr[i] title:self.titleArr[i]];
                mySubView.backgroundColor = [UIColor colorWithHexString:self.colorArr[i]];
                mySubView.clickBtn.tag = i;
                [mySubView.clickBtn addTarget:self action:@selector(clickBtnInView:) forControlEvents:(UIControlEventTouchUpInside)];
                // 添加未读消息label
                if (i == 4) {
                    self.orderNumLabel.frame = CGRectMake(mySubView.iconImageView.frame.origin.x + mySubView.iconImageView.frame.size.width / 2, mySubView.iconImageView.frame.origin.y - 16, mySubView.iconImageView.frame.size.width, mySubView.iconImageView.frame.size.height);
                    [mySubView addSubview:self.orderNumLabel];
                }
                
                [self.bgImanegView addSubview:mySubView];
            }
        }else{
            
            MySubViewInMain *mySubView = [[MySubViewInMain alloc] initWithFrame:subViewFrame imageStr:@"icon_data" title:@"数据分析"];
            mySubView.backgroundColor = [UIColor colorWithHexString:@"d7562c"];
            [mySubView.clickBtn addTarget:self action:@selector(dataAction) forControlEvents:(UIControlEventTouchUpInside)];
            [self.bgImanegView addSubview:mySubView];
        }
    }
    // 考虑到线程并发，当首页权限获取完成后，界面绘制成功后，再去请求界面上动态label
    [self getCountOfAlarmAndOrder];
}

/**
 *  点击页面重新加载数据
 */
- (void)getDataAgin {
    
    [self getMenuRows];
    
    self.tap = nil;
    [self.view removeGestureRecognizer:self.tap];
}

/**
 *  上传极光生成的registrationID 来唯一标识当前用户
 */
- (void)upLoadReID {
    
    //开始请求
    //创建JSON
    NSDictionary *dictonary                = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    [dictonary setValue:[JPUSHService registrationID] forKey:@"channelId"];
    [dictonary setValue:@"ios" forKey:@"platformType"];
    
    NSString *value;
    BOOL isValidJSONObject =  [NSJSONSerialization isValidJSONObject:dictonary];
    if (isValidJSONObject) {
        NSData *data =  [NSJSONSerialization dataWithJSONObject:dictonary options:kNilOptions error:nil];
        value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSMutableArray *params=[NSMutableArray array];
    
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"input", nil]];
    YNRequestWithArgs *args = [[YNRequestWithArgs alloc] init];
    args.methodName                        = LBS_CheckUserPushInfo;//要调用的webservice方法
    args.soapParams                        = params;//传递方法参数
    args.httpWay                           = ServiceHttpPost;
//    NSLog(@"参数%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager HTTPRequestOperationWithArgs:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"xml:%@",operation.responseString);
        //处理xml
        NSString *theXML                       = operation.responseString;
        NSArray *array1                        = [NSArray arrayWithObjects:@"return>",@"</",nil];
        NSArray *ziFuArray                     = [NSArray arrayWithObjects:array1,nil];
        for (NSArray *array in ziFuArray) {
            NSRange range                          = [theXML rangeOfString:[array objectAtIndex:0]];
            if(range.length>0)
            {
                theXML                                 = [theXML substringFromIndex:range.location+7];
                range                                  = [theXML rangeOfString:[array objectAtIndex:1]];
                if(range.length>0)
                {
                    theXML                                 = [theXML substringToIndex:range.location+(range.length-2)];
                }
                break;
            }
        }
        //解析json
        NSDictionary *diction                  = [NSJSONSerialization JSONObjectWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        NSString *codeStr                      = [diction objectForKey:@"rcode"];
        //        071b8342ef0
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSLog(@"极光推送RID上传成功！");
        }else{
            NSLog(@"极光推送RID上传失败！");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

/**
 *  获取异常报警和报警工单中处置中的工单个数
 */
- (void)getCountOfAlarmAndOrder {
    
    //开始请求
    //创建JSON
    NSDictionary *dictonary                = [[NSMutableDictionary alloc] init];
    [dictonary setValue:[utils getlogName] forKey:@"userAccnt"];
    
    [YNRequest YNPost:LBS_AlarmAndOrderUndoneCount parameters:dictonary
              success:^(NSDictionary *dic) {
                
//                  NSLog(@"%@", dic);
                  NSString *codeStr = [dic objectForKey:@"rcode"];
                  if ([codeStr isEqualToString:@"0x0000"]) {
                      
                      NSArray *arr = [dic objectForKey:@"rows"];
                      NSDictionary *contentDic = arr[0];
                      
                      self.orderNumLabel.text = [NSString stringWithFormat:@"%@", contentDic[@"inProgress"]];
                      self.totalNews = [NSString stringWithFormat:@"%@", contentDic[@"totalNum"]];
                      if ([self.orderNumLabel.text isEqualToString:@"0"]) {
                          self.orderNumLabel.hidden = YES;
                      }else{
                          self.orderNumLabel.hidden = NO;
                      }
                      
                      // 程序首次启动时设置消息个数为0，之后存储每次的消息个数，并与之前的消息个数进行比较
                      if ([utils getNewsCount] == nil) {
                          
                          [utils setNewsCount:@"0"];
                      }else{
                          
                          // 判断接口请求的消息个数是否大于存储的消息个数，若大于则修改右上角消息按钮背景
                          if ([self.totalNews integerValue] > [[utils getNewsCount] integerValue]) {
                              
                              // 重新设置导航栏右侧按钮的图标
                              [self.informationCardBtn setImage:[UIImage imageNamed:@"message_yes"] forState:(UIControlStateNormal)];
                          }
                      }
                      
                      // 求得报警工单标记数字的size
                      CGSize orderSize = [self.orderNumLabel.text sizeWithAttributes:@{NSFontAttributeName:self.orderNumLabel.font}];
//                      NSLog(@"%f--%f", orderSize.height, orderSize.width);
                      self.orderNumLabel.frame = CGRectMake(self.orderNumLabel.frame.origin.x, self.orderNumLabel.origin.y, orderSize.height, orderSize.height);
                      self.orderNumLabel.layer.cornerRadius = orderSize.height / 2;
                  }else{
                      
                  }
              } fail:^{
                  
              }];
}

#pragma mark - Event Response
/**
 *  点击一般按钮
 *
 *  @param btn 按钮
 */
- (void)clickBtnInView:(UIButton *)btn {
    
    Class class = NSClassFromString(self.classNameArr[btn.tag]);
    
    UIViewController *viewController = [[class alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  点击数据分析按钮
 */
- (void)dataAction {
    
    Class class = NSClassFromString(self.dataAlyArr[0]);
    
    UIViewController *viewController = [[class alloc] init];
    DateListVC *dataVC = (DateListVC *)viewController;
    dataVC.arrName = [NSMutableArray arrayWithArray:self.dataNameArr];
    dataVC.arrPic = [NSMutableArray arrayWithArray:self.dataImageArr];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  点击消息通知按钮，存储消息个数
 */
- (void)messageAction {
    
    MessageNotificationVC *messageVC = [[MessageNotificationVC alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
    // 重新设置导航栏右侧按钮的图标
    [self.informationCardBtn setImage:[UIImage imageNamed:@"message_no"] forState:(UIControlStateNormal)];
    // 存储最新的消息个数
    [utils setNewsCount:self.totalNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
