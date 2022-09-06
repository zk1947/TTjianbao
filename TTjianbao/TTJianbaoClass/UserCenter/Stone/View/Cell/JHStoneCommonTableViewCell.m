//
//  JHStoneCommonTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneCommonTableViewCell.h"
#import "JHUIFactory.h"

@implementation JHStoneCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawCommonView];
    }
    
    return self;
}

- (void)drawCommonView
{
    self.ctxImage = [JHUIFactory createImageView];
    [self.background addSubview:self.ctxImage];
    [self.ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.background).offset(11);
        make.size.mas_equalTo(90);
    }];
    
    self.playImage = [JHUIFactory createImageView];
    self.playImage.userInteractionEnabled = NO;
    self.playImage.image = [UIImage imageNamed:@"stone_video_play"];
    [self.ctxImage addSubview:self.playImage];
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.ctxImage);
        make.size.mas_equalTo(23);
    }];
    
    self.sawLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFFFFFF) font:JHFont(11) textAlignment:NSTextAlignmentCenter];
    self.sawLabel.backgroundColor = HEXCOLORA(0x000000, 0.5);
    [self.background addSubview:self.sawLabel];
    [self.sawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(16);
        make.left.bottom.width.mas_equalTo(self.ctxImage);
    }];
    [self.sawLabel setHidden:YES];
    
    self.idLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"编号："];
    [self.background addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ctxImage).offset(12);
        make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
    }];
    
    self.descpLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:self.descpLabel];
    [self.descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idLabel.mas_bottom).offset(8);
        make.left.equalTo(self.idLabel);
        make.right.mas_equalTo(self.background).offset(-42);
    }];
    
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0xFC4200) font:JHFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ctxImage.mas_right).offset(8);
        make.top.mas_equalTo(self.descpLabel.mas_bottom).offset(5);
    }];
    
    self.bottomLine = [[JHCustomLine alloc] init];
    self.bottomLine.color = HEXCOLORA(0xFFFFFF, 0.2);
    [self.background addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.background.mas_bottom).offset(-1);
        make.left.equalTo(self.background).offset(10);
        make.right.equalTo(self.background).offset(-10);
        make.height.mas_equalTo(1);
    }];
    [self.bottomLine setHidden:YES];
}

- (void)resetSubview
{
    //主题变成:JHCellThemeTypeClearColor时,需调整
    self.backgroundColor = kCellThemeClearColor;
    self.background.backgroundColor = kCellThemeClearColor;
//    [self.background mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self);
//    }];
    
    [self.sawLabel setHidden:NO];
    [self.bottomLine setHidden:NO];
    
    //回血直播间,约束重置(坐标变小)
    [self.ctxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.background).offset(10);
        make.size.mas_equalTo(74);
    }];
    
    [self.playImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.ctxImage);
        make.size.mas_equalTo(18);
    }];
    
    //super subviews
    self.idLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
    [self.idLabel setFont:JHMediumFont(14)];
    [self.idLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ctxImage.mas_top);
        make.left.mas_equalTo(self.ctxImage.mas_right).offset(11);
    }];
    
    self.descpLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
    [self.descpLabel setFont:JHMediumFont(14)];
    [self.descpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.idLabel.mas_bottom).offset(2);
        make.left.equalTo(self.idLabel);
        make.right.equalTo(self.background).offset(-42);
    }];
    
    self.priceLabel.textColor = HEXCOLOR(0xFFFFFF);
    [self.priceLabel setFont:JHBoldFont(17)];
    self.priceLabel.minimumScaleFactor = 0.6;
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ctxImage.mas_right).offset(11);
        make.right.mas_equalTo(self.background).offset(-150);
        make.top.mas_equalTo(self.descpLabel.mas_bottom).offset(8);
    }];
}

- (void)updateCell:(id)model
{
    /*子类重写*/
}

@end
