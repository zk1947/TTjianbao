//
//  JHTitleHeaderCollectionReusableView.m
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTitleHeaderCollectionReusableView.h"
#import "UIButton+ImageTitleSpacing.h"

@implementation JHTitleHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-10);
            make.top.bottom.equalTo(self);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(@15);
        }];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"查看全部" forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
//        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"icon_person_arrow_right"] forState:UIControlStateNormal];
//        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                                imageTitleSpace:15];
//        [btn addTarget:self action:@selector(checkAllOrder) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(view).offset(-20);
//            make.centerY.equalTo(view);
//        }];
//        self.checkAllBtn = btn;
//
        [self layoutIfNeeded];
        CAShapeLayer *mask = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];

        mask.path = path.CGPath;
        mask.frame = view.bounds;
        view.layer.mask = mask;

    }
    return self;
}

- (void)checkAllOrder {
    if (self.checkAllBlock) {
        self.checkAllBlock(nil);
    }
}

@end

@implementation JHBlankCornerHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-10);
            make.top.bottom.equalTo(self);
        }];

        [self layoutIfNeeded];
        CAShapeLayer *mask = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];

        mask.path = path.CGPath;
        mask.frame = view.bounds;
        view.layer.mask = mask;

    }
    return self;
}

@end


@implementation JHCollectionFootor
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
    
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(10);
            make.trailing.equalTo(self).offset(-10);
            make.top.equalTo(self);
            make.height.equalTo(@(10));
        }];
       
        [self layoutIfNeeded];
        CAShapeLayer *mask = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8,8)];

        mask.path = path.CGPath;
        mask.frame = view.bounds;
        view.layer.mask = mask;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.text = [NSString stringWithFormat:@"版本 %@", JHAppVersion];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}


@end
