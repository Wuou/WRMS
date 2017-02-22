//
//  menuModel.m
//  LeftSlide
//
//  Created by YangJingchao on 16/5/11.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "menuModel.h"
@interface menuModel ()
@end

@implementation menuModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"checkedCreateFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedCreateFlag = [dictionary[@"checkedCreateFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedDeleteFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedDeleteFlag = [dictionary[@"checkedDeleteFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedExportFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedExportFlag = [dictionary[@"checkedExportFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedImportsFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedImportsFlag = [dictionary[@"checkedImportsFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedIssuedFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedIssuedFlag = [dictionary[@"checkedIssuedFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedNavFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedNavFlag = [dictionary[@"checkedNavFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedPrintFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedPrintFlag = [dictionary[@"checkedPrintFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedQueryFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedQueryFlag = [dictionary[@"checkedQueryFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedUpdateFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedUpdateFlag = [dictionary[@"checkedUpdateFlag"] boolValue];
    }
    
    if(![dictionary[@"checkedViewFlag"] isKindOfClass:[NSNull class]])
    {
        self.checkedViewFlag = [dictionary[@"checkedViewFlag"] boolValue];
    }
    
    if(![dictionary[@"children"] isKindOfClass:[NSNull class]])
    {
        self.children = dictionary[@"children"];
    }
    
    if(![dictionary[@"createFuncId"] isKindOfClass:[NSNull class]])
    {
        self.createFuncId = dictionary[@"createFuncId"];
    }
    
    if(![dictionary[@"createTime"] isKindOfClass:[NSNull class]])
    {
        self.createTime = dictionary[@"createTime"];
    }
    
    if(![dictionary[@"createUserAccnt"] isKindOfClass:[NSNull class]])
    {
        self.createUserAccnt = dictionary[@"createUserAccnt"];
    }
    
    if(![dictionary[@"deleteFuncId"] isKindOfClass:[NSNull class]])
    {
        self.deleteFuncId = dictionary[@"deleteFuncId"];
    }
    
    if(![dictionary[@"enable"] isKindOfClass:[NSNull class]])
    {
        self.enable = [dictionary[@"enable"] boolValue];
    }
    
    if(![dictionary[@"exportFuncId"] isKindOfClass:[NSNull class]])
    {
        self.exportFuncId = dictionary[@"exportFuncId"];
    }
    
    if(![dictionary[@"funcId"] isKindOfClass:[NSNull class]])
    {
        self.funcId = dictionary[@"funcId"];
    }
    
    if(![dictionary[@"iconCLS"] isKindOfClass:[NSNull class]])
    {
        self.iconCLS = dictionary[@"iconCLS"];
    }
    
    if(![dictionary[@"importFuncId"] isKindOfClass:[NSNull class]])
    {
        self.importFuncId = dictionary[@"importFuncId"];
    }
    
    if(![dictionary[@"isEnableName"] isKindOfClass:[NSNull class]])
    {
        self.isEnableName = dictionary[@"isEnableName"];
    }
    
    if(![dictionary[@"isLeaf"] isKindOfClass:[NSNull class]])
    {
        self.isLeaf = dictionary[@"isLeaf"];
    }
    
    if(![dictionary[@"isLeafName"] isKindOfClass:[NSNull class]])
    {
        self.isLeafName = dictionary[@"isLeafName"];
    }
    
    if(![dictionary[@"issuedFuncId"] isKindOfClass:[NSNull class]])
    {
        self.issuedFuncId = dictionary[@"issuedFuncId"];
    }
    
    if(![dictionary[@"navFuncId"] isKindOfClass:[NSNull class]])
    {
        self.navFuncId = dictionary[@"navFuncId"];
    }
    
    if(![dictionary[@"navNodeName"] isKindOfClass:[NSNull class]])
    {
        self.navNodeName = dictionary[@"navNodeName"];
    }
    
    if(![dictionary[@"nodeId"] isKindOfClass:[NSNull class]])
    {
        self.nodeId = dictionary[@"nodeId"];
    }
    
    if(![dictionary[@"nodeNumber"] isKindOfClass:[NSNull class]])
    {
        self.nodeNumber = dictionary[@"nodeNumber"];
    }
    
    if(![dictionary[@"nodeOrder"] isKindOfClass:[NSNull class]])
    {
        self.nodeOrder = dictionary[@"nodeOrder"];
    }
    
    if(![dictionary[@"nodeURL"] isKindOfClass:[NSNull class]])
    {
        self.nodeURL = dictionary[@"nodeURL"];
    }
    
    if(![dictionary[@"parentId"] isKindOfClass:[NSNull class]])
    {
        self.parentId = dictionary[@"parentId"];
    }
    
    if(![dictionary[@"parentName"] isKindOfClass:[NSNull class]])
    {
        self.parentName = dictionary[@"parentName"];
    }
    
    if(![dictionary[@"printFuncId"] isKindOfClass:[NSNull class]])
    {
        self.printFuncId = dictionary[@"printFuncId"];
    }
    
    if(![dictionary[@"queryFuncId"] isKindOfClass:[NSNull class]])
    {
        self.queryFuncId = dictionary[@"queryFuncId"];
    }
    
    if(![dictionary[@"showCreateFlag"] isKindOfClass:[NSNull class]])
    {
        self.showCreateFlag = [dictionary[@"showCreateFlag"] boolValue];
    }
    
    if(![dictionary[@"showDeleteFlag"] isKindOfClass:[NSNull class]])
    {
        self.showDeleteFlag = [dictionary[@"showDeleteFlag"] boolValue];
    }
    
    if(![dictionary[@"showExportFlag"] isKindOfClass:[NSNull class]])
    {
        self.showExportFlag = [dictionary[@"showExportFlag"] boolValue];
    }
    
    if(![dictionary[@"showImportsFlag"] isKindOfClass:[NSNull class]])
    {
        self.showImportsFlag = [dictionary[@"showImportsFlag"] boolValue];
    }
    
    if(![dictionary[@"showIssuedFlag"] isKindOfClass:[NSNull class]])
    {
        self.showIssuedFlag = [dictionary[@"showIssuedFlag"] boolValue];
    }
    
    if(![dictionary[@"showPrintFlag"] isKindOfClass:[NSNull class]])
    {
        self.showPrintFlag = [dictionary[@"showPrintFlag"] boolValue];
    }
    
    if(![dictionary[@"showQueryFlag"] isKindOfClass:[NSNull class]])
    {
        self.showQueryFlag = [dictionary[@"showQueryFlag"] boolValue];
    }
    
    if(![dictionary[@"showUpdateFlag"] isKindOfClass:[NSNull class]])
    {
        self.showUpdateFlag = [dictionary[@"showUpdateFlag"] boolValue];
    }
    
    if(![dictionary[@"showViewFlag"] isKindOfClass:[NSNull class]])
    {
        self.showViewFlag = [dictionary[@"showViewFlag"] boolValue];
    }
    
    if(![dictionary[@"updateFuncId"] isKindOfClass:[NSNull class]])
    {
        self.updateFuncId = dictionary[@"updateFuncId"];
    }	
    if(![dictionary[@"updateTime"] isKindOfClass:[NSNull class]]){
        self.updateTime = dictionary[@"updateTime"];
    }
    
    if(![dictionary[@"updateUserAccnt"] isKindOfClass:[NSNull class]])
    {
        self.updateUserAccnt = dictionary[@"updateUserAccnt"];
    }
    
    if(![dictionary[@"viewFuncId"] isKindOfClass:[NSNull class]])
    {
        self.viewFuncId = dictionary[@"viewFuncId"];
    }
    
    return self;
}

@end
