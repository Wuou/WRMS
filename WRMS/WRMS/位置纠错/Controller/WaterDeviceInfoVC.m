//
//  WellInfoVC.m
//  LeftSlide
//
//  Created by YangJingchao on 15/12/21.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import "WaterDeviceInfoVC.h"
#import "UIView+SDAutoLayout.h"

@interface WaterDeviceInfoVC ()

@property (nonatomic,strong) IBOutlet UILabel    *labelType;
@property (nonatomic,strong) IBOutlet UILabel    *labelModel;
@property (nonatomic,strong) IBOutlet UILabel    *labelIMEI;
@property (nonatomic,strong) IBOutlet UILabel    *labelUnit;
@property (nonatomic,strong) IBOutlet UILabel    *labelTime;
@property (nonatomic,strong) IBOutlet UILabel    *labelState;
@property (nonatomic,strong) IBOutlet UITextView *labelRemark;
@property (nonatomic,strong) IBOutlet UILabel    *labelFuzhuNo;
@property (nonatomic,strong) IBOutlet UILabel    *labelId;
@property (nonatomic,strong) IBOutlet UILabel    *labelAdresTitle;
@property (nonatomic,strong) IBOutlet UILabel    *labelAddress;
@property (nonatomic,strong) IBOutlet UILabel    *lineLbl;
@property (nonatomic,strong) IBOutlet UILabel    *remarkTitleLbl;
@property (nonatomic,strong) IBOutlet UIView     *BGWhiteView;
@property (nonatomic,strong) IBOutlet UIScrollView *mysv;

@end

@implementation WaterDeviceInfoVC

#pragma mark Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title                            = @"水位设备详情";
        // Custom initialization
        UIBarButtonItem *backItem             = [[UIBarButtonItem alloc] init];
        backItem.title                        = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelType.text    = self.wmodel.pointTypeName;
    self.labelModel.text   = self.wmodel.pointName;
    self.labelIMEI.text    = self.wmodel.codeImeistr;
    self.labelUnit.text    = self.wmodel.unitNamestr;
    self.labelTime.text    = self.wmodel.createTimestr;
    self.labelState.text   = self.wmodel.waterMchnStateName;
    self.labelRemark.text  = self.wmodel.remarkstr;
    self.labelId.text      = self.wmodel.pointId;
    self.labelFuzhuNo.text = self.wmodel.coversIdCustom;
    self.labelAddress.text = self.wmodel.locationstr;
    
    [self sdLayout];
    
    self.mysv.contentSize  = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.labelRemark.frame) + 40);
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Private methods
- (void)sdLayout
{
    self.labelAddress.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width - 88)
    .autoHeightRatio(0)
    .leftSpaceToView(self.labelAdresTitle, 5)
    .topSpaceToView(self.labelFuzhuNo,10);
    
    if (self.labelAddress.text.length == 0)
    {
        self.lineLbl.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftEqualToView(self.labelAdresTitle)
        .topSpaceToView(self.labelAdresTitle, 38);
    }else{
        self.lineLbl.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width)
        .heightIs(1)
        .leftEqualToView(self.labelAdresTitle)
        .topSpaceToView(self.labelAddress, 8);
    }
    
    self.remarkTitleLbl.sd_layout.widthIs(82)
    .heightIs(38)
    .leftEqualToView(self.labelAdresTitle)
    .topSpaceToView(self.lineLbl, 0);
    
    self.labelRemark.sd_layout.widthIs([UIScreen mainScreen].bounds.size.width - 90)
    .heightIs(85)
    .leftSpaceToView(self.labelAdresTitle, 5)
    .topSpaceToView(self.lineLbl, 1);
    
    self.BGWhiteView.frame = CGRectMake(0, 16, self.BGWhiteView.frame.size.width, CGRectGetMaxY(self.labelRemark.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
