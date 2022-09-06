//
//  JHCustomizeLogisticsInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeLogisticsInfoTableViewCell.h"

@interface JHCustomizeLogisticsInfoTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView  *backView;
@end

@implementation JHCustomizeLogisticsInfoTableViewCell

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
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(10.f, 0.f, ScreenW - 20.f, 37.f)];
    [self setView:self.backView cornerRadius:8.f addRectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    _backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f));
    }];
    
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [_backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20.f);
        make.right.equalTo(self.contentView.mas_right).offset(-20.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
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


- (void)setViewModel:(NSString *)viewModel isLast:(BOOL)isLast {
    self.nameLabel.text = viewModel;
    if (isLast) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
        }];
    } else {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
        }];
    }
}

@end
