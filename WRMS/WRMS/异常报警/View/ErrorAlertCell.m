//
//  EventManagementCell.m
//  LeftSlide
//
//  Created by zhujintao on 16/7/20.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "ErrorAlertCell.h"
#import "ErrorAlertModel.h"
@implementation ErrorAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *roundnessView    = [UIImageView new];
        roundnessView.backgroundColor = [UIColor clearColor];
        _roundnessView                = roundnessView;
        
        UILabel *leftIDLbl        = [UILabel new];
        leftIDLbl.backgroundColor = [UIColor clearColor];
        leftIDLbl.textColor = [UIColor colorWithHexString:numberTitleColor];
        [leftIDLbl setFont:[UIFont fontWithName:@"Avenir-Light" size:20]];
        leftIDLbl.textAlignment   = NSTextAlignmentCenter;
        _leftIDLbl                = leftIDLbl;
        
        UILabel *IDLbl        = [UILabel new];
        IDLbl.backgroundColor = [UIColor clearColor];
        IDLbl.textColor       = [UIColor colorWithHexString:numberTitleColor];
        [IDLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _IDLbl                = IDLbl;
        
        UILabel *eventTypeLbl        = [UILabel new];
        eventTypeLbl.backgroundColor = [UIColor clearColor];
        eventTypeLbl.textColor       = [UIColor colorWithHexString:installColor];
        [eventTypeLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _eventTypeLbl        = eventTypeLbl;
        
        UILabel *levelLbl        = [UILabel new];
        levelLbl.backgroundColor = [UIColor clearColor];
        levelLbl.textColor       = [UIColor colorWithHexString:midGrayColor];
        [levelLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _levelLbl                = levelLbl;
        
        UILabel *addrLbl        = [UILabel new];
        addrLbl.backgroundColor = [UIColor clearColor];
        addrLbl.textColor       = [UIColor lightGrayColor];
        [addrLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
        addrLbl.numberOfLines = 0;
        _addrLbl                = addrLbl;
        
        UILabel *statusTitleLbl        = [UILabel new];
        statusTitleLbl.backgroundColor = [UIColor clearColor];
        statusTitleLbl.textColor       = [UIColor colorWithHexString:midGrayColor];
        [statusTitleLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        statusTitleLbl.text = @"处理状态:";
        _labelStatusTitle                = statusTitleLbl;
        
        UILabel *statusLbl        = [UILabel new];
        statusLbl.backgroundColor = [UIColor clearColor];
        statusLbl.textColor       = [UIColor colorWithHexString:changeColor];
        [statusLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
        statusLbl.numberOfLines = 0;
        _labelStatus                = statusLbl;
        
        
        UIButton *locBtn        = [UIButton new];
//        locBtn.backgroundColor  = [UIColor colorWithHexString:addressColor];
//        [locBtn setTitle:@"位置" forState:UIControlStateNormal];
        [locBtn.layer setCornerRadius:8];
        [locBtn setImage:[UIImage imageNamed:@"cellLoca"] forState:UIControlStateNormal];
        [locBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [locBtn addTarget:self action:@selector(toShowEventLocAction:) forControlEvents:UIControlEventTouchUpInside];
        _locBtn                  = locBtn;
        
        [self.contentView addSubview:_roundnessView];
        [self.contentView addSubview:_IDLbl];
        [self.contentView addSubview:_addrLbl];
        [self.contentView addSubview:_eventTypeLbl];
        [self.contentView addSubview:_leftIDLbl];
        [self.contentView addSubview:_levelLbl];
        [self.contentView addSubview:_locBtn];
        [self.contentView addSubview:_alarmTypeNameLbl];
        [self.contentView addSubview:_labelStatusTitle];
        [self.contentView addSubview:_labelStatus];
        
        
        _roundnessView.sd_layout
        .widthIs(35)
        .heightIs(35)
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 15);
        
        _leftIDLbl.sd_layout
        .widthIs(25)
        .heightIs(25)
        .topSpaceToView(self.contentView,3)
        .centerXEqualToView(_roundnessView);
        
        _IDLbl.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        
        // 报警类型
        _eventTypeLbl.sd_layout
        .topSpaceToView(_IDLbl, 0)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        
        // 报警等级
        _levelLbl.sd_layout
        .topSpaceToView(_eventTypeLbl, 0)
        .rightSpaceToView(self.contentView, 5)
        .leftSpaceToView(_roundnessView, 15)
        .heightIs(25);
        
        _labelStatusTitle.sd_layout
        .topSpaceToView(_levelLbl,0)
        .leftSpaceToView(_roundnessView,15)
        .widthIs(65)
        .heightIs(25);
        
        _labelStatus.sd_layout
        .topSpaceToView(_levelLbl,0)
        .leftSpaceToView(_labelStatusTitle,5)
        .heightIs(25)
        .rightSpaceToView(self.contentView,5);
        
        //地址
        _addrLbl.sd_layout
        .leftEqualToView(_IDLbl)
        .topSpaceToView(_labelStatusTitle, 0)
        .rightSpaceToView(self.contentView, 5)
        .autoHeightRatio(0);
        
        //右侧位置按钮
        _locBtn.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView,10)
        .heightIs(40)
        .widthIs(40);
        
        [self setupAutoHeightWithBottomView:_addrLbl bottomMargin:0];
    }
    return self;
}

#pragma mark - event responses
- (void)toShowEventLocAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(touchlocBtnAction:)]) {
        [_delegate touchlocBtnAction:sender];
    }
}

- (void)setEmModel:(ErrorAlertModel *)emModel {
    self.IDLbl.text            =  [NSString stringWithFormat:@"报警编号：%@",emModel.orderId];
    self.eventTypeLbl.text     =  [NSString stringWithFormat:@"报警类型：%@",emModel.alarmTypeName];
    self.labelStatus.text = emModel.statusName;
    self.levelLbl.text = [NSString stringWithFormat:@"报警等级：%@",emModel.alarmLevelName];
    self.addrLbl .text         =  [NSString stringWithFormat:@"%@",emModel.location];
    
    [self setErrorTypeColor];
}

- (void)setErrorTypeColor {
    NSMutableAttributedString *IdStr = [[NSMutableAttributedString alloc] initWithString:self.eventTypeLbl.text];
    [IdStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];
    [self.eventTypeLbl setAttributedText:IdStr];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
