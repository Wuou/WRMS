//
//  CityServiceArgs.m
//  LeftSlide
//
//  Created by YangJingchao on 16/2/23.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNRequestWithCityArgs.h"
//soap 1.1请求方式
#define defaultSoap1Message @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header>%@</soap:Header><soap:Body>%@</soap:Body></soap:Envelope>"
//soap 1.2请求方式
#define defaultSoap12Message @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Header>%@</soap12:Header><soap12:Body>%@</soap12:Body></soap12:Envelope>"
@interface YNRequestWithCityArgs()
- (NSString *)stringSoapMessage:(NSArray *)params;
- (NSString *)paramsFormatString:(NSArray *)params;
- (NSString *)soapAction:(NSString *)namespace methodName:(NSString *)methodName;
- (NSString *)paramsTostring;

@end

@implementation YNRequestWithCityArgs
+(void)setWebServiceURL:(NSString*)url
{
    if (defaultWebServiceUrl!=url) {
        [defaultWebServiceUrl release];
        defaultWebServiceUrl=[url retain];
    }
}
+(void)setNameSapce:(NSString*)space
{
    if (defaultWebServiceNameSpace!=space) {
        [defaultWebServiceNameSpace release];
        defaultWebServiceNameSpace=[space retain];
    }
}
-(id)init{
    if (self=[super init]) {
        self.httpWay=ServiceHttpSoap12City;
        self.timeOutSeconds=60.0;
        self.defaultEncoding=NSUTF8StringEncoding;
    }
    return self;
}
#pragma mark -
#pragma mark 属性重写
-(NSString*)defaultSoapMesage{
    if (self.httpWay==ServiceHttpSoap1City) {
        return defaultSoap1Message;
    }
    return defaultSoap12Message;
}
-(NSURL*)webURL{
    return [NSURL URLWithString:[self serviceURL]];
}
-(NSString*)serviceURL{
    if (_serviceURL&&[_serviceURL length]>0) {
        return _serviceURL;
    }
    return defaultWebServiceUrl;
}
-(NSString*)serviceNameSpace{
    if (_serviceNameSpace) {
        return _serviceNameSpace;
    }
    return defaultWebServiceNameSpace;
}
-(NSString*)bodyMessage{
    if (self.httpWay==ServiceHttpGetCity){
        return @"";
    }
    if (_bodyMessage&&[_bodyMessage length]>0) {
        return _bodyMessage;
    }
    if (self.httpWay==ServiceHttpPostCity) {
        return [self paramsTostring];
    }
    return [self stringSoapMessage:[self soapParams]];
}
-(NSDictionary*)headers{
    if (_headers&&[_headers count]>0) {
        return _headers;
    }
    if (self.httpWay==ServiceHttpGetCity) {
        return [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.webURL host],@"Host", nil];
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setValue:[[self webURL] host] forKey:@"Host"];
    if (self.httpWay==ServiceHttpPostCity) {
        [dic setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    }
    if (self.httpWay==ServiceHttpSoap1City) {
        [dic setValue:@"text/xml; charset=utf-8" forKey:@"Content-Type"];
    }
    if (self.httpWay==ServiceHttpSoap12City) {
        [dic setValue:@"application/soap+xml; charset=utf-8" forKey:@"Content-Type"];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",(int)[[self bodyMessage] length]] forKey:@"Content-Length"];
    if (self.httpWay==ServiceHttpSoap1City) {
        NSString *soapAction=[self soapAction:[self serviceNameSpace] methodName:[self methodName]];
        if ([soapAction length]>0) {
            [dic setValue:soapAction forKey:@"SOAPAction"];
        }
    }
    return dic;
}
- (NSURLRequest*)request{
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[self requestURL]];
    //头部设置
    [req setAllHTTPHeaderFields:[self headers]];
    //超时设置
    [req setTimeoutInterval:self.timeOutSeconds];
    //访问方式
    [req setHTTPMethod:self.httpWay==ServiceHttpGetCity?@"GET":@"POST"];
    //body内容
    if (self.httpWay!=ServiceHttpGetCity) {
        [req setHTTPBody:[self.bodyMessage dataUsingEncoding:self.defaultEncoding]];
    }
    return req;
}
#pragma mark -
#pragma mark 公有方法
-(NSString*)stringSoapMessage:(NSArray*)params{
    NSString *header=_soapHeader&&[_soapHeader length]>0?_soapHeader:@"";
    NSString *xmlnsStr=[[self serviceNameSpace] length]>0?[NSString stringWithFormat:@" xmlns=\"%@\"",[self serviceNameSpace]]:@"";
    
    if (params) {
        NSMutableString *soap=[NSMutableString stringWithFormat:@"<%@%@>",[self methodName],xmlnsStr];
        
        [soap appendString:[self paramsFormatString:params]];
        [soap appendFormat:@"</%@>",[self methodName]];
        return [NSString stringWithFormat:[self defaultSoapMesage],header,soap];
    }
    NSString *body=[NSString stringWithFormat:@"<%@%@ />",[self methodName],xmlnsStr];
    return [NSString stringWithFormat:[self defaultSoapMesage],header,body];
}
+ (YNRequestWithCityArgs *)serviceMethodName:(NSString *)methodName{
    return [self serviceMethodName:methodName soapMessage:nil];
}
+ (YNRequestWithCityArgs *)serviceMethodName:(NSString *)name soapMessage:(NSString *)msg{
    YNRequestWithCityArgs *args=[[[YNRequestWithCityArgs alloc] init] autorelease];
    args.methodName=name;
    if (msg&&[msg length]>0) {
        args.bodyMessage=msg;
    }else{
        args.bodyMessage=[args stringSoapMessage:nil];
    }
    return args;
}
#pragma mark -
#pragma mark 私有方法
- (NSURL *)requestURL{
    if (self.httpWay==ServiceHttpSoap1City||self.httpWay==ServiceHttpSoap12City) {
        return [self webURL];
    }
    if (self.httpWay==ServiceHttpGetCity) {
        NSString *params=[self paramsTostring];
        NSString *str=[params length]>0?[NSString stringWithFormat:@"?%@",params]:@"";
        NSString *result=[NSString stringWithFormat:@"%@/%@%@",[self serviceURL],[self methodName],str];
        return [NSURL URLWithString:result];
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[self serviceURL],[self methodName]]];
}
- (NSString *)paramsTostring
{
    NSArray *arr=[self soapParams];
    if (arr&&[arr count]>0) {
        NSMutableArray *results=[NSMutableArray array];
        for (NSDictionary *item in arr) {
            NSString *key=[[item allKeys] objectAtIndex:0];
            [results addObject:[NSString stringWithFormat:@"%@=%@",key,[item objectForKey:key]]];
        }
        return [results componentsJoinedByString:@"&"];
    }
    return @"";
}
- (NSString *)paramsFormatString:(NSArray *)params{
    NSMutableString *xml=[NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in params) {
        NSString *key=[[item allKeys] objectAtIndex:0];
        [xml appendFormat:@"<%@>",key];
        [xml appendString:[item objectForKey:key]];
        [xml appendFormat:@"</%@>",key];
    }
    return xml;
}
- (NSString *)soapAction:(NSString *)namespace methodName:(NSString *)methodName{
    if (namespace&&[namespace length]>0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/$" options:0 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
        //NSArray *array=[regex matchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
        if(numberOfMatches>0){
            return [NSString stringWithFormat:@"%@%@",namespace,methodName];
        }
        return [NSString stringWithFormat:@"%@/%@",namespace,methodName];
    }
    return @"";
}
@end
