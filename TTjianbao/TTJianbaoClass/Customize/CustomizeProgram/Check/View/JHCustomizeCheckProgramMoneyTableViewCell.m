//
//  JHCustomizeCheckProgramMoneyTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramMoneyTableViewCell.h"

@interface JHCustomizeCheckProgramMoneyTableViewCell ()
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *serverLabel;
@property (nonatomic, strong) UILabel     *materialLabel;
@property (nonatomic, strong) UILabel     *serverMoneyLabel;
@property (nonatomic, strong) UILabel     *materialMoneyLabel;
@property (nonatomic, strong) UILabel     *finalMoneyLable;
@property (nonatomic, strong) UILabel     *moneyLabel;
@end

@implementation JHCustomizeCheckProgramMoneyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
   
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
//    _nameLabel.text          = @"方案金额";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(0.f);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(0.f);
    }];
    
    /// 服务费
    _serverLabel               = [[UILabel alloc] init];
    _serverLabel.textColor     = HEXCOLOR(0x333333);
    _serverLabel.textAlignment = NSTextAlignmentLeft;
    _serverLabel.text          = @"服务费";
    _serverLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_serverLabel];
    [_serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _serverMoneyLabel = [[UILabel alloc] init];
    _serverMoneyLabel.textColor     = HEXCOLOR(0x999999);
    _serverMoneyLabel.textAlignment = NSTextAlignmentRight;
    _serverMoneyLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_serverMoneyLabel];
    [_serverMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.serverLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 材料费
    _materialLabel               = [[UILabel alloc] init];
    _materialLabel.textColor     = HEXCOLOR(0x333333);
    _materialLabel.textAlignment = NSTextAlignmentLeft;
    _materialLabel.text          = @"材料费";
    _materialLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_materialLabel];
    [_materialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serverLabel.mas_left);
        make.top.equalTo(self.serverLabel.mas_bottom).offset(15.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _materialMoneyLabel = [[UILabel alloc] init];
    _materialMoneyLabel.textColor     = HEXCOLOR(0x999999);
    _materialMoneyLabel.textAlignment = NSTextAlignmentRight;
    _materialMoneyLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_materialMoneyLabel];
    [_materialMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.materialLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];

    /// 分割线
//    CALayer *lineLayer = [CALayer layer];
//    lineLayer.backgroundColor = HEXCOLOR(0xF0F0F0).CGColor;
//    lineLayer.frame = CGRectMake(10.f, 124.f, ScreenW-40.f, 1.f);
//    [self.layer addSublayer:lineLayer];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.materialLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(1.f);
    }];
    
    
    /// 总金额
    _finalMoneyLable               = [[UILabel alloc] init];
    _finalMoneyLable.textColor     = HEXCOLOR(0x333333);
    _finalMoneyLable.textAlignment = NSTextAlignmentLeft;
    _finalMoneyLable.text          = @"方案金额";
    _finalMoneyLable.font          = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_finalMoneyLable];
    [_finalMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.materialLabel.mas_left);
        make.top.equalTo(lineView.mas_bottom).offset(15.f);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    /// 总额
    _moneyLabel               = [[UILabel alloc] init];
    _moneyLabel.textColor     = HEXCOLOR(0xFF4200);
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    _moneyLabel.font          = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.finalMoneyLable.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.width.mas_equalTo(136.f);
        make.height.mas_equalTo(17.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
}


- (void)setViewModel:(id)viewModel {
    NSDictionary *dict = [NSDictionary cast:viewModel];
    self.serverMoneyLabel.text   = dict[@"planDesc"];
    self.materialMoneyLabel.text = dict[@"extPrice"];
    double mixMoney = [self.serverMoneyLabel.text doubleValue] + [self.materialMoneyLabel.text doubleValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",mixMoney];
}


@end
