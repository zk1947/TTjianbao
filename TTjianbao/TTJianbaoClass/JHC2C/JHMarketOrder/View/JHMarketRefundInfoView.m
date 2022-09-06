//
//  JHMarketRefundInfoView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketRefundInfoView.h"
#import "JHMarketRefundTypeView.h"
#import "JHRecycleOrderCancelViewController.h"
#import "NSString+AttributedString.h"
@interface JHMarketRefundInfoView()
/** 退款信息*/
@property (nonatomic, strong) UILabel *InfoLabel;
/** 退款类型*/
@property (nonatomic, strong) UILabel *typeLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView1;

/** 退款金额*/
@property (nonatomic, strong) UILabel *moneyTagLabel;
/** 退款金额数量*/
@property (nonatomic, strong) UILabel *moneyCountLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView2;

/** 退款原因*/
@property (nonatomic, strong) UILabel *reasonLabel;
/** 箭头*/
@property (nonatomic, strong) UIImageView *arrowImageView2;

@end

@implementation JHMarketRefundInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self ==[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)setRefundMoney:(NSString *)refundMoney {
    _refundMoney = refundMoney;
    self.moneyCountLabel.text = [NSString stringWithFormat:@"¥%@", refundMoney];
}

- (void)refundTypeButtonClick {
    JHMarketRefundTypeView *refundTypeView = [[JHMarketRefundTypeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    @weakify(self);
    refundTypeView.selectCompleteBlock = ^(NSString * _Nonnull message, NSInteger typeIndex) {
        @strongify(self);
        [self.typeButton setTitle:message forState:UIControlStateNormal];
        self.refundType = typeIndex;
    };
    [[UIApplication sharedApplication].keyWindow addSubview:refundTypeView];
}

- (void)refundReasonnButtonClick {
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.dataArray =self.reasonsArray;
    vc.titleString = @"选择退款理由";
    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString * _Nonnull code) {
        @strongify(self);
        [self.reasonButton setTitle:message forState:UIControlStateNormal];
        self.reasonString = message;
        self.reasonCode = code;
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)configUI {
    [self addSubview:self.InfoLabel];
    [self addSubview:self.typeLabel];
    [self addSubview:self.typeButton];
    [self addSubview:self.arrowImageView1];
    [self addSubview:self.lineView1];
    
    [self addSubview:self.moneyTagLabel];
    [self addSubview:self.moneyDesLabel];
    [self addSubview:self.moneyCountLabel];
    [self addSubview:self.lineView2];
    
    [self addSubview:self.reasonLabel];
    [self addSubview:self.reasonButton];
    [self addSubview:self.arrowImageView2];
    
    
    [self.InfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(13);
        make.left.mas_equalTo(self).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.InfoLabel.mas_bottom).offset(13);
        make.left.mas_equalTo(self).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.arrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.typeLabel);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(11);
    }];
    
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.typeLabel);
        make.right.mas_equalTo(self.arrowImageView1.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(11);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.moneyTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.height.mas_equalTo(18);
    }];
    
    [self.moneyDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moneyTagLabel);
        make.left.mas_equalTo(self.moneyTagLabel.mas_right).offset(10);
    }];
    
    [self.moneyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moneyTagLabel);
        make.right.mas_equalTo(self).offset(-10);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyTagLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView2.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.height.mas_equalTo(18);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    
    [self.arrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reasonLabel);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(11);
    }];
    
    [self.reasonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reasonLabel);
        make.right.mas_equalTo(self.arrowImageView2.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    
    
}

- (UILabel *)InfoLabel {
    if (_InfoLabel == nil) {
        _InfoLabel = [[UILabel alloc] init];
        _InfoLabel.text = @"退款信息";
        _InfoLabel.textColor = HEXCOLOR(0x222222);
        _InfoLabel.font = [UIFont fontWithName:kFontMedium size:14];
    }
    return _InfoLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0x666666);
        _typeLabel.font = [UIFont fontWithName:kFontNormal size:13];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"* ", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:13]};
        itemsArray[1] = @{@"string":@"退款类型", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontBoldDIN size:13]};
        _typeLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _typeLabel;
}

- (UIImageView *)arrowImageView1 {
    if (_arrowImageView1 == nil) {
        _arrowImageView1 = [[UIImageView alloc] init];
        _arrowImageView1.image = [UIImage imageNamed:@"icon_banckCard_arrow"];
    }
    return _arrowImageView1;
}

- (UIButton *)typeButton {
    if (_typeButton == nil) {
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeButton setTitle:@"请选择" forState:UIControlStateNormal];
        _typeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_typeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_typeButton addTarget:self action:@selector(refundTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeButton;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineView1;
}

- (UILabel *)moneyTagLabel {
    if (_moneyTagLabel == nil) {
        _moneyTagLabel = [[UILabel alloc] init];
        _moneyTagLabel.textColor = HEXCOLOR(0x666666);
        _moneyTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"* ", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:13]};
        itemsArray[1] = @{@"string":@"退款金额", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontBoldDIN size:13]};
        _moneyTagLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _moneyTagLabel;
}

- (UILabel *)moneyDesLabel {
    if (_moneyDesLabel == nil) {
        _moneyDesLabel = [[UILabel alloc] init];
        _moneyDesLabel.text = @"按商品金额退款，不退运费";
        _moneyDesLabel.textColor = HEXCOLOR(0xcccccc);
        _moneyDesLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _moneyDesLabel;
}

- (UILabel *)moneyCountLabel {
    if (_moneyCountLabel == nil) {
        _moneyCountLabel = [[UILabel alloc] init];
        _moneyCountLabel.text = @"¥300";
        _moneyCountLabel.textColor = HEXCOLOR(0xff4200);
        _moneyCountLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
    }
    return _moneyCountLabel;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineView2;
}

- (UILabel *)reasonLabel {
    if (_reasonLabel == nil) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textColor = HEXCOLOR(0x666666);
        _reasonLabel.font = [UIFont fontWithName:kFontNormal size:13];
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"* ", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:13]};
        itemsArray[1] = @{@"string":@"退款原因", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontBoldDIN size:13]};
        _reasonLabel.attributedText = [NSString mergeStrings:itemsArray];
    }
    return _reasonLabel;
}

- (UIImageView *)arrowImageView2 {
    if (_arrowImageView2 == nil) {
        _arrowImageView2 = [[UIImageView alloc] init];
        _arrowImageView2.image = [UIImage imageNamed:@"icon_banckCard_arrow"];
    }
    return _arrowImageView2;
}

- (UIButton *)reasonButton {
    if (_reasonButton == nil) {
        _reasonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reasonButton setTitle:@"请选择" forState:UIControlStateNormal];
        _reasonButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_reasonButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_reasonButton addTarget:self action:@selector(refundReasonnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reasonButton;
}



@end
