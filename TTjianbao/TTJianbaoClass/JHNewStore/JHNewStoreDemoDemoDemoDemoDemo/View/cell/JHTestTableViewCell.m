//
//  JHTestTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTestTableViewCell.h"

@interface JHTestTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation JHTestTableViewCell

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

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenW - 20.f, 41.f)];
    [self setView:backView cornerRadius:8.f addRectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f));
    }];

    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20.f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

// 指定角圆角
- (void)setView:(UIView *)view cornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner {
    [self layoutIfNeeded];
    CGRect viewBounds = view.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


- (void)setViewModel:(NSString *)viewModel {
    self.nameLabel.text = NONNULL_STR(viewModel);
}


@end
