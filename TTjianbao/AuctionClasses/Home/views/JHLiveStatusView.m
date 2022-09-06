//
//  JHLiveStatusView.m
//
//
//  Created by lihui on 2020/7/14.
//

#import "JHLiveStatusView.h"
#import "UIImageView+JHWebImage.h"
#import <UIImage+WebP.h>
#import "NSString+YYAdd.h"
#import "YYKit/YYKit.h"

@interface JHLiveStatusView () {
    NSInteger _status;
    NSString *_watchCount;
}

@property (strong, nonatomic) YYAnimatedImageView *liveImageView;
//@property (strong, nonatomic) UIImageView *playingImage;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *watchLabel;

@end

@implementation JHLiveStatusView


- (void)setLiveStatus:(NSInteger)status watchTotal:(NSString *)watchCount {
    _status = status;
    _watchCount = watchCount;
    
    BOOL isLive = (status == 2);
    _liveImageView.hidden = !isLive;
    if ([self.statusString isNotBlank]) {
        _statusLabel.text = _statusString;
        _statusLabel.textColor = [UIColor whiteColor];
        _watchLabel.textColor = [UIColor whiteColor];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    else {
        _statusLabel.text = isLive ? @"直播中" : @"休息中";
        UIColor *color = isLive ? [UIColor whiteColor] : HEXCOLOR(0x999999);
        _statusLabel.textColor = color;
        _watchLabel.textColor = color;
        _lineView.backgroundColor = color;
    }
    CGFloat offset = isLive ? 22 : 5;
    [_statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(offset);
    }];
    BOOL isHidden = (![_watchCount isNotBlank] || !isLive);
    _watchLabel.text = !isHidden ? [NSString stringWithFormat:@"%@热度", watchCount] : @"";
    _watchLabel.hidden = isHidden;
    _lineView.hidden = isHidden;
    
    CGFloat space = !isHidden ? 4 : 0;
    [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).offset(space);
    }];
    [_watchLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(space);
    }];
}

- (void)setLivingColor:(UIColor *)livingColor {
    if (!livingColor) {
        return;
    }
    
    _livingColor = livingColor;
    _statusLabel.textColor = _livingColor;
    _lineView.backgroundColor = _livingColor;
    _watchLabel.textColor = _livingColor;
}

- (void)setRestColor:(UIColor *)restColor {
    if (!restColor) {
        return;
    }
    
    _restColor = restColor;
    _statusLabel.textColor = _restColor;
    _lineView.backgroundColor = _restColor;
    _watchLabel.textColor = _restColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    _statusLabel.font = [UIFont fontWithName:kFontNormal size:fontSize];
    _watchLabel.font = [UIFont fontWithName:kFontNormal size:fontSize];
}

- (void)setLiveImageStr:(NSString *)liveImageStr {
    if (!liveImageStr) {
        return;
    }
    _liveImageStr = liveImageStr;
    _liveImageView.image = [UIImage imageNamed:_liveImageStr];
    [_liveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.7);
        _fontSize = 11.f;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    YYImage *image = [YYImage imageNamed:@"icon_home_living.webp"];
    _liveImageView = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveImageView.contentMode = UIViewContentModeScaleAspectFit;
    _liveImageView.hidden = YES;
    
    UILabel *status = [[UILabel alloc] init];
    status.text = @"休息中";
    status.font = [UIFont systemFontOfSize:_fontSize];
    status.textColor = HEXCOLOR(0x999999);
    _statusLabel = status;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0xffffff);
    _lineView = lineView;
    _lineView.hidden = YES;
    
    UILabel *watchLabel = [[UILabel alloc]init];
    watchLabel.text = @"";
    watchLabel.font = [UIFont systemFontOfSize:_fontSize];
    watchLabel.textColor = [UIColor whiteColor];
    watchLabel.numberOfLines = 1;
    watchLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _watchLabel = watchLabel;
    
    [self addSubview:_liveImageView];
    [self addSubview:_statusLabel];
    [self addSubview:_lineView];
    [self addSubview:_watchLabel];

    [self makeLayouts];
}

- (void)makeLayouts {
    [_liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.centerY.equalTo(self);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(.5, 6));
    }];

    [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(4);
        make.right.equalTo(self.mas_right).offset(-4);
        make.centerY.equalTo(self);
    }];
}



@end
