//
//  JHIMQuickViewCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIMQuickViewCell.h"
@interface JHIMQuickViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHIMQuickViewCell
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    [self layoutViews];
}
- (void)setupData {
    if (self.model == nil) return;
    self.titleLabel.text = self.model.quickReplyTerms;
}
#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xffffff);
    [self jh_cornerRadius:8];
    [self addSubview:self.titleLabel];
    [self layoutViews];
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(30);
    }];
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    [self setNeedsLayout];
//
//    [self layoutIfNeeded];
    CGFloat width = [self.titleLabel.text widthForFont:[UIFont fontWithName:kFontNormal size:12]];
//    CGSize size = [self systemLayoutSizeFittingSize: layoutAttributes.size];

    CGRect cellFrame = layoutAttributes.frame;

    cellFrame.size.width = floor(width) + 18;

    layoutAttributes.frame = cellFrame;
    
    return layoutAttributes;
}
#pragma mark - Lazy
- (void)setModel:(JHIMQuickModel *)model {
    _model = model;
    [self setupData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _titleLabel;
}
@end
