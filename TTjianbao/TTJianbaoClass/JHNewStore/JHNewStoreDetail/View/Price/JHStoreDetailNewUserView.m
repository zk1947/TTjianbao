//
//  JHStoreDetailNewUserView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailNewUserView.h"
@interface JHStoreDetailNewUserView()
/// 新人福利按钮
@property (nonatomic, strong) UIButton *detailButton;
/// 更多图标
@property (nonatomic, strong) UIImageView *moreImageView;
@end

@implementation JHStoreDetailNewUserView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
//#pragma mark - Public Functions
//
//#pragma mark - Private Functions
#pragma mark - Action functions
- (void)didTapDetailButton : (UIButton *)sender {
    [self.detailAction sendNext:nil];
}
#pragma mark - Bind
- (void) bindData {
    
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"F23730"];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailButton];
    [self addSubview:self.moreImageView];
}

- (void) layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(PriceTitleTopSpace);
    }];
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-LeftSpace);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreImageView.mas_left).offset(-4);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(80);
    }];
}

#pragma mark - Lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"新人价";
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}
- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton
        .jh_fontNum(12)
        .jh_title(@"更多新人福利")
        .jh_titleColor([UIColor colorWithHexString:@"FAE1BE"])
        .jh_action(self, @selector(didTapDetailButton:));
        _detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _detailButton;
}
- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_userMore_orange_icon"]];
    }
    return _moreImageView;
}
- (RACSubject *)detailAction {
    if (!_detailAction) {
        _detailAction = [RACSubject subject];
    }
    return _detailAction;
}
@end
