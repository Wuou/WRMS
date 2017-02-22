//
//  WellCell.m
//  公共cell
//
//  Created by yangjingchao on 15/10/14.
//  Copyright (c) 2015年 yongnuo. All rights reserved.
//



#import "WaterCell.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIColor-Expanded.h"

@implementation WaterCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView *roundnessView    = [UIImageView new];
        roundnessView.backgroundColor = [UIColor clearColor];
        _roundnessView                = roundnessView;
        
        UILabel *leftIDLbl        = [UILabel new];
        leftIDLbl.backgroundColor = [UIColor clearColor];
        leftIDLbl.textColor = [UIColor colorWithHexString:numberTitleColor];
        leftIDLbl.text            = @"1";
        [leftIDLbl setFont:[UIFont fontWithName:@"Avenir-Light" size:20]];
        leftIDLbl.textAlignment   = NSTextAlignmentCenter;
        _leftIDLbl                = leftIDLbl;
        
        UILabel *IDLbl        = [UILabel new];
        IDLbl.backgroundColor = [UIColor clearColor];
        IDLbl.textColor       = [UIColor colorWithHexString:numberTitleColor];
        IDLbl.text            = @"编号:";
        [IDLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _IDLbl                = IDLbl;
        
        // 右上角标签
//        UIImageView *tagimageView = [UIImageView new];
//        tagimageView.image = [UIImage imageNamed:@"wellStateClose"];
//        tagimageView.backgroundColor = [UIColor clearColor];
//        _tagimageView = tagimageView;
        
        // 标签内部的状态
//        UILabel *n2DeviceStateLbl = [UILabel new];
//        n2DeviceStateLbl.textColor = [UIColor whiteColor];
//        n2DeviceStateLbl.textAlignment = NSTextAlignmentCenter;
//        [n2DeviceStateLbl setFont:[UIFont systemFontOfSize:9]];
//        _n2DeviceStateLbl = n2DeviceStateLbl;
        
        UILabel *terminalIDLbl        = [UILabel new];
        terminalIDLbl.backgroundColor = [UIColor clearColor];
        terminalIDLbl.textColor       = [UIColor colorWithHexString:changeColor];
        terminalIDLbl.text            = @"终端编号:";
        [terminalIDLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _terminalIDLbl        = terminalIDLbl;
        
        UILabel *terminalType        = [UILabel new];
        terminalType.backgroundColor = [UIColor clearColor];
        terminalType.textColor       = [UIColor darkGrayColor];
        [terminalType setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _terminalType                = terminalType;
        
        UILabel *terminalStatusLbl        = [UILabel new];
        terminalStatusLbl.backgroundColor = [UIColor clearColor];
        terminalStatusLbl.textColor       = [UIColor darkGrayColor];
        [terminalStatusLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        _terminalStatusLbl                = terminalStatusLbl;
        
        UILabel *addrLbl        = [UILabel new];
        addrLbl.backgroundColor = [UIColor clearColor];
        addrLbl.textColor       = [UIColor lightGrayColor];
        [addrLbl setFont:[UIFont fontWithName:@"Avenir-Medium" size:13]];
        addrLbl.numberOfLines = 0;
        _addrLbl                = addrLbl;
        
        
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_rightBtn.layer setCornerRadius:8];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        
        [self.contentView addSubview:_roundnessView];
        [self.contentView addSubview:_IDLbl];
//        [self.contentView addSubview:_tagimageView];
//        [self.contentView addSubview:_n2DeviceStateLbl];
        [self.contentView addSubview:_addrLbl];
        [self.contentView addSubview:_terminalIDLbl];
        [self.contentView addSubview:_leftIDLbl];
        [self.contentView addSubview:_terminalStatusLbl];
        [self.contentView addSubview:_rightBtn];
        
        _roundnessView.sd_layout
        .widthIs(35)
        .heightIs(35)
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 15);
        
        _leftIDLbl.sd_layout
        .widthIs(25)
        .heightIs(25)
        .topSpaceToView(self.contentView,5)
        .centerXEqualToView(_roundnessView);
        
        _IDLbl.sd_layout
        .topSpaceToView(self.contentView,5)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        
        // 标签
//        _tagimageView.sd_layout
//        .topSpaceToView(self.contentView,-1)
//        .rightSpaceToView(self.contentView, 10)
//        .widthIs(30)
//        .heightIs(30);
        
        // 水位状态
//        _n2DeviceStateLbl.sd_layout
//        .centerYEqualToView(_tagimageView)
//        .centerXEqualToView(_tagimageView)
//        .widthIs(30)
//        .heightIs(18);
        
        // 设备编号
        _terminalIDLbl.sd_layout
        .topSpaceToView(self.contentView, 35)
        .leftSpaceToView(_roundnessView, 15)
        .rightSpaceToView(self.contentView, 5)
        .heightIs(25);
        
        // 设备状态
        _terminalStatusLbl.sd_layout
        .topSpaceToView(_terminalIDLbl, 0)
        .rightSpaceToView(self.contentView, 5)
        .leftSpaceToView(_roundnessView, 15)
        .heightIs(25);
        
        //右侧按钮
        _rightBtn.sd_layout.widthIs(70)
        .heightIs(30)
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 5*2);
        
        //地址
        _addrLbl.sd_layout
        .leftEqualToView(_IDLbl)
        .topSpaceToView(_terminalStatusLbl, 2)
        .rightSpaceToView(self.contentView, 5)
        .autoHeightRatio(0);
        
    }
    [self setupAutoHeightWithBottomView:_addrLbl bottomMargin:5];
    return self;
}

// 设置cell左侧的序号
- (void)setText:(NSString *)text
{
    _text       = text;
    _leftIDLbl.text = text;
}

// 设置cell的类型，判断cell是属于哪一个模块
-(void)setType:(NSString *)type
{
    _typStr = type;
}

// 设置水位采集，撤防布防，水位纠错cell的样式及赋值
-(void)setModel:(WaterModel *)model
{
    // 设置设备编号和设备状态的字体颜色
    [self setAttributeOfDeviceFont:model];
    
    // 地址信息
    _addrLbl.text = [NSString stringWithFormat:@"%@",model.locationstr];
    
    // 右上角状态显示图标
//    if ([model.statusNamestr isEqualToString:@"开启"])
//    {
//        _tagimageView.image = [UIImage imageNamed:@"wellStateOpen"];
//    }else{
//        _tagimageView.image = [UIImage imageNamed:@"wellStateClose"];
//    }

    // 设置辅助编号
    if (model.coversIdCustom.length > 0)
    {
        _IDLbl.text = [NSString stringWithFormat:@"%@-%@",model.pointId,model.coversIdCustom];
    }else
    {
        _IDLbl.text = [NSString stringWithFormat:@"%@",model.pointId];
    }
    
    // 水位状态
//    _n2DeviceStateLbl.text = [NSString stringWithFormat:@"%@",model.statusNamestr];
    
    [_rightBtn removeTarget:self action:@selector(toUploadWellError:) forControlEvents:UIControlEventTouchUpInside];
    
    // 按钮样式

    [_rightBtn setTitle:@"纠错" forState:UIControlStateNormal];
    [_rightBtn setBackgroundColor:[UIColor colorWithHexString:correctColor]];
    [_rightBtn addTarget:self action:@selector(toUploadWellError:) forControlEvents:UIControlEventTouchUpInside];
}

// 设置设备安装cell的样式并赋值
-(void)setDevicemodel:(Devicemodel *)devicemodel
{
    self.typStr = @"设备安装";
    // 设置字体属性的颜色
    [self setAttributeOfDeviceFont:devicemodel];
    
    _addrLbl.text = [NSString stringWithFormat:@"%@",devicemodel.strlocation];
    
    if (devicemodel.coversIdCustom.length > 0)
    {
        _IDLbl.text = [NSString stringWithFormat:@"%@-%@",devicemodel.pointId,devicemodel.coversIdCustom];
    }else
    {
        _IDLbl.text = [NSString stringWithFormat:@"%@",devicemodel.pointId];
    }
    
//    _n2DeviceStateLbl.text = [NSString stringWithFormat:@"%@",devicemodel.waterMchnStateName];
    
//    if ([devicemodel.strstatusName isEqualToString:@"开启"])
//    {
//        _tagimageView.image = [UIImage imageNamed:@"wellStateOpen"];
//    }else{
//        _tagimageView.image = [UIImage imageNamed:@"wellStateClose"];
//    }
    
    [_rightBtn removeTarget:self action:@selector(installAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn removeTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 根据条件显示button的文字和背景颜色
    if ([devicemodel.strcodeImei isEqualToString:@""])
    {
        [_rightBtn setTitle:@"安装" forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor colorWithHexString:installColor]];
        [_rightBtn addTarget:self action:@selector(installAction:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [_rightBtn setTitle:@"更换" forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor colorWithHexString:changeColor]];
        [_rightBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Event response
//安装按钮点击
-(void)installAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(touchDeviceInstall:)])
    {
        [_delegate touchDeviceInstall:sender];
    }
}

//更换按钮点击
-(void)changeAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(touchDeviceChange:)])
    {
        [_delegate touchDeviceChange:sender];
    }
}

//位置纠错
-(void)toUploadWellError:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(touchWellError:)])
    {
        [_delegate touchWellError:sender];
    }
}

#pragma mark - Private methods


/**
 *  设置cell上的标题字体颜色
 *
 *  @param model 传入的model
 */
- (void)setAttributeOfDeviceFont:(id)model
{
    if ([_typStr isEqualToString:@"设备安装"])
    {
        Devicemodel *deviceModel = (Devicemodel *)model;
        
        // 设备状态
        _terminalStatusLbl.text = [NSString stringWithFormat:@"设备状态:%@",deviceModel.waterMchnStateName];
        // 设备编号
        _terminalIDLbl.text     = [NSString stringWithFormat:@"设备编号:%@",deviceModel.waterMchnId];
        
        // 设备状态设置字体属性
        NSMutableAttributedString *staStr = [[NSMutableAttributedString alloc] initWithString:_terminalStatusLbl.text];
        [staStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];

        if ([deviceModel.waterMchnStateName isEqualToString:@""] || deviceModel.waterMchnStateName == nil )
        {
        }else{
            
            [staStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:installColor] range:NSMakeRange(5, 3)];
        }
        
        [_terminalStatusLbl setAttributedText:staStr];
        
        // 设备编号设置字体属性
        NSMutableAttributedString *IdStr = [[NSMutableAttributedString alloc] initWithString:_terminalIDLbl.text];
        [IdStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];
        [_terminalIDLbl setAttributedText:IdStr];
        
    }else{
        
        WaterModel *wellModel = (id)model;
        // 设备状态
        _terminalStatusLbl.text = [NSString stringWithFormat:@"设备状态:%@",wellModel.waterMchnStateName];
        // 设备编号
        _terminalIDLbl.text     = [NSString stringWithFormat:@"设备编号:%@",wellModel.waterMchnId];
        
        // 设备状态设置字体属性
        NSMutableAttributedString *staStr = [[NSMutableAttributedString alloc] initWithString:_terminalStatusLbl.text];
        [staStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];

        if ([wellModel.waterMchnStateName isEqualToString:@""] || wellModel.waterMchnStateName == nil )
        {
        }else{
            
            [staStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:installColor] range:NSMakeRange(5, 3)];
        }
        
        [_terminalStatusLbl setAttributedText:staStr];
        
        // 设备编号设置字体属性
        NSMutableAttributedString *IdStr = [[NSMutableAttributedString alloc] initWithString:_terminalIDLbl.text];
        [IdStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:midGrayColor] range:NSMakeRange(0, 5)];
        [_terminalIDLbl setAttributedText:IdStr];
    }
}

@end
