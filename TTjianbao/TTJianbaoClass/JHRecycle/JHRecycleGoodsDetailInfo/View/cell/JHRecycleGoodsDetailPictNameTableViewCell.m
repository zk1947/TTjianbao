//
//  JHRecycleGoodsDetailPictNameTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailPictNameTableViewCell.h"

@interface JHRecycleGoodsDetailPictNameTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JHRecycleGoodsDetailPictNameTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    /// 名称
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x222222);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:14.f];
    _nameLabel.text          = @"商品细节图";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12.f);
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSString *pictNameStr = viewModel;
    self.nameLabel.text = isEmpty(pictNameStr)?@"商品细节图":pictNameStr;
}

@end
