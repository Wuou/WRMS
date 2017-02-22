//
//  ArrayDataSource.m
//  LeftSlide
//
//  Created by mymac on 16/5/20.
//  Copyright © 2016年 陕西永诺. All rights reserved.
//

#import "YNTableView.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#import "PointModel.h"
#import "ErrorAlertModel.h"
#import "Devicemodel.h"
#import "WaterModel.h"

#import "ErrorAlertCell.h"
#import "WaterCell.h"

@interface YNTableView ()

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewDataSourceBlock dataSourceBlock;
@property (nonatomic, copy) TableViewDelegateBlock delegateBlock;

@end

@implementation YNTableView

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSMutableArray *)items
     cellIdentifier:(NSString *)identifier
    dataSourceBlock:(TableViewDataSourceBlock)dataSource
      delegateBlock:(TableViewDelegateBlock)delegate
{
    self = [super init];
    if (self)
    {
        // 可变数组需要初始化
        self.items = [NSMutableArray arrayWithArray:items];
        self.cellIdentifier = identifier;
        self.dataSourceBlock = [dataSource copy];
        self.delegateBlock = [delegate copy];
    }
    
    return self;
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    // 取到model
    if (self.items.count > 0) {
        id model = [self.items objectAtIndex:indexPath.row];
        self.dataSourceBlock(cell, model, indexPath);
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //请求数据源提交的插入或删除指定行接收者。
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //如果编辑样式为删除样式
        if (indexPath.row < [self.items count]) {
            //调用删除方法
            if (self.editingBlock) {
                self.editingBlock(indexPath);
            }
        }
    }
}


#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self getCellHeightWithType:self.cellIdentifier items:self.items indexPath:indexPath UItableView:self.YNTableView];
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_items.count > 0)
    {
        self.delegateBlock(indexPath);
    }
    // 点击cell后恢复cell的背景颜色
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.YNTableView deselectRowAtIndexPath:[self.YNTableView indexPathForSelectedRow] animated:YES];
    });
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    
    if ([self.cellIdentifier isEqualToString:@"test"]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    
    return result;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // 调用滚动视图的方法
    if (self.scrollBlock) {
        self.scrollBlock(velocity);
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.scrollToTopBlock) {
        self.scrollToTopBlock();
    }
}

#pragma mark - private methods
// 自适应高度
- (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width {
    CGSize size       = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect       = [content boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return rect.size.height;
}

/**
 *  封装获取cell的高度
 *
 *  @param type      cell的重用标识符
 *  @param items     数据源
 *  @param indexPath indexPath
 *
 *  @return 高度
 */
- (CGFloat)getCellHeightWithType:(NSString *)type items:(NSArray *)items indexPath:(NSIndexPath *)indexPath UItableView:(UITableView *)mytb;
{
    if(items.count > 0) {
        if ([type isEqualToString:@"inspectionCell"]) {
            PointModel  *model = [self.items objectAtIndex:indexPath.row];
            return [self.YNTableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[inspectionCell class] contentViewWidth:[self cellContentViewWith]];
        }else if ([type isEqualToString:@"ErrorAlertCell"]){
            ErrorAlertModel *emModel = [self.items objectAtIndex:indexPath.row];
            return [self.YNTableView cellHeightForIndexPath:indexPath model:emModel keyPath:@"emModel" cellClass:[ErrorAlertCell class] contentViewWidth:[self cellContentViewWith]];
        }else if ([type isEqualToString:@"DeviceList"]){
            Devicemodel *emModel = [self.items objectAtIndex:indexPath.row];
            return [self.YNTableView cellHeightForIndexPath:indexPath model:emModel keyPath:@"devicemodel" cellClass:[WaterCell class] contentViewWidth:[self cellContentViewWith]];
        }else if ([type isEqualToString:@"WaterDeviceCorrect"]){
            WaterModel *wmodel = [self.items objectAtIndex:indexPath.row];
            return [self.YNTableView cellHeightForIndexPath:indexPath model:wmodel keyPath:@"model" cellClass:[WaterCell class] contentViewWidth:[self cellContentViewWith]];
        }else{
           return 100;
        }
    }else{
        return 0;
    }
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
