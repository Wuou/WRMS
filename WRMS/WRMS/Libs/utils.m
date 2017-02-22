//
//  utils.m
//  
//
//  Created by yangjingchao on 13-12-10.
//
//

#import "utils.h"
#import "CHKeychain.h"

NSString * const KEY_USERNAME_PASSWORD = @"com.yongnuo.wrms.usernamepassword";
NSString * const KEY_USERNAME = @"com.yongnuo.wrms.username";
NSString * const KEY_PASSWORD = @"com.yongnuo.wrms.password";

NSString * const KEY_JPUSHID = @"com.yongnuo.wrms.jpushid";                     //JPushId
NSString * const KEY_GETJPUSHID = @"com.yongnuo.wrms.getjpushid";               //getJpushId
NSString * const KEY_SETYWPSW = @"com.yongnuo.wrms.setywpsw";                   //YW PSW
NSString * const KEY_GETYWPSW = @"com.yongnuo.wrms.getywpsw";                   //getYWPSW
NSString * const KEY_SETUNITID = @"com.yongnuo.wrms.setunitid";                 //Set UnitId
NSString * const KEY_GETUNITID = @"com.yongnuo.wrms.getunitid";                 //Get UnitId

NSString * const KEY_SETAUTHCODE = @"com.yongnuo.wrms.setauthcode";             //Set AuthCode
NSString * const KEY_GETAUTHCODE = @"com.yongnuo.wrms.getauthcode";             //Get AuthCode

@implementation utils


//-------

//设置城市编号
+ (void)setCityId:(NSString *)cid {
    

    [[NSUserDefaults standardUserDefaults] setObject:cid forKey:@"cityId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCityId {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"];
}

//设置城市名称
+ (void)setCityName:(NSString *)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCityName {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
}

//设置命名空间地址
+ (void)setAppWSUrl:(NSString *)url {
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"appWSUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAppWSUrl {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"appWSUrl"];
}

//附媒体地址
+ (void)setAppMeidaUrl:(NSString *)url {
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"appMeidaUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAppMeidaUrl {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"appMeidaUrl"];
}

//上传附媒体地址
+(void)setAppUploadMeidaUrl:(NSString *)url{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"appUploadMeidaUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAppUploadMeidaUrl {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"appUploadMeidaUrl"];
}

+ (void)setAddrCode:(NSString *)code {
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"apprcode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAddrCode {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"apprcode"];
}


+ (void)setAuthenCode:(NSString *)code {
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"AuthenCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAuthenCode {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"AuthenCode"];
}

//代理商code
+ (void)setAgentCode:(NSString *)agent {
    [[NSUserDefaults standardUserDefaults] setObject:agent forKey:@"AgentCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAgentCode {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"AgentCode"];
}

+ (void)setLoginAgain
{
    [SVProgressHUD dismiss];
    // 获取单例类的登录次数，并进行++的操作
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tempAppDelegate.loginTimes++;
    // 60s后看这个方法执行了多少次
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"执行了%lD次重新验证方法", (long)tempAppDelegate.loginTimes);
        if (tempAppDelegate.loginTimes > 10) {
            
            [SVProgressHUD showWithStatus:@"账号在异地登录，请联系管理员之后，再次登录" maskType:(SVProgressHUDMaskTypeClear)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"CancelLogin" object:nil userInfo:nil];
                [SVProgressHUD dismiss];
            });
            tempAppDelegate.loginTimes = 0;
        }else{
            tempAppDelegate.loginTimes = 0;
        }
    });
    
    NSString *name =[utils getlogName];
    NSString *psw =[utils getlogPsw];
    
    //2.1
    NSString *pswMd5 = [SecurityUtil encryptMD5String:psw];
    
    //开始请求
    //创建JSON
    NSMutableDictionary *dictonary = [[NSMutableDictionary alloc] init];
    [dictonary setValue:name forKey:@"userAccnt"];
    [dictonary setValue:pswMd5 forKey:@"userPwd"];
    NSString *value;
    BOOL isValidJSONObject =  [NSJSONSerialization isValidJSONObject:dictonary];
    if (isValidJSONObject) {
        /*
         第一个参数:OC对象 也就是我们dict
         第二个参数:
         NSJSONWritingPrettyPrinted 排版
         kNilOptions 什么也不做
         */
        NSData *data =  [NSJSONSerialization dataWithJSONObject:dictonary options:kNilOptions error:nil];
        //打印JSON数据
        value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",value);
    }
    
    //AES加密
    value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    NSData *aesdataresult = [SecurityUtil encryptAESData:value];
    value =[SecurityUtil encodeBase64Data:aesdataresult];
//    NSLog(@"==%@",value);
    
    NSMutableArray *params=[NSMutableArray array];
    
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"input", nil]];
    
    //参数、地址等
    YNRequestWithArgs *args = [[YNRequestWithArgs alloc] init];
    args.methodName   = LBS_UserLogin;
    args.soapParams   = params;//传递方法参数
    args.httpWay=ServiceHttpSoap1;
    args.soapHeader = [NSString stringWithFormat:@"<token>%@</token>",@"9e5f309af1333fe8ca9133956e7e6232"];
    //    NSLog(@"参数%@",params);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager HTTPRequestOperationWithArgs:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"xml:%@",operation.responseString);
        //处理xml
        NSString *theXML = operation.responseString;
        NSArray *array1 = [NSArray arrayWithObjects:@"return>",@"</",nil];
        NSArray *ziFuArray = [NSArray arrayWithObjects:array1,nil];
        for (NSArray *array in ziFuArray) {
            NSRange range = [theXML rangeOfString:[array objectAtIndex:0]];
            if(range.length>0)
            {
                theXML = [theXML substringFromIndex:range.location+7];
                range = [theXML rangeOfString:[array objectAtIndex:1]];
                if(range.length>0)
                {
                    theXML = [theXML substringToIndex:range.location+(range.length-2)];
                }
                break;
            }
        }
        
        NSData *dd=[theXML dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data2=[GTMBase64 decodeData:dd];
        theXML=[SecurityUtil decryptAESData:data2];
//        NSLog(@"JSON====%@",theXML);
        //解析json
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSString *codeStr = [diction objectForKey:@"rcode"];
        if ([codeStr isEqualToString:@"0x0000"]) {
            NSArray *rowsDic = [diction objectForKey:@"rows"];
            for (NSDictionary *mydic in rowsDic) {
                NSString *codeStr = [mydic objectForKey:@"authenticode"];
                //解密
                NSData *dd=[codeStr dataUsingEncoding:NSUTF8StringEncoding];
                NSData *data2=[GTMBase64 decodeData:dd];
                codeStr=[SecurityUtil decryptAESData:data2];
                [utils setAuthenCode:codeStr];
                
                // 如果重复进行了10次重新验证，停止发送
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                //                NSLog(@"%D", tempAppDelegate.loginTimes);
                if (tempAppDelegate.loginTimes > 10) {
                    
                }else{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"getCodeAgained" object:nil userInfo:nil];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


//启动次数
+ (void)setAppStartNum:(NSString *)num {
    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"appStartNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getAppStartNum {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"appStartNum"];
}

//账号所在城市名
+ (void)setUserCity:(NSString *)ucity {
    [[NSUserDefaults standardUserDefaults] setObject:ucity forKey:@"UserCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserCity {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCity"];
}



//用户类型
+ (void)setUserType:(NSString *)utype {
    if ([[NSNull null] isEqual:utype]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"utype"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:utype forKey:@"utype"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUserType {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"utype"];
}

//用户名字
+ (void)setUname:(NSString *)uname {
    if ([[NSNull null] isEqual:uname]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"uname"];
    }else{
       [[NSUserDefaults standardUserDefaults] setObject:uname forKey:@"uname"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUname {
     return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"uname"];
}

//单位名
+ (void)setUnitName:(NSString *)unitname {
    if ([[NSNull null] isEqual:unitname]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"unitname"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:unitname forKey:@"unitname"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUnitName {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"unitname"];
}

//单位id
+ (void)setUnitID:(NSString *)unitid {
    if ([[NSNull null] isEqual:unitid]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"unitid"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:unitid forKey:@"unitid"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUnitID {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"unitid"];
}


//登录
+ (BOOL)isLogin
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)setLogin:(NSString*)logName password:(NSString*)logPsw {
    //存
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:logName forKey:KEY_USERNAME];
    [usernamepasswordKVPairs setObject:logPsw forKey:KEY_PASSWORD];
    [CHKeychain save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
}

+ (void)setLoginOk {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)cancelLogin {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getlogName {
    //取
    NSMutableDictionary *getusernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    return [getusernamepasswordKVPairs objectForKey:KEY_USERNAME];
}
+ (NSString *)getlogPsw {
    NSMutableDictionary *getusernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_USERNAME_PASSWORD];
    return [getusernamepasswordKVPairs objectForKey:KEY_PASSWORD];
}

// 保存多语言的选中状态
+ (void)setLanguage:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"appLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getLanguage {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
}

+ (void)setMapType:(NSString *)type {
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"mapType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getMapType {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"mapType"];
}

// 极光获取id
+ (void)setJpushId:(NSString *)jid {
    NSMutableDictionary *jpushidKVPairs = [NSMutableDictionary dictionary];
    [jpushidKVPairs setObject:jid forKey:KEY_JPUSHID];
    [CHKeychain save:KEY_GETJPUSHID data:jpushidKVPairs];
}

+ (NSString *)getJpushId {
    NSMutableDictionary *getusernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_GETJPUSHID];
    return [getusernamepasswordKVPairs objectForKey:KEY_JPUSHID];
}

// 坐标转换
// 百度坐标转高德坐标
+ (CLLocationCoordinate2D)GCJ02FromBD09:(CLLocationCoordinate2D)coor {
    
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    CLLocationDegrees z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationDegrees gg_lon = z * cos(theta);
    CLLocationDegrees gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}
// 高德坐标转百度坐标
+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor {
    
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}


//手机号码验证
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[12378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//字符串转图片
//+(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
//{
//    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
//    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
//    return _decodedImage;
//}

//图片转字符串
//+(NSString *)UIImageToBase64Str:(UIImage *) image
//{
//    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
//    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    return encodedImageStr;
//}


//上传经纬度时间间隔
+ (void)setUpLocationTimeInterval:(NSString*)timeinterval {
    [[NSUserDefaults standardUserDefaults] setObject:timeinterval forKey:@"locatimeinterval"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getUpLocationTimeInterval {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"locatimeinterval"];
}

//推送消息个数
+ (void)setNewsCount:(NSString *)count {
    
    [[NSUserDefaults standardUserDefaults] setObject:count forKey:@"newsCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getNewsCount {
    
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"newsCount"];
}

//判断是否连接蓝牙设备
+ (BOOL)isConnectBox {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isConnectBox"] == YES) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)setConnectOK {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isConnectBox"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setConnectCancel {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isConnectBox"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
//-(NSString *)getUTCFormateLocalDate:(NSString *)localDate
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //输入格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
//    //输出格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
//    return dateString;
//}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+ (NSString *)getTimeUTCTime:(NSString *)utcTime
{
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *time = [format stringFromDate:[NSDate date]];
    return time;
}


+ (NSString *)getDateUTCDate:(NSString *)utcDate {
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd"];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *time = [format stringFromDate:[NSDate date]];
    return time;
}

//记录水位采集上一次的类型、类别、负责单位
+ (void)setCoverType:(NSString *)ctype ctypID:(NSString *)ctypeId {
    if ([[NSNull null] isEqual:ctype]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ctype"];
    }else{
       [[NSUserDefaults standardUserDefaults] setObject:ctype forKey:@"ctype"];
    }
    
    if ([[NSNull null] isEqual:ctypeId]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ctypeId"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:ctypeId forKey:@"ctypeId"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCoverType {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ctype"];
}
+ (NSString *)getCoverTypeId {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ctypeId"];
}
//
+ (void)setCoverModel:(NSString *)cmodel cmodel:(NSString *)cmodelId{
    if ([[NSNull null] isEqual:cmodel]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cmodel"];
    }else{
         [[NSUserDefaults standardUserDefaults] setObject:cmodel forKey:@"cmodel"];
    }
    
    if ([[NSNull null] isEqual:cmodelId]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cmodelId"];
    }else{
       [[NSUserDefaults standardUserDefaults] setObject:cmodelId forKey:@"cmodelId"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCoverModel {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cmodel"];
}
+ (NSString *)getCoverModelId {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cmodelId"];
}
//
+ (void)setCoverUnit:(NSString *)cunite cunit:(NSString *)cunitId {
    if ([[NSNull null] isEqual:cunite]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cunite"];
    }else{
       [[NSUserDefaults standardUserDefaults] setObject:cunite forKey:@"cunite"];
    }
    if ([[NSNull null] isEqual:cunite]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cunitId"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:cunitId forKey:@"cunitId"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCoverUnit {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cunite"];
}
+ (NSString *)getCoverUnitId {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"cunitId"];
}


//获取 appname  version
+ (NSString *)getVersionString
{
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@ %@", appName, version];
}


+ (NSString*)deviceName
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

+ (NSString *)deleteSpaceNSString:(NSString *)theString {
    theString = [theString  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return theString;
    
}


+ (void)setLeftSortSwitchOn:(NSString *)state{
    if ([[NSNull null] isEqual:state]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"leftSortSwitch"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"leftSortSwitch"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getLeftSortSwitchState {
   

    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"leftSortSwitch"];
}


+ (BOOL)isAllowedNotification {
    
    //iOS8 check if user allow notification
    
    if ([self isSystemVersioniOS8]) {// system is iOS8
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (UIUserNotificationTypeNone != setting.types) {
            
            return YES;
            
        }
        
    } else {//iOS7
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
        if(UIRemoteNotificationTypeNone != type)
            
            return YES;
        
    }
    
    
    return NO;
    
}



+ (BOOL)isSystemVersioniOS8 {
    
    //check systemVerson of device
    
    UIDevice *device = [UIDevice currentDevice];
    
    float sysVersion = [device.systemVersion floatValue];
    
    
    
    if (sysVersion >= 8.0f) {
        
        return YES;
        
    }
    
    return NO;
    
}

//字符串转图片
+ (UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

//图片转字符串
+ (NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//YW密码
+ (void)setYWPsw:(NSString *)psw {
    [[NSUserDefaults standardUserDefaults] setObject:psw forKey:@"YWPsw"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)getYWPsw {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"YWPsw"];
}

//聊天对方id
+ (void)setChatWithPersonId:(NSString *)ywid {
    [[NSUserDefaults standardUserDefaults] setObject:ywid forKey:@"ywtopersonid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getChatWithPersonId {
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ywtopersonid"];
}



+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width
{
    CGSize size       = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect       = [content boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
}

@end
