//
//  ServiceArgs.h
//  CommonLibrary
//
//  Created by YangJingchao on 13/2/20.
//  Copyright (c) 2013年 rang. All rights reserved.
//



#import <Foundation/Foundation.h>
//请求方式(ServiceHttpSoap1与ServiceHttpSoap12的区别在于请求头不一样,ServiceHttpSoap1带soapHeader请求，ServiceHttpSoap12不带soapHeader请求)
typedef enum{
    ServiceHttpGet=0,
    ServiceHttpPost=1,
    ServiceHttpSoap1=2,
    ServiceHttpSoap12=3
}ServiceHttpWay;

@interface YNRequestWithArgs : NSObject

@property (nonatomic,readonly) NSURLRequest     *request;
@property (nonatomic,readonly) NSURL            *webURL;
@property (nonatomic,readonly) NSString         *defaultSoapMesage;
/** 请求方式,默认为ServiceHttpSoap12请求*/
@property (nonatomic,assign  ) ServiceHttpWay   httpWay;
/** 请求超时时间,默认60秒*/
@property (nonatomic,assign  ) NSTimeInterval   timeOutSeconds;
/** 默认编辑*/
@property (nonatomic,assign  ) NSStringEncoding defaultEncoding;
/** webservice访问地址*/
@property (nonatomic,copy    ) NSString         *serviceURL;
/** webservice命名空间*/
@property (nonatomic,copy    ) NSString         *serviceNameSpace;
/** 调用的方法名*/
@property (nonatomic,copy    ) NSString         *methodName;
/** 请求字符串*/
@property (nonatomic,copy    ) NSString         *bodyMessage;
/** 有认证的请求头设置*/
@property (nonatomic,copy    ) NSString         *soapHeader;
/** 请求头*/
@property (nonatomic,retain  ) NSDictionary     *headers;
/** 方法参数设置*/
@property (nonatomic,retain  ) NSArray          *soapParams;

+ (YNRequestWithArgs *)serviceMethodName:(NSString*)methodName;
+ (YNRequestWithArgs *)serviceMethodName:(NSString*)methodName soapMessage:(NSString*)soapMsg;
+ (void)setNameSapce:(NSString*)space;
+ (void)setWebServiceURL:(NSString*)url;
- (NSURL*)requestURL;
@end
