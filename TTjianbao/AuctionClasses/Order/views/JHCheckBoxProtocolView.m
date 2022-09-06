//
//  JHCheckBoxProtocolView.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCheckBoxProtocolView.h"
#import "JHPreTitleLabel.h"
#import "JHUIFactory.h"

@interface JHCheckBoxProtocolView()
@property (nonatomic, strong) UIButton *protocolBtn;
@property (nonatomic, strong) UILabel *label;
@end

@implementation JHCheckBoxProtocolView

- (instancetype)initWithSelImageName:(NSString *)selImageNameStr normalImageName:(NSString *)normalImageNameStr tipStr:(NSString *)tipStr protocolStr:(NSString *)protocolStr {
    self = [super init];
    if (self) {
        UIView *protocolView = [UIView new];
        protocolView.userInteractionEnabled = YES;
        [protocolView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(protocolAction)]];
        [self addSubview:protocolView];
        
        [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        JHPreTitleLabel *label = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0xFF999999) font:[UIFont fontWithName:kFontNormal size:12] textAlignment:NSTextAlignmentLeft preTitle:tipStr];
        self.label = label;
        [label setJHAttributedText:protocolStr font:[UIFont fontWithName:kFontNormal size:12] color:HEXCOLOR(0xFF408FFE)];
        label.userInteractionEnabled = NO;
        [protocolView addSubview:label];

        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setImage:[UIImage imageNamed:selImageNameStr] forState:UIControlStateSelected];
        [_protocolBtn setImage:[UIImage imageNamed:normalImageNameStr] forState:UIControlStateNormal];
        _protocolBtn.contentMode = UIViewContentModeScaleAspectFit;
        _protocolBtn.selected = NO;
        [_protocolBtn addTarget:self action:@selector(onProtocolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [protocolView addSubview:_protocolBtn];
       
        [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(protocolView.mas_left).offset(0);
            make.centerY.equalTo(protocolView).offset(0);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(protocolView);
            make.left.equalTo(_protocolBtn.mas_right).offset(0);
        }];
    }
    return  self;
}

- (Boolean)getCheckBoxSelectStatus {
    return self.protocolBtn.selected;
}

- (void)protocolAction {
    if (self.checkBoxProtocolClickBlock) {
        self.checkBoxProtocolClickBlock();
    }
}

- (void)onProtocolBtnAction:(UIButton *)btn {
    btn.selected=!btn.selected;
}

- (void)setIsC2cConfirm:(BOOL)isC2cConfirm {
    _isC2cConfirm  = isC2cConfirm;
    if (isC2cConfirm == false) return;
    [self.protocolBtn setSelected:true];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_protocolBtn.mas_right).offset(2.f);
    }];
    [self.protocolBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 36));
    }];
}
@end
