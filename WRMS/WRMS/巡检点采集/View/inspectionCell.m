//
//  inspectionCell.m
//  LeftSlide
//
//  Created by YangJingchao on 2016/7/19.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "inspectionCell.h"

@implementation inspectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *roundnessView    = [UIImageView new];
        roundnessView.backgroundColor = [UIColor clearColor];
        _roundnessView                = roundnessView;
        
        UILabel *leftIDLbl        = [UILabel new];
        leftIDLbl.backgroundColor = [UIColor clearColor];
        leftIDLbl.textColor = [UIColor colorWithHexString:numberTitleColor];
        leftIDLbl.text            = @"1";
        [leftIDLbl setFont:[UIFont fontWithName:@"Avenir-light" size:20]];
        leftIDLbl.textAlignment   = NSTextAlignmentCenter;
        _leftIDLbl = leftIDLbl;
        
        UILabel *IDLbl        = [UILabel new];
        IDLbl.backgroundColor = [UIColor clearColor];
        IDLbl.textColor       = [UIColor colorWithHexString:numberTitleColor];
        [IDLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        IDLbl.text = @"巡检点名称：1144532234";
        _IDLbl = IDLbl;
        
        UILabel *terminalIDLbl        = [UILabel new];
        terminalIDLbl.backgroundColor = [UIColor clearColor];
        terminalIDLbl.textColor       = [UIColor colorWithHexString:installColor];
        [terminalIDLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        terminalIDLbl.text = @"巡检名称：森林";
        _terminalIDLbl = terminalIDLbl;
        
        UILabel *terminalStatusLbl        = [UILabel new];
        terminalStatusLbl.backgroundColor = [UIColor clearColor];
        terminalStatusLbl.textColor       = [UIColor colorWithHexString:@"00dfbc"];
        [terminalStatusLbl setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];
        terminalStatusLbl.text = @"";
        terminalStatusLbl.textAlignment = NSTextAlignmentRight;
        _terminalStatusLbl = terminalStatusLbl;
        
        UILabel *idMchn        = [UILabel new];
        idMchn.backgroundColor = [UIColor clearColor];
        idMchn.textColor       = [UIColor colorWithHexString:changeColor];
        [idMchn setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        idMchn.text = @"S00001";
        _labelMchnId = idMchn;
        
        UILabel *addrLbl        = [UILabel new];
        addrLbl.backgroundColor = [UIColor clearColor];
        addrLbl.textColor       = [UIColor lightGrayColor];
        [addrLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
        addrLbl.numberOfLines = 0;
        _addrLbl = addrLbl;
        
        [self.contentView addSubview:_roundnessView];
        [self.contentView addSubview:_IDLbl];
        [self.contentView addSubview:_addrLbl];
        [self.contentView addSubview:_terminalIDLbl];
        [self.contentView addSubview:_leftIDLbl];
        [self.contentView addSubview:_terminalStatusLbl];
        [self.contentView addSubview:_labelMchnId];
        
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
        
        // 采集点名称
        _IDLbl.sd_layout
        .topSpaceToView(self.contentView,0)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        
        // 水位高度
        _terminalIDLbl.sd_layout
        .topSpaceToView(_IDLbl, 0)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        

        
        // 终端id
        _labelMchnId.sd_layout
        .topSpaceToView(_terminalIDLbl,0)
        .leftSpaceToView(_roundnessView,15)
        .rightSpaceToView(self.contentView,5)
        .heightIs(25);
        
        // 时间
        _terminalStatusLbl.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25)
        .widthIs(200);
        
        
        //地址
        _addrLbl.sd_layout
        .leftEqualToView(_IDLbl)
        .topSpaceToView(_labelMchnId, 0)
        .rightSpaceToView(self.contentView, 15)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_addrLbl bottomMargin:0];
    }
    return self;
}

-(void)setText {
    _leftIDLbl.text = @"1";
}

- (void)setPointModel:(PointModel *)pointModel {

    _labelMchnId.text = [NSString stringWithFormat:@"设备编号:%@",pointModel.waterMchnId];
    
    _addrLbl.text = [NSString stringWithFormat:@"%@",pointModel.location];
    _IDLbl.text = [NSString stringWithFormat:@"%@",pointModel.pointName];
    _terminalIDLbl.text = [NSString stringWithFormat:@"水位高度:%.2f米",pointModel.waterHeight];
    
    if(pointModel.createTime.length > 0) {
        NSString *createTime = [NSString stringWithFormat:@"%@",pointModel.createTime];
        NSDate* _date = [NSDate date];
        NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *nowTime = [dateformatter stringFromDate:_date];
        nowTime = [nowTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        nowTime = [nowTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        createTime = [createTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
        createTime = [createTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSInteger chaDate = [nowTime integerValue] - [createTime integerValue];

        NSString *updateTime = [[NSString stringWithFormat:@"%@",pointModel.createTime] stringByReplacingCharactersInRange:NSMakeRange(4,1)withString:@"年"];
        updateTime = [updateTime stringByReplacingCharactersInRange:NSMakeRange(7,1) withString:@"月"];
        updateTime = [updateTime stringByReplacingCharactersInRange:NSMakeRange(10,1) withString:@"日 "];
        updateTime = [updateTime stringByReplacingCharactersInRange:NSMakeRange(14,1) withString:@"点"];
        updateTime = [updateTime stringByReplacingCharactersInRange:NSMakeRange(17,1) withString:@"分"];
        updateTime = [NSString stringWithFormat:@"%@秒",updateTime];
        updateTime = [updateTime substringFromIndex:5];
        NSLog(@"时间%@",updateTime);
        if (chaDate > 0) {
            _terminalStatusLbl.text = [updateTime substringToIndex:6];
        }else{
            _terminalStatusLbl.text = [[updateTime substringFromIndex:7] substringToIndex:6];
        }
        
        
    }
    
    [self setWaterHightColor];
    [self setWaterMchnIdColor];
}

- (void)setWaterHightColor {
    NSMutableAttributedString *IdStr = [[NSMutableAttributedString alloc] initWithString:_terminalIDLbl.text];
    [IdStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];
    [_terminalIDLbl setAttributedText:IdStr];
    
}

- (void)setWaterMchnIdColor {
    NSMutableAttributedString *IdStr = [[NSMutableAttributedString alloc] initWithString:_labelMchnId.text];
    [IdStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];
    [_labelMchnId setAttributedText:IdStr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
