//
//  InspectionInfoVC.h
//  LeftSlide
//
//  Created by YangJingchao on 15/11/5.
//  Copyright © 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionInfoVC : UIViewController
@property(nonatomic,strong)IBOutlet UITextField *tf_labelId;
@property(nonatomic,strong)IBOutlet UILabel *label_Name;
@property(nonatomic,strong)IBOutlet UILabel *label_Latitude;
@property(nonatomic,strong)IBOutlet UILabel *label_Lontitude;
@property(nonatomic,strong)IBOutlet UILabel *label_Address;
@property(nonatomic,strong)IBOutlet UILabel *label_Desc;
@property (weak, nonatomic) IBOutlet UILabel *label_WaterHeight;
@property (weak, nonatomic) IBOutlet UILabel *label_PointTypeName;
@property (weak, nonatomic) IBOutlet UILabel *label_WaterMchnStateName;

@property(nonatomic,strong)IBOutlet UILabel *labelAddressTitle;
@property(nonatomic,strong)IBOutlet UILabel *labelDescTitle;

@property(nonatomic,strong)IBOutlet UILabel *labelLineAddress;
@property(nonatomic,strong)IBOutlet UILabel *labelLineDesc;

@property(nonatomic,strong)IBOutlet UILabel *labelWaterMchnId;
@property(nonatomic,strong)IBOutlet UILabel *labelWaterIMEI;

@property(nonatomic,strong)IBOutlet UIView *viewBG;
@property(nonatomic,strong)IBOutlet UIScrollView *infoScrollView;
@property(nonatomic,strong)IBOutlet UILabel *labelTime;
@property(nonatomic,strong)PointModel *pmodel;
@end
