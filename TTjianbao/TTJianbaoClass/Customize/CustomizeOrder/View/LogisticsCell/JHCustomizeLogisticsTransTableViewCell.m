//
//  JHCustomizeLogisticsTransTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeLogisticsTransTableViewCell.h"

@interface JHCustomizeLogisticsTransTableViewCell ()
@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *subLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIView      *logoImageView;
@end

@implementation JHCustomizeLogisticsTransTableViewCell
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
    self.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f));
    }];
    
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x999999);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontNormal size:13.f];
    [_backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(30.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.top.equalTo(self.backView.mas_top).offset(10.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _logoImageView = [[UIView alloc] init];
    _logoImageView.backgroundColor = HEXCOLOR(0x999999);
    _logoImageView.layer.cornerRadius = 3.f;
    _logoImageView.layer.masksToBounds = YES;
    [_backView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameLabel.mas_left).offset(-15.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6.f, 6.f));
    }];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = HEXCOLOR(0x979797);
    [_backView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.backView.mas_top);
        make.width.mas_equalTo(1.f);
        make.bottom.equalTo(self.logoImageView.mas_top).offset(-2.f);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = HEXCOLOR(0x979797);
    [_backView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.logoImageView.mas_bottom);
        make.width.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    _subLabel               = [[UILabel alloc] init];
    _subLabel.textColor     = HEXCOLOR(0x999999);
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [_backView addSubview:_subLabel];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.logoImageView.mas_right).offset(10.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
    }];
    
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:11.f];
    [_backView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.logoImageView.mas_right).offset(10.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-5.f);
    }];
    
}


- (void)copyAction:(UIButton*)button{
//    [JHKeyWindow makeToast:@"复制成功!" duration:1.0 position:CSToastPositionCenter];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = self.orderMode.orderCode;
}


- (void)setViewModel:(JHCustomizeLogisticsDataModel *)viewModel isLast:(BOOL)isLast {
    self.nameLabel.text = NONNULL_STR(viewModel.context);
    self.subLabel.text  = NONNULL_STR(viewModel.time);
    self.timeLabel.text = NONNULL_STR(viewModel.ftime);
    if (isLast) {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.mas_bottom).offset(-15.f);
        }];
    } else {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.mas_bottom).offset(-5.f);
        }];
    }
}



@end

