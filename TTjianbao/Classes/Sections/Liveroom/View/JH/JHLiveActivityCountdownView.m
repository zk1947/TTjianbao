//
//  JHLIveActicityCountdownView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/10/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLiveActivityCountdownView.h"
@interface JHLiveActivityCountdownView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *countdownLabel;
@end
@implementation JHLiveActivityCountdownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - UI
- (void)setupUI {
    [self jh_cornerRadius:7];
    self.backgroundColor = HEXCOLORA(0x000000, 0.5);
    [self addSubview:self.imageView];
    [self addSubview:self.countdownLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(9, 10));
        make.centerY.mas_equalTo(0);
    }];
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.imageView.mas_right).offset(3);
        make.right.mas_equalTo(-6);
    }];
}
#pragma mark - LAZY
- (void)setText:(NSString *)text {
    _text = text;
    self.countdownLabel.text = text;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"icon_live_signin"];
    }
    return _imageView;
}
- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        _countdownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countdownLabel.textColor = HEXCOLOR(0xffffff);
        _countdownLabel.font = [UIFont fontWithName:kFontNormal size:9];
    }
    return _countdownLabel;
}
@end
