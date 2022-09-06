//
//  JHChatRecordView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatRecordView.h"
#import "UIImageView+JHAnimation.h"
@interface JHChatRecordView()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isShow;
@end
@implementation JHChatRecordView
+ (instancetype)shared
{
    static JHChatRecordView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHChatRecordView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    });
    return instance;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
#pragma mark -Public
+ (void)showWithType : (JHChatRecordViewType)type {
    JHChatRecordView *view = [JHChatRecordView shared];
    if (type == JHChatRecordViewTypeRecording) {
        view.titleLabel.text = @"松开发送 上滑取消";
        [view startAnimation];
        
//        view.imageView.image = [UIImage imageNamed:@"IM_record_icon4"];
    }else {
        view.titleLabel.text = @"松开手指 取消发送";
        [view stopAnimation];
        view.imageView.image = [UIImage imageNamed:@"IM_record_cancel_icon"];
    }
    if (view.isShow == false) {
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
    view.isShow = true;
}
+ (void)hide {
    JHChatRecordView *view = [JHChatRecordView shared];
    view.isShow = false;
    [view removeFromSuperview];
    
}
- (void)startAnimation {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
    for (int i = 1; i < 5; i++) {
        NSString *name = [NSString stringWithFormat:@"IM_record_icon%d", i];
        [arr appendObject:name];
    }
    [self.imageView startAnimationWithImages:arr];
}
- (void)stopAnimation {
    [self.imageView stopAnimating];
}
#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.imageView];
    [self.containerView addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.containerView.mas_centerY).offset(-8);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-28);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}
#pragma mark - LAZY
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0x4c4c4c);
        [_containerView jh_cornerRadius:12];
    }
    return _containerView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"IM_record_icon4"];
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
