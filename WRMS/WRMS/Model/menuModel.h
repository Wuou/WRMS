//
//  menuModel.h
//  LeftSlide
//
//  Created by YangJingchao on 16/5/11.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuModel : NSObject

@property (nonatomic, assign) BOOL checkedCreateFlag;
@property (nonatomic, assign) BOOL checkedDeleteFlag;
@property (nonatomic, assign) BOOL checkedExportFlag;
@property (nonatomic, assign) BOOL checkedImportsFlag;
@property (nonatomic, assign) BOOL checkedIssuedFlag;
@property (nonatomic, assign) BOOL checkedNavFlag;
@property (nonatomic, assign) BOOL checkedPrintFlag;
@property (nonatomic, assign) BOOL checkedQueryFlag;
@property (nonatomic, assign) BOOL checkedUpdateFlag;
@property (nonatomic, assign) BOOL checkedViewFlag;
@property (nonatomic, strong) NSArray * children;
@property (nonatomic, strong) NSString * createFuncId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * createUserAccnt;
@property (nonatomic, strong) NSString * deleteFuncId;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSString * exportFuncId;
@property (nonatomic, strong) NSString * funcId;
@property (nonatomic, strong) NSString * iconCLS;
@property (nonatomic, strong) NSString * importFuncId;
@property (nonatomic, strong) NSString * isEnableName;
@property (nonatomic, strong) NSString * isLeaf;
@property (nonatomic, strong) NSString * isLeafName;
@property (nonatomic, strong) NSString * issuedFuncId;
@property (nonatomic, strong) NSString * navFuncId;
@property (nonatomic, strong) NSString * navNodeName;
@property (nonatomic, strong) NSString * nodeId;
@property (nonatomic, strong) NSString * nodeNumber;
@property (nonatomic, strong) NSString * nodeOrder;
@property (nonatomic, strong) NSString * nodeURL;
@property (nonatomic, strong) NSString * parentId;
@property (nonatomic, strong) NSString * parentName;
@property (nonatomic, strong) NSString * printFuncId;
@property (nonatomic, strong) NSString * queryFuncId;
@property (nonatomic, assign) BOOL showCreateFlag;
@property (nonatomic, assign) BOOL showDeleteFlag;
@property (nonatomic, assign) BOOL showExportFlag;
@property (nonatomic, assign) BOOL showImportsFlag;
@property (nonatomic, assign) BOOL showIssuedFlag;
@property (nonatomic, assign) BOOL showPrintFlag;
@property (nonatomic, assign) BOOL showQueryFlag;
@property (nonatomic, assign) BOOL showUpdateFlag;
@property (nonatomic, assign) BOOL showViewFlag;
@property (nonatomic, strong) NSString * updateFuncId;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUserAccnt;
@property (nonatomic, strong) NSString * viewFuncId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
