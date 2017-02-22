//
//  WellModel.h
//  LeftSlide
//
//  Created by YangJingchao on 15/12/16.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

//alarmFlag = "";
//alarmStatus = 0;
//alarmstatusName = "";
//altitude = "0.000000";
//areaId = "rg_156610113";
//areaName = "\U9655\U897f\U7701\U897f\U5b89\U5e02\U96c1\U5854\U533a";
//codeImei = 100000000000002;
//coversId = S00000002;
//coversIds =             (
//);
//coversInstallTime = "";
//coversName = "";
//coversType = S;
//coversTypeName = "\U6392\U6c34";
//createTime = "2015-12-05 14:57:41";
//createUserAccnt = paishui2;
//district = "rg_156610113";
//installTime = "2015-12-05 15:35:46";
//latitude = "34.194860";
//linkTel = "029-88888888";
//linkUser = "\U5f20XX";
//location = "\U9655\U897f\U7701\U897f\U5b89\U5e02\U96c1\U5854\U533a\U5510\U5ef6\U5357\U8def4\U53f7\U7eff\U5730\U7b14\U514b\U4f1a\U5c55\U4e2d\U5fc34\U53f7\U9986\U7fbd\U5cf0\U8fd0\U52a8\U7403\U9986\U4e1c\U5317\U7ea680\U7c73";
//longitude = "108.880810";
//mchnId = T0002;
//mchnState = 0004;
//mchnStateName = "\U5df2\U64a4\U9632";
//modeId = 2010;
//modeName = "\U9ad8\U5f3a\U5ea6\U94a2\U7ea4\U7ef4\U4e95\U76d6";
//nearbyFlag = "";
//remark = "";
//requestFlag = "";
//status = 0001;
//statusName = "\U95ed\U5408";
//unitId = 2015111315515594;
//unitName = "\U96c1\U5854\U533a\U73af\U4fdd\U5c40";
//updateTime = "2015-12-15 16:39:55";
//updateUserAccnt = paishui2;


@interface WaterModel : NSObject

@property (nonatomic,strong) NSString *coversIdCustom;
@property (nonatomic,strong) NSString *alarmFlagstr;
@property (nonatomic,strong) NSString *alarmStatusstr;
@property (nonatomic,strong) NSString *alarmstatusNamestr;
@property (nonatomic,strong) NSString *altitudestr;
@property (nonatomic,strong) NSString *areaIdstr;
@property (nonatomic,strong) NSString *areaNamestr;
@property (nonatomic,strong) NSString *codeImeistr;
@property (nonatomic,strong) NSString *coversIdstr;
@property (nonatomic,strong) NSString *coversIdsstr;
@property (nonatomic,strong) NSString *coversInstallTimestr;
@property (nonatomic,strong) NSString *coversNamestr;
@property (nonatomic,strong) NSString *coversTypestr;
@property (nonatomic,strong) NSString *coversTypeNamestr;
@property (nonatomic,strong) NSString *createTimestr;
@property (nonatomic,strong) NSString *createUserAccntstr;
@property (nonatomic,strong) NSString *districtstr;
@property (nonatomic,strong) NSString *installTimestr;
@property (nonatomic,strong) NSString *latitudestr;
@property (nonatomic,strong) NSString *linkTelstr;
@property (nonatomic,strong) NSString *linkUserstr;
@property (nonatomic,strong) NSString *locationstr;
@property (nonatomic,strong) NSString *longitudestr;
@property (nonatomic,strong) NSString *mchnIdstr;
@property (nonatomic,strong) NSString *mchnStatestr;
@property (nonatomic,strong) NSString *mchnStateNamestr;
@property (nonatomic,strong) NSString *modeIdstr;
@property (nonatomic,strong) NSString *modeNamestr;

@property (nonatomic, strong) NSString * pointId;
@property (nonatomic, strong) NSString * pointName;
@property (nonatomic, strong) NSString * pointTypeId;
@property (nonatomic, strong) NSString * pointTypeName;

@property (nonatomic,strong) NSString *nearbyFlagstr;
@property (nonatomic,strong) NSString *remarkstr;
@property (nonatomic,strong) NSString *requestFlagstr;
@property (nonatomic,strong) NSString *statusstr;
@property (nonatomic,strong) NSString *statusNamestr;
@property (nonatomic,strong) NSString *unitIdstr;
@property (nonatomic,strong) NSString *unitNamestr;
@property (nonatomic,strong) NSString *updateTimestr;
@property (nonatomic,strong) NSString *updateUserAccntstr;
@property (nonatomic, assign) CGFloat waterHeight;
@property (nonatomic, strong) NSString * waterMchnId;
@property (nonatomic, strong) NSString * waterMchnName;
@property (nonatomic, strong) NSString * waterMchnState;
@property (nonatomic, strong) NSString * waterMchnStateName;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
