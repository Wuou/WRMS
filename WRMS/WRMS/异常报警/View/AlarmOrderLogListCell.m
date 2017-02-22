//
//  AlarmOrderLogListCell.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/27.
//  Copyright © 2016年 YongNuoTech. All rights reserved.
//

#import "AlarmOrderLogListCell.h"
#import "AlarmOrderLogListModel.h"
#import "ErrorAlertModel.h"

@implementation AlarmOrderLogListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *logIdLbl = [[UILabel alloc]init];
        logIdLbl.backgroundColor = [UIColor clearColor];
        logIdLbl.textColor       = [UIColor colorWithHexString:numberTitleColor];
        [logIdLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _logIdLbl         = logIdLbl;
        
        UILabel *alarmTypeNameLbl = [[UILabel alloc]init];
        alarmTypeNameLbl.backgroundColor = [UIColor clearColor];
        alarmTypeNameLbl.textColor = [UIColor darkGrayColor];
        [alarmTypeNameLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _alarmTypeNameLbl   =alarmTypeNameLbl;
        
        UILabel *issuedUnitUserLbl = [[UILabel alloc]init];
        issuedUnitUserLbl.backgroundColor = [UIColor clearColor];
        issuedUnitUserLbl.textColor = [UIColor darkGrayColor];
        [issuedUnitUserLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _issuedUnitUserLbl   =issuedUnitUserLbl;
        
        UILabel *suatusNameLbl = [[UILabel alloc]init];
        suatusNameLbl.backgroundColor = [UIColor clearColor];
        suatusNameLbl.textColor = [UIColor darkGrayColor];
        [suatusNameLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _createTimeLbl   =suatusNameLbl;
        
        [self.contentView addSubview:_logIdLbl];
        [self.contentView addSubview:_alarmTypeNameLbl];
        [self.contentView addSubview:_issuedUnitUserLbl];
        [self.contentView addSubview:_createTimeLbl];
        
        _logIdLbl.sd_layout
        .leftSpaceToView(self.contentView,5)
        .topSpaceToView(self.contentView,8)
        .rightSpaceToView(self.contentView,5)
        .heightIs(25);
        
        _alarmTypeNameLbl.sd_layout
        .leftSpaceToView(self.contentView,5)
        .topSpaceToView(_logIdLbl,5)
        .rightSpaceToView(self.contentView,5)
        .heightIs(25);
        
        _issuedUnitUserLbl.sd_layout
        .leftSpaceToView(self.contentView,5)
        .topSpaceToView(_alarmTypeNameLbl,5)
        .rightSpaceToView(self.contentView,5)
        .autoHeightRatio(0);
        
        _createTimeLbl.sd_layout
        .leftSpaceToView(self.contentView,5)
        .topSpaceToView(_issuedUnitUserLbl,5)
        .rightSpaceToView(self.contentView,5)
        .heightIs(25);
        
//        _cellLineLbl.sd_layout
//        .leftSpaceToView(self.contentView,6)
//        .rightSpaceToView(self.contentView,6)
//        .bottomSpaceToView(self.contentView,-2)
//        .heightIs(1);
        
         [self setupAutoHeightWithBottomView:_createTimeLbl bottomMargin:0];
    }
    return self;
}

- (void)setOrderListModel:(AlarmOrderLogListModel *)orderListModel {
    self.logIdLbl.text = [NSString stringWithFormat:@"记录编号:%@",orderListModel.logId];
    self.alarmTypeNameLbl.text = [NSString stringWithFormat:@"报警类别:%@",orderListModel.alarmTypeName];
    self.issuedUnitUserLbl.text = [NSString stringWithFormat:@"分发单位:%@",orderListModel.issuedUnitUser];
    self.createTimeLbl.text = [NSString stringWithFormat:@"创建时间:%@",orderListModel.createTime];
    
}

- (void)setEmModel:(ErrorAlertModel *)emModel {
    
    self.logIdLbl.text = [NSString stringWithFormat:@"记录编号:%@",emModel.orderId];
    self.alarmTypeNameLbl.text = [NSString stringWithFormat:@"报警类别:%@",emModel.alarmTypeName];
//    self.issuedUnitUserLbl.text = [NSString stringWithFormat:@"分发单位:%@",emModel.unitName];
    self.createTimeLbl.text = [NSString stringWithFormat:@"创建时间:%@",emModel.createTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
