//
//  JHNoticeTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHNoticeTableViewCell.h"
#import "JHMerchantTypeModel.h"
#import "NSObject+JHTools.h"

@interface JHNoticeTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JHNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMerchantModel:(JHMerchantTypeModel *)merchantModel {
    _merchantModel = merchantModel;
    if (!_merchantModel) {
        return;
    }
    _titleLabel.text = _merchantModel.titleText;
    _detailLabel.text = _merchantModel.detailDescription;
//    _detailLabel.attributedText = [self paraStyleTextRetract:_merchantModel.detailDescription FontSize:13];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    _titleLabel.text = @"";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _detailLabel.textColor = HEXCOLOR(0x333333);
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _detailLabel.text = @"";
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:_titleLabel];
    [backgroundView addSubview:_detailLabel];
    [backgroundView addSubview:lineView];

    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView).with.offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).with.offset(15);
        make.height.equalTo(@40);
        make.top.right.equalTo(backgroundView);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backgroundView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(11);
        make.right.equalTo(backgroundView.mas_right).with.offset(-15);
        make.height.equalTo(@75);
    }];
    
    ///为背景切圆角
    [self layoutIfNeeded];
    backgroundView.layer.cornerRadius = 4.f;
    backgroundView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
