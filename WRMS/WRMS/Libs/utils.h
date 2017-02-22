//
//  utils.h
//  CarInsurance
//
//  Created by yangjingchao on 13-12-10.
//
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <CoreLocation/CoreLocation.h>
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "CHKeychain.h"

@interface utils : NSObject

//账号所在城市名
+ (void)setUserCity:(NSString *)ucity;
+ (NSString *)getUserCity;
//用户类型
+ (void)setUserType:(NSString *)utype;
+ (NSString *)getUserType;
//用户名字
+ (void)setUname:(NSString *)uname;
+ (NSString *)getUname;
//单位名
+ (void)setUnitName:(NSString *)unitname;
+ (NSString *)getUnitName;
//单位id
+ (void)setUnitID:(NSString *)unitid;
+ (NSString *)getUnitID;
//设置城市编号
+ (void)setCityId:(NSString *)cid;
+ (NSString *)getCityId;
//设置城市名称
+ (void)setCityName:(NSString *)name;
+ (NSString *)getCityName;
//设置命名空间地址
+ (void)setAppWSUrl:(NSString *)url;
+ (NSString *)getAppWSUrl;
//附媒体地址
+ (void)setAppMeidaUrl:(NSString *)url;
+ (NSString *)getAppMeidaUrl;
//上传附媒体地址
+ (void)setAppUploadMeidaUrl:(NSString *)url;
+ (NSString *)getAppUploadMeidaUrl;
//地址类型
+ (void)setAddrCode:(NSString *)code;
+ (NSString *)getAddrCode;
//代理商code
+ (void)setAgentCode:(NSString *)agent;
+ (NSString *)getAgentCode;
//验证码
+ (void)setAuthenCode:(NSString *)code;
+ (NSString *)getAuthenCode;
// 保存多语言的选中状态
+ (void)setLanguage:(NSString *)language;
+ (NSString *)getLanguage;
//多地图选择
+ (void)setMapType:(NSString *)type;
+ (NSString *)getMapType;
//推送消息个数
+ (void)setNewsCount:(NSString *)count;
+ (NSString *)getNewsCount;

//再登录一次，获取验证码
+ (void)setLoginAgain;

//启动次数
+ (void)setAppStartNum:(NSString *)num;
+ (NSString *)getAppStartNum;
//上传经纬度时间间隔
+ (void)setUpLocationTimeInterval:(NSString*)timeinterval;
+ (NSString *)getUpLocationTimeInterval;


+ (void)setCoverUnit:(NSString *)cunite cunit:(NSString *)cunitId;
+ (NSString *)getCoverUnit;
+ (NSString *)getCoverUnitId;

+ (void)setCoverType:(NSString *)ctype ctypID:(NSString *)ctypeId;
+ (NSString *)getCoverType;
+ (NSString *)getCoverTypeId;

//登录
+ (BOOL)isLogin;//是否登录
+ (void)setLogin:(NSString*)logName password:(NSString*)logPsw;//设置登录名和密码
+ (void)setLoginOk;//设置登录ok
+ (void)cancelLogin;//登录失败
+ (NSString *)getlogName;
+ (NSString *)getlogPsw;

//验证手机号码是否存在
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isValidateEmail:(NSString *)email;

//极光regid
+ (void)setJpushId:(NSString *)jid;
+ (NSString *)getJpushId;

//当前是否连接定位设备
+ (BOOL)isConnectBox;
+ (void)setConnectOK;
+ (void)setConnectCancel;

//将UTC日期字符串转为本地时间字符串
+ (NSString *)getTimeUTCTime:(NSString *)utcTime;//时间 比如18:09:01
+ (NSString *)getDateUTCDate:(NSString *)utcDate;//日期 比如2015-12-08

//获取 appname  version
+ (NSString *)getVersionString;
//获取手机名字，如iphone5s
+ (NSString*)deviceName;

//去除字符串前后空格
+ (NSString *)deleteSpaceNSString:(NSString *)theString;

//设置左侧上传位置开关状态
+ (void)setLeftSortSwitchOn:(NSString *)state;
+ (NSString *)getLeftSortSwitchState;

// 坐标转换
// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor;
// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;

//判断用户是否已经允许
+ (BOOL)isAllowedNotification;
+ (BOOL)isSystemVersioniOS8;

//字符串转图片
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;

//图片转字符串
+ (NSString *)UIImageToBase64Str:(UIImage *) image;

//YW密码
+ (void)setYWPsw:(NSString *)psw;
+ (NSString *)getYWPsw;
//聊天对象id
+ (void)setChatWithPersonId:(NSString *)ywid;
+ (NSString *)getChatWithPersonId;

/**
 *  获取一段文本高度
 *
 *  @param content 文本内容
 *  @param width   控件宽度
 *
 *  @return 控件高度
 */
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width;
@end
