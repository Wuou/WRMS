//
//  CityServiceArgs.h
//  LeftSlide
//
//  Created by YangJingchao on 16/2/23.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求方式(ServiceHttpSoap1与ServiceHttpSoap12的区别在于请求头不一样,ServiceHttpSoap1带soapHeader请求，ServiceHttpSoap12不带soapHeader请求)
typedef enum{
    ServiceHttpGetCity=0,
    ServiceHttpPostCity=1,
    ServiceHttpSoap1City=2,
    ServiceHttpSoap12City=3
}ServiceHttpWayCity;

@interface YNRequestWithCityArgs : NSObject

@property (nonatomic,readonly) NSURLRequest       *request;
@property (nonatomic,readonly) NSURL              *webURL;
@property (nonatomic,readonly) NSString           *defaultSoapMesage;
/** 请求方式,默认为ServiceHttpSoap12请求*/
@property (nonatomic,assign  ) ServiceHttpWayCity httpWay;
/** 请求超时时间,默认60秒*/
@property (nonatomic,assign  ) NSTimeInterval     timeOutSeconds;
/** 默认编辑*/
@property (nonatomic,assign  ) NSStringEncoding   defaultEncoding;
/** webservice访问地址*/
@property (nonatomic,copy    ) NSString           *serviceURL;
/** webservice命名空间*/
@property (nonatomic,copy    ) NSString           *serviceNameSpace;
/** 调用的方法名*/
@property (nonatomic,copy    ) NSString           *methodName;
/** 请求字符串*/
@property (nonatomic,copy    ) NSString           *bodyMessage;
/** 有认证的请求头设置*/
@property (nonatomic,copy    ) NSString           *soapHeader;
/** 请求头*/
@property (nonatomic,retain  ) NSDictionary       *headers;
/** 方法参数设置*/
@property (nonatomic,retain  ) NSArray            *soapParams;

+ (YNRequestWithCityArgs *)serviceMethodName:(NSString *)methodName;
+ (YNRequestWithCityArgs *)serviceMethodName:(NSString *)methodName soapMessage:(NSString *)soapMsg;
+ (void)setNameSapce:(NSString *)space;
+ (void)setWebServiceURL:(NSString *)url;
- (NSURL *)requestURL;

@end
