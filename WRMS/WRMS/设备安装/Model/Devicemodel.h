//
//  DeviceInstallVCmodel.h
//  LeftSlide
//
//  Created by 杨景超 on 15/12/21.
//  Copyright © 2015年 陕西永诺信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Devicemodel : NSObject

@property(nonatomic,strong)NSString *coversIdCustom;
@property(nonatomic,strong)NSString *strlocation;//地址
@property(nonatomic,strong)NSString *strcoversId;//水位编号
@property(nonatomic,strong)NSString *strcoversTypeName;//型号

@property(nonatomic,strong)NSString *strmodeId;//水位型号
@property(nonatomic,strong)NSString *strmchnId;//设备编号
@property(nonatomic,strong)NSString *strcodeImei;//imei
@property(nonatomic,strong)NSString *strunitName;//所属单位
@property(nonatomic,strong)NSString *strinstallTime;//安装时间

@property(nonatomic,strong)NSString *strlinkUser;//联系人
@property(nonatomic,strong)NSString *strlinkTel;//联系电话
@property(nonatomic,strong)NSString *strstatusName;//水位状态
@property(nonatomic,strong)NSString *strremark;//备注信息
@property(nonatomic,strong)NSString *strlongitude;//
@property(nonatomic,strong)NSString *straltitude;//
@property(nonatomic,strong)NSString *strmodeName;////水位类别
@property(nonatomic,strong)NSString *strunitId;//
@property(nonatomic,strong)NSString *strupdateUserAccnt;//用户账号

@property(nonatomic,strong)NSString *mchnStatestr;
@property(nonatomic,strong)NSString *mchnStateNamestr;

@property (nonatomic, strong) NSString * pointId;
@property (nonatomic, strong) NSString * pointName;
@property (nonatomic, strong) NSString * pointTypeId;
@property (nonatomic, strong) NSString * pointTypeName;
@property (nonatomic, assign) CGFloat waterHeight;
@property (nonatomic, strong) NSString * waterMchnId;
@property (nonatomic, strong) NSString * waterMchnName;
@property (nonatomic, strong) NSString * waterMchnState;
@property (nonatomic, strong) NSString * waterMchnStateName;


-(instancetype)initWithDict:(NSDictionary *)dict;
@end
