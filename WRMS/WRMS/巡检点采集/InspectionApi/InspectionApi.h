//
//  InspectionApi.h
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/21.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^inspecSucBlock)();
/**
 *  分页数改变
 */
typedef void (^PageChangeBlock)();

/**
 *  上传照片
 *
 *  @return
 */
typedef void (^UploadPicBlock)(NSString *str);

/**
 *  去重复
 */
typedef void (^RepeatBlock)();
// 获取IMEI成功&失败
typedef void (^GetImeiSuccessBlock)(NSDictionary *myDic);
typedef void (^GetImeiFailBlock)();
// 是否显示列表
typedef void (^IsShowUnitListBlock)();
@interface InspectionApi : NSObject
/**
 *  获取列表数据
 *
 *  @param tableView  当前视图的展示列表
 *  @param arrProduct 接收数据的数组
 */
+ (void)apiWithInspecList:(UITableView *)tableView
                  pageNum:(NSInteger)pageNum
               arrProduct:(NSMutableArray *)arrProduct
               pageChange:(PageChangeBlock)pageChange
                repeatArr:(RepeatBlock)repeatBlock;

/**
 *  下载图片
 *
 *  @param arrMedia 图片数组
 *  @param pointID  监测点ID
 *  @param sucBlock 获取成功后的回调
 */
+ (void)apiWtihPicList:(NSMutableArray *)arrMedia
                 pointID:(NSString *)pointID
                sucBlock:(inspecSucBlock)sucBlock;

/**
 *  新增巡检点
 *
 *  @param dictionary        需要传入的参数字典
 *  @param viewController    当前控制器
 */
+ (void)apiAddInspec:(NSDictionary *)dictionary
              arrPic:(NSMutableArray *)arrPic
           uploadPic:(UploadPicBlock)uploadPicBlock
      viewController:(UIViewController *)viewController;

/**
 *  修改巡检点
 *
 *  @param dictionary        需要传入的参数字典
 *  @param viewController    当前控制器
 */
+ (void)apiUpdateInspec:(NSDictionary *)dictionary
                 arrPic:(NSMutableArray *)arrPic
              uploadPic:(UploadPicBlock)uploadPicBlock
      viewController:(UIViewController *)viewController;

/**
 *  获取IMEI
 *
 *  @param tfID    设备编号
 *  @param success 成功回调
 */
+ (void)apiGetWellImeiWithTfID:(NSString *)tfID
                       success:(GetImeiSuccessBlock)success
                          fail:(GetImeiFailBlock)fail;

/**
 *  获取类别数据
 *
 *  @param arrType 类别数组
 */
+ (void)apiGetTypeDataWithArrType:(NSMutableArray *)arrType;

/**
 *  获取单位信息
 *
 *  @param arrUnit    存放单位信息的数据
 *  @param arrID      存放ID的数组
 *  @param arrText    存放text的数组
 *  @param isShowList 回调方法
 */
+ (void)apiGetUnitWithArrUnit:(NSMutableArray *)arrUnit
                            ArrID:(NSMutableArray *)arrID
                          arrText:(NSMutableArray *)arrText
                       isShowList:(IsShowUnitListBlock)isShowList;
    
@end
