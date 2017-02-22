//
//  FeedBackVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/10/19.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import "FeedBackVC.h"

@interface FeedBackVC ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation FeedBackVC
#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"意见反馈";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutSubviews];
}


#pragma mark - event response
- (IBAction)upChilk:(UIButton *)sender {
    
    _fbContentTextViewStr=_fbContentTextView.text;
    _userTelTextFieldStr=_userTelTextField.text;
    _createrTextFieldStr=_createrTextField.text;
   
    //当前时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.createTimeStr=[dateformatter stringFromDate:senddate];
    
    //判断非空
    if ( _fbContentTextViewStr== nil || [_fbContentTextViewStr isEqualToString:@""] || _userTelTextFieldStr == nil || [_userTelTextFieldStr isEqualToString:@""] ||  _createrTextFieldStr == nil || [_createrTextFieldStr isEqualToString:@""] ) {
        [SVProgressHUD showInfoWithStatus:@"请填写完整信息"];
    }else {
        
        if(![utils isMobileNumber:_userTelTextFieldStr])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确格式的电话号码"];
        }else{
            [SVProgressHUD showWithStatus:@"正在提交您的意见,请稍等..." maskType:SVProgressHUDMaskTypeClear];
        //创建字典
        NSDictionary *dictonary = [[NSMutableDictionary alloc] init];
        //创建链表
        [dictonary setValue:_fbContentTextViewStr forKey:@"fbContent"];
        [dictonary setValue:_userTelTextFieldStr  forKey:@"userTel"];
        [dictonary setValue:_createTimeStr        forKey:@"createTime"];
        [dictonary setValue:_createrTextFieldStr  forKey:@"userAccnt"];
        
        //请求
        [YNRequest YNPost:LBS_CreateFeedback parameters:dictonary success:^(NSDictionary *dic) {
            NSString *codeStr = [dic objectForKey:@"rcode"];
            NSString *rmessage = [dic objectForKey:@"rmessage"];
            if ([codeStr isEqualToString:@"0x0000"])
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
                        [self performSelector:@selector(toPopVC) withObject:nil afterDelay:0.01f];
                });
            }else{
                if ([codeStr isEqualToString:@"0x0016"])
                {
                    [utils setLoginAgain];
                }else{
                    [SVProgressHUD showErrorWithStatus:rmessage];
                }
            }
        } fail:^{
            [SVProgressHUD showInfoWithStatus:@"网络异常,请检查网络"];
        }];
    }
 }
}
- (void)toPopVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextView Delegate
/**
 *  限制textView的字数输入在30字以内
 *
 *  @param textView textView
 */
-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > 30) {
        [SVProgressHUD showInfoWithStatus:@"内容最多输入30个字"];
        textView.text    = [textView.text substringToIndex:30];
        number           = 30;
    }
}

#pragma mark - TextField Delegate
/**
 *  限制textField的字数输入在4个字和11个字以内
 *
 *  @param textField textField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 30001) {
        NSInteger number = [textField.text length];
        if (number > 4) {
            [SVProgressHUD showInfoWithStatus:@"姓名最多输入4位"];
            textField.text    = [textField.text substringToIndex:4];
            number            = 4;
        }
    }
}

#pragma mark - private methods
- (void)layoutSubviews {
    self.userTelTextField.layer.borderColor =[[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0] CGColor];
    self.createrTextField.layer.borderColor =[[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0] CGColor];
    _userTelTextField.layer.borderWidth = 0.5;
    _createrTextField.layer.borderWidth = 0.5;
    _userTelTextField.layer.cornerRadius = 6;//倒圆角
    _createrTextField.layer.cornerRadius = 6;//倒圆角
    
    _fbContentTextView.layer.borderColor= [[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0] CGColor];
    _fbContentTextView.layer.borderWidth = 0.5;
    _fbContentTextView.layer.cornerRadius = 6;//倒圆角
    _fbContentTextView.layer.masksToBounds = YES;
    _mySv.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+200);
    _mySv.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    _createrTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _userTelTextField.clearButtonMode=UITextFieldViewModeWhileEditing;

    _fbContentTextView.delegate  = self;
    _createrTextField.delegate   = self;
    _createrTextField.tag = 30001;
    [self.view addSubview:_mySv];
}

//检测手机号是否合法
- (BOOL)checkTel:(NSString *)str {
    if ([str length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data_null_prompt", nil) message:NSLocalizedString(@"tel_no_null", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;        
    }
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
