//
//  IssuedOrderVC.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/9/2.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "IssuedOrderVC.h"
#import "KTActionSheet.h"
#import "UIColor-Expanded.h"
#import "SVProgressHUD.h"
#import "UIViewController+KNSemiModal.h"
#import "TaskPlanApi.h"
#import "UserModel.h"



@interface IssuedOrderVC ()
@property (nonatomic,strong) NSMutableArray *arrIssuedUser;
@property (nonatomic,strong) NSMutableArray *arrIssuedUnit;
@property (nonatomic,strong) NSMutableArray *arrUserText;
@property (nonatomic,strong) NSMutableArray *arrUserId;
@property (nonatomic,strong) NSMutableArray *arrUnitText;
@property (nonatomic,strong) NSMutableArray *arrUnitId;

@property (nonatomic,strong) IBOutlet UITextField *tf_name;
@property (nonatomic,strong) IBOutlet UITextField *tf_time;
@property (nonatomic,strong) IBOutlet UITextView  *tv_desc;

@property (nonatomic,strong) IBOutlet UILabel *lbl_time;
@property (nonatomic,strong) IBOutlet UIButton *btnTime;
@property (nonatomic,strong) IBOutlet UILabel *lbl_Desc;
@property (nonatomic,strong) IBOutlet UIImageView *imgSanjiao;

@property (nonatomic,strong) NSString *strNameId;
@property (nonatomic,strong) NSString *strNameText;
@property (nonatomic,strong) NSString *strUnitId;
@property (nonatomic,strong) NSString *strUnitText;
@property (nonatomic,strong) IBOutlet UISegmentedControl *mySegmengtControl;
@property (nonatomic,strong) IBOutlet UILabel *lbl_nameTitle;

/** 下方展示标签view*/
@property (strong, nonatomic) IBOutlet UIView *timeView;
/** 选择日期view*/
@property (strong, nonatomic) UIDatePicker *workPicker;
/** 确定日期按钮*/
@property (strong, nonatomic) UIButton *btnOK;
@property (nonatomic,strong) NSString *strChoiceTime;

@end

@implementation IssuedOrderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

- (void)viewDidLoad {
    self.title = @"下发工单详情";
    self.arrIssuedUser = [[NSMutableArray alloc]init];
    self.arrIssuedUnit = [[NSMutableArray alloc]init];
    self.arrUserId = [[NSMutableArray alloc]init];
    self.arrUserText =[[NSMutableArray alloc]init];
    self.arrUnitText = [[NSMutableArray alloc]init];
    self.arrUnitId = [[NSMutableArray alloc]init];
    
    [self.mySegmengtControl setTintColor:[UIColor colorWithHexString:@"00c0f1"]];
    [self.mySegmengtControl addTarget:self action:@selector(selectTypeSeqment:) forControlEvents:UIControlEventValueChanged];
    
    [self getIssuedList];
    [self getIssuedUnitList];
    [self setTimeView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//用户单位二选一
- (void)selectTypeSeqment:(UISegmentedControl *)myControl {
    if (myControl.selectedSegmentIndex == 0) {
        self.lbl_nameTitle.text = @"用户:";
        self.tf_name.text = self.strNameText;
        self.tf_name.placeholder = @"请选择下发用户";
        
        if (self.lbl_time.isHidden) {
            [self.lbl_time setHidden:NO];
            [self.btnTime setHidden:NO];
            [self.imgSanjiao setHidden:NO];
            [self.tf_time setHidden:NO];
            
            [self.lbl_Desc setFrame:CGRectMake(self.lbl_Desc.frame.origin.x, self.lbl_Desc.frame.origin.y + 56, self.lbl_Desc.frame.size.width, self.lbl_Desc.frame.size.height)];
            [self.tv_desc setFrame:CGRectMake(self.tv_desc.frame.origin.x, self.tv_desc.frame.origin.y + 56, self.tv_desc.frame.size.width, self.tv_desc.frame.size.height)];
            [self.btnOK setFrame:CGRectMake(self.btnOK.frame.origin.x, self.btnOK.frame.origin.y + 56, self.btnOK.frame.size.width, self.btnOK.frame.size.height)];
        }
    }else{
        self.lbl_nameTitle.text = @"单位:";
        self.tf_name.text = self.strUnitText;
        self.tf_name.placeholder = @"请选择下发单位";
        
        //隐藏时间
        [self.lbl_time setHidden:YES];
        [self.btnTime setHidden:YES];
        [self.imgSanjiao setHidden:YES];
        [self.tf_time setHidden:YES];
        
        [self.lbl_Desc setFrame:CGRectMake(self.lbl_Desc.frame.origin.x, self.lbl_Desc.frame.origin.y - 56, self.lbl_Desc.frame.size.width, self.lbl_Desc.frame.size.height)];
        [self.tv_desc setFrame:CGRectMake(self.tv_desc.frame.origin.x, self.tv_desc.frame.origin.y - 56, self.tv_desc.frame.size.width, self.tv_desc.frame.size.height)];
        [self.btnOK setFrame:CGRectMake(self.btnOK.frame.origin.x, self.btnOK.frame.origin.y - 56, self.btnOK.frame.size.width, self.btnOK.frame.size.height)];
        
        
    }
}

//选择用户或单位的名称
- (IBAction)chooseNameAction:(id)sender
{
    if(self.mySegmengtControl.selectedSegmentIndex == 0) {
        KTActionSheet *actionSheet = [[KTActionSheet alloc] initWithTitle:@"用户列表" itemTitles:self.arrUserText];
        actionSheet.delegate = self;
        actionSheet.tag = 13;
        __weak typeof(self) weakSelf = self;
        [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
            weakSelf.tf_name.text = [NSString stringWithFormat:@"%@", title];
            self.strNameText = [NSString stringWithFormat:@"%@", title];
            self.strNameId = [self.arrUserId objectAtIndex:index];
        }];
    }else{
        KTActionSheet *actionSheet   = [[KTActionSheet alloc] initWithTitle:@"单位列表" itemTitles:self.arrUnitText];
        actionSheet.delegate         = self;
        actionSheet.tag              = 13;
        __weak typeof(self) weakSelf = self;
        [actionSheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
            weakSelf.tf_name.text = [NSString stringWithFormat:@"%@", title];
            self.strUnitText = [NSString stringWithFormat:@"%@", title];
            self.strUnitId = [self.arrUnitId objectAtIndex:index];
        }];
    }
    
}

//获取下发人员列表
- (void)getIssuedList{
    [TaskPlanApi apiWithIssuedUserList:self.arrIssuedUser issuedBlock:^{
        for (UserModel *tmodel in self.arrIssuedUser)
        {
            if(![self.arrUserId containsObject:tmodel.idField]){
                [self.arrUserId addObject:tmodel.idField];
            }
            if (![self.arrUserText containsObject:tmodel.text])
            {
                [self.arrUserText addObject:tmodel.text];
            }
        }
    }];
}

//获取下发单位列表
- (void)getIssuedUnitList {
    
    [TaskPlanApi apiWithIssuedUnitList:self.arrIssuedUnit unitId:self.strOrderUnitId issuedBlock:^{
        for (UserModel *tmodel in self.arrIssuedUnit)
        {
            if(![self.arrUnitId containsObject:tmodel.idField]){
                [self.arrUnitId addObject:tmodel.idField];
            }
            if (![self.arrUnitText containsObject:tmodel.text])
            {
                [self.arrUnitText addObject:tmodel.text];
            }
        }
    }];
}

//设置时间选择视图
- (void)setTimeView {
    //时间选择组件view
    self.workPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,54,[UIScreen mainScreen].bounds.size.width,200)];
    [self.workPicker setValue:[UIColor darkGrayColor] forKey:@"textColor"];
    self.workPicker.tintColor = [UIColor darkGrayColor];
    [self.workPicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    self.workPicker.datePickerMode = UIDatePickerModeDate;
    [self.timeView addSubview:self.workPicker];
    
    //时间选择后确定按钮
    self.btnOK = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 93,5,88,44)];
    [self.btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [self.btnOK setBackgroundColor:[UIColor colorWithHexString:@"00c0f1"]];
    [self.btnOK.layer setCornerRadius:8];
    [self.btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnOK addTarget:self action:@selector(timeOkAction) forControlEvents:UIControlEventTouchDown];
    [self.btnOK.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.timeView addSubview:self.btnOK];
    
    //当前时间
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    self.strChoiceTime = locationString;
}

//点击选择时间控件
- (IBAction)showTimeChoiceViewAction:(id)sender {
    UIImageView *backgroundV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
    self.timeView.backgroundColor = [UIColor whiteColor];;
    [self presentSemiView:self.timeView withOptions:@{KNSemiModalOptionKeys.backgroundView:backgroundV}];
    [self.timeView setHidden:NO];
}

//时间确定
- (void)timeOkAction {
    NSDate *_date = self.workPicker.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    self.strChoiceTime = [dateformatter stringFromDate:_date];
    
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatterNow = [[NSDateFormatter alloc] init];
    [dateformatterNow setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [dateformatterNow stringFromDate:senddate];
    
    if ([[self.strChoiceTime stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue] >=  [[locationString stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue])
    {
        self.tf_time.text = self.strChoiceTime;
        [self dismissSemiModalView];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"无法选择该日期"];
    }
}

- (IBAction)toIssuedAction:(id)sender {
    NSString *strDesc = self.tv_desc.text;
    NSString *strTime = self.tf_time.text;
    if (self.mySegmengtControl.selectedSegmentIndex == 0) {
        if ([self.strNameId isEqualToString:@""] || [strDesc isEqualToString:@""] || [strTime isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请填写完成信息"];
        }else{
            [TaskPlanApi apiWithIssued:self.strOrderId remark:strDesc issuedUserId:self.strNameId issuedUnitId:nil time:strTime isSucBlock:^{
                [self performSelector:@selector(toPopList) withObject:nil afterDelay:1.f];
            }];
        }
    }else{
        if ([self.strNameId isEqualToString:@""] || [strDesc isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请填写完成信息"];
        }else{
            [TaskPlanApi apiWithIssued:self.strOrderId remark:strDesc issuedUserId:nil issuedUnitId:self.strUnitId time:nil isSucBlock:^{
                [self performSelector:@selector(toPopList) withObject:nil afterDelay:1.f];
            }];
        }
    }
}

- (void)toPopList {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshEventManageList" object:nil userInfo:nil];
    NSInteger index = [[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
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
