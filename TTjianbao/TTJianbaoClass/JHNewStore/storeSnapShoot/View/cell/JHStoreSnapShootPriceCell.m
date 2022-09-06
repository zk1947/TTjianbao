//
//  JHStoreSnapShootPriceCell.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootPriceCell.h"

@implementation JHStoreSnapShootPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(10);
        }];
    }
    return self;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont fontWithName:kFontMedium size:30];
        _priceLabel.textColor = kColorMainRed;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}
- (void)setViewModel:(JHStoreSnapShootPriceViewModel *)viewModel {
    _viewModel = viewModel;
    RAC(self.priceLabel, attributedText) = [RACObserve(self.viewModel, salePriceText)
                                         takeUntil:self.rac_prepareForReuseSignal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
