//
//  JHGoodManagerListAlertDurationTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListAlertDurationTableViewCell.h"
#import "JHGoodManagerSingleton.h"
#import "JHBusinessPublishTimePickerView.h"
#import "JHBusinessPublishContinueTimePicker.h"

@interface JHGoodManagerListAlertDurationTableViewCell ()
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UIButton     *selButton;
@property (nonatomic, strong) UIView       *lineView;
@property (nonatomic, strong) UIImageView  *rightImageView;
@property (nonatomic, strong) NSDictionary *valueDictionary;
@end

@implementation JHGoodManagerListAlertDurationTableViewCell

- (NSDictionary *)valueDictionary {
    if (!_valueDictionary) {
        _valueDictionary = [NSDictionary dictionary];
    }
    return _valueDictionary;
}

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
        
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x222222);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14.f);
    }];
    
    _selButton                            = [UIButton buttonWithType:UIButtonTypeCustom];
    _selButton.titleLabel.font            = [UIFont fontWithName:kFontNormal size:13.f];
    [_selButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_selButton addTarget:self action:@selector(selButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _selButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:_selButton];
    [_selButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(97.f);
        make.right.equalTo(self.contentView.mas_right).offset(-27.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.mas_equalTo(48.f);
    }];
    
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.image = [UIImage imageNamed:@"jhGoodManagerList_right"];
    [self.contentView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.centerY.equalTo(self.selButton.mas_centerY);
        make.width.mas_equalTo(5.f);
        make.height.mas_equalTo(11.f);
    }];
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selButton.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.selButton.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)selButtonClickAction:(UIButton *)sender {
    [self chooseGoodType];
}

- (void)setViewModel:(NSDictionary *)viewModel {
    self.valueDictionary = viewModel;
    
    NSMutableAttributedString *star = [[NSMutableAttributedString alloc] initWithString:viewModel[@"name"] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *end = [[NSMutableAttributedString alloc] initWithString:@" *" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:star];
    [commentString appendAttributedString:end];
    
    self.nameLabel.attributedText = commentString;
    
    [self.selButton setTitle:viewModel[@"placeholder"] forState:UIControlStateNormal];
    [self.selButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
}

- (void)setPubishModel:(JHBusinessPubishNomalModel *)pubishModel {
    _pubishModel = pubishModel;
}


- (void)chooseGoodType {
    if ([self.valueDictionary[@"name"] isEqualToString:@"持续时间"]) {
        [self controlAction3];
    }
    if ([self.valueDictionary[@"name"] isEqualToString:@"开始时间"]) {
        [self controlAction2];
    }
}

- (void)controlAction2 {
    JHBusinessPublishTimePickerView *countPicker = [[JHBusinessPublishTimePickerView alloc] init];
    countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    countPicker.normalModel = self.pubishModel;
    [countPicker show];
    @weakify(self);
    countPicker.sureClickBlock2 = ^(NSString * _Nonnull showStr, NSString * _Nonnull timeStr) {
        @strongify(self);
        /// 开始时间
        [JHGoodManagerSingleton shared].auctionStartTime = timeStr;
        
        [self.selButton setTitle:showStr forState:UIControlStateNormal];
        [self.selButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    };
}

- (void)controlAction3 {
    JHBusinessPublishContinueTimePicker *countPicker = [[JHBusinessPublishContinueTimePicker alloc] init];
    countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    countPicker.normalModel = self.pubishModel;
    [countPicker show];
    @weakify(self);
    countPicker.sureClickBlock2 = ^(NSString * _Nonnull showStr, NSString * _Nonnull timeStr) {
        @strongify(self);
        /// 持续时间
        [JHGoodManagerSingleton shared].auctionDuration = timeStr;

        [self.selButton setTitle:timeStr forState:UIControlStateNormal];
        [self.selButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    };
}


@end
