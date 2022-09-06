//
//  JHShopInfoListTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopInfoListTableCell.h"

@interface JHShopInfoListTableCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation JHShopInfoListTableCell

+ (CGFloat)cellHeight {
    return 60.;
}

- (void)title:(NSString *)title desc:(NSString *)desc {
    _titleLabel.text = [title isNotBlank] ? title : @"";
    _descLabel.text = [desc isNotBlank] ? desc : @"";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorFFF;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"店铺头像";
    titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    titleLabel.textColor = kColor666;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"店铺名称";
    descLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    descLabel.textColor = kColor333;
    [self.contentView addSubview:descLabel];
    _descLabel = descLabel;
        
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
