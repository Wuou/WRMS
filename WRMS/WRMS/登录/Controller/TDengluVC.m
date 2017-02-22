//
//  TDengluVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/22.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "TDengluVC.h"
#import "LoginApi.h"

@interface TDengluVC ()

/** scrollView*/
@property (strong, nonatomic) UIScrollView *myScrollView;

/** 头像*/
@property (strong, nonatomic) UIImageView *iconImageView;
/** 账号标题*/
@property (strong, nonatomic) UILabel *accountTitle;
/** 密码标题*/
@property (strong, nonatomic) UILabel *PswTitle;
/** 第一条分割线*/
@property (strong, nonatomic) UIView *firstSegLine;
/** 第二条分割线*/
@property (strong, nonatomic) UIView *secondSegLine;

/** 用户名输入框*/
@property (nonatomic, strong) UITextField *tfName;
/** 登录按钮*/
@property (strong, nonatomic) UIButton *btLogin;
/** 忘记密码按钮*/
@property (strong, nonatomic) UIButton *btPsw;
/** 密码输入框*/
@property (nonatomic, strong) UITextField *tfPsw;
/** 密码输入框右侧的眼睛*/
@property (nonatomic, strong) UIButton *isVisiableBtn;
/** 判断是否离线模式*/
@property (nonatomic, assign) BOOL isOffLine;

@end

@implementation TDengluVC
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    backImageView.image = [UIImage imageNamed:@"backImageView"];
    [self.view addSubview:backImageView];
    
    // 布局
    self.view.backgroundColor = [UIColor whiteColor];
    self.myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.myScrollView];
    
    [self setSubviewsLayout];
    
    // 进入登录界面首先取消登录
    [utils cancelLogin];
    
    // 设置登录账户密码为退出之前的账号密码
    self.tfName.text = [utils getlogName];
    self.tfPsw.text  = [utils getlogPsw];
    _tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfPsw.clearButtonMode  = UITextFieldViewModeWhileEditing;
    [_btLogin.layer setCornerRadius:6];
    
    //运用addTarget监听用户名输入框的改变
    [self.tfName addTarget:self action:@selector(tfNameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Event Response
/**
 *  点击登录按钮
 *
 *  @param sender 按钮
 */
-(void)loginAction:(id)sender {
    
    if (self.tfName.text == nil || [self.tfName.text isEqualToString:@""] || self.tfPsw.text == nil || [self.tfPsw.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }else{
        
        // 检测真实网络情况
        [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
           
            if (status == RealStatusNotReachable) {
                
                [SVProgressHUD showErrorWithStatus:@"网络连接异常，请检查网络设置！"];
            }else{
                
                // 真实登录
                [self toLog];
            }
        }];
    }
}

- (void)isVisiableAction:(UIButton *)btn {
    
    if (self.tfPsw.isSecureTextEntry) {
        self.tfPsw.secureTextEntry = NO;
    }else {
        self.tfPsw.secureTextEntry = YES;
    }
}

/**
 *  点击忘记密码按钮
 *
 *  @param sender 按钮
 */
-(void)remeberPsw:(id)sender{
    
    [SVProgressHUD showInfoWithStatus:@"如果您忘记密码，请联系管理员为您重置密码"];
}

#pragma mark - Private Methods
/**
 *  布局子控件
 */
- (void)setSubviewsLayout {
    
    // 头像布局
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"logIcon"];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.layer.cornerRadius = 6.f;
    self.iconImageView.frame = CGRectMake((kWidth - 75) / 2, kHeight / 5, 75, 75);
    [self.myScrollView addSubview:self.iconImageView];
    
    // 账号图片
    UIImageView *accountImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.iconImageView.frame.origin.y + 120, 23, 23)];
    accountImage.image = [UIImage imageNamed:@"accountIcon"];
    [self.myScrollView addSubview:accountImage];
    
    
    // 账号
    self.tfName = [[UITextField alloc] init];
    self.tfName.textColor = [UIColor darkGrayColor];
    self.tfName.placeholder = @"请输入账号";
    [self.tfName setValue:[UIColor colorWithHexString:@"bdbdbd"] forKeyPath:@"_placeholderLabel.textColor"];
    self.tfName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfName.frame = CGRectMake(80, accountImage.frame.origin.y, kWidth - 140, 30);
    [self.myScrollView addSubview:self.tfName];
    
    // 第一条分割线
    self.firstSegLine = [[UIView alloc] init];
    self.firstSegLine.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];
    self.firstSegLine.frame = CGRectMake(40, accountImage.frame.origin.y + 30, kWidth - 80, 1);
    [self.myScrollView addSubview:self.firstSegLine];
    
    // 密码图片
    UIImageView *pswImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.firstSegLine.frame.origin.y + 11, 23, 23)];
    pswImage.image = [UIImage imageNamed:@"pswIcon"];
    [self.myScrollView addSubview:pswImage];
    
    // 密码
    self.tfPsw = [[UITextField alloc] init];
    self.tfPsw.textColor = [UIColor darkGrayColor];
    self.tfPsw.placeholder = @"请输入密码";
    [self.tfPsw setValue:[UIColor colorWithHexString:@"bdbdbd"] forKeyPath:@"_placeholderLabel.textColor"];
    self.tfPsw.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tfPsw.secureTextEntry = YES;
    self.tfPsw.frame = CGRectMake(80, pswImage.frame.origin.y, kWidth - 140, 30);
    [self.myScrollView addSubview:self.tfPsw];
    
    // 密码右侧的眼睛
    self.isVisiableBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.isVisiableBtn.frame = CGRectMake(kWidth - 60, self.tfPsw.frame.origin.y + 10, 20, 20);
    [self.isVisiableBtn setImage:[UIImage imageNamed:@"visiableEye"] forState:(UIControlStateNormal)];
    [self.isVisiableBtn addTarget:self action:@selector(isVisiableAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.myScrollView addSubview:self.isVisiableBtn];
    
    // 第二条分割线
    self.secondSegLine = [[UIView alloc] init];
    self.secondSegLine.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];
    self.secondSegLine.frame = CGRectMake(40, pswImage.frame.origin.y + 30, kWidth - 80, 1);
    [self.myScrollView addSubview:self.secondSegLine];
    
    // 登录按钮
    self.btLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btLogin.backgroundColor = [UIColor colorWithHexString:@"56b3f5"];
    [self.btLogin setTitle:@"登录" forState:(UIControlStateNormal)];
    [self.btLogin setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.btLogin addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.btLogin.layer.cornerRadius = 6.f;
    self.btLogin.frame = CGRectMake(20, self.secondSegLine.frame.origin.y + 30, kWidth - 40, 44);
    [self.myScrollView addSubview:self.btLogin];
    
    // 忘记密码按钮
    self.btPsw = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btPsw.backgroundColor = [UIColor clearColor];
    [self.btPsw setTitle:@"忘记密码？" forState:(UIControlStateNormal)];
    self.btPsw.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btPsw addTarget:self action:@selector(remeberPsw:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btPsw setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.btPsw.frame = CGRectMake(10, kHeight - 41, 74, 31);
    [self.myScrollView addSubview:self.btPsw];
    
    self.myScrollView.contentSize = CGSizeMake(kWidth, kHeight);
}
/**
 *  登录请求接口
 */
-(void)toLog {
    
    [LoginApi apiLoginSystemWithAccount:self.tfName.text
                               password:self.tfPsw.text
                      loginSuccessBlock:^{
                          
                          [self dismissViewControllerAnimated:YES completion:nil];
                          [utils setLoginOk];
                      }];
}

/**
 *  切换账号时，密码清空
 *
 *  @param sender textfield
 */
- (void)tfNameValueChanged:(id)sender
{
    //密码框置空
    [self.tfPsw setText:@""];
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
