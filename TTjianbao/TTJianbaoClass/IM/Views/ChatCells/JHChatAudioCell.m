//
//  JHChatAudioCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatAudioCell.h"
#import "UIImageView+JHAnimation.h"
@interface JHChatAudioCell()
@property (nonatomic, strong) UIStackView *dateContentView;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UILabel *dateLabel;
@end
@implementation JHChatAudioCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    NSLog(@"IM释放-%@ 释放", [self class]);
}

- (void)setupData {
    @weakify(self)
    [[RACObserve(self.message, message)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        NIMMessage *message = (NIMMessage *)x;
        NIMAudioObject *object = (NIMAudioObject *)message.messageObject;
        self.dateLabel.text = [NSString stringWithFormat:@"%.lds", (long)object.duration / 1000];
    }];
    
    [[ RACObserve(self.message, width)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        CGFloat width = [x floatValue];
        [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }];
    
    [[RACObserve(self.message, isSelected)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        CGFloat isSelected = [x boolValue];
        if (isSelected) {
            [self startAnimation];
        }else {
            [self stopAnimation];
        }
    }];
}
- (void)startAnimation {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i < 4; i++) {
        NSString *name = [NSString stringWithFormat:@"IM_audio_play_icon%d", i];
        [arr appendObject:name];
    }
    [self.animationView startAnimationWithImages:arr];
}
- (void)stopAnimation {
    [self.animationView stopAnimating];
}
#pragma mark - UI
- (void)setupUI {
    [self.messageContent addSubview:self.dateContentView];
}
- (void)layoutViews {

    [self.dateContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
        if (self.message.senderType == JHMessageSenderTypeMe) {
            make.right.mas_equalTo(-10);
        }else {
            make.left.mas_equalTo(10);
        }
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark - LAZY
- (UIStackView *)dateContentView {
    if (!_dateContentView) {
        _dateContentView = [[UIStackView alloc] initWithArrangedSubviews:@[self.dateLabel, self.animationView]];
        _dateContentView.axis = UILayoutConstraintAxisHorizontal;;
        _dateContentView.spacing = 5;
        _dateContentView.alignment = UIStackViewAlignmentCenter;
        _dateContentView.distribution = UIStackViewDistributionEqualSpacing;
        _dateContentView.userInteractionEnabled = false;
    }
    return _dateContentView;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textColor = HEXCOLOR(0x333333);
        _dateLabel.font = [UIFont fontWithName:kFontNormal size:15];
    }
    return _dateLabel;
}
- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationView.image = [UIImage imageNamed:@"IM_audio_play_icon3"];
    }
    return _animationView;
}
@end
