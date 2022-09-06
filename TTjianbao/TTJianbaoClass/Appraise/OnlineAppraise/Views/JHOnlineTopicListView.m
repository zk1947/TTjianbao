//
//  JHOnlineTopicListView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineTopicListView.h"
#import "UIView+CornerRadius.h"
#import "UIView+JHGradient.h"
#import "JHOnlineAppraiseHeader.h"

@interface JHOnlineTopicListView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, assign) JHOnlineTopicIconType iconType;
@property (nonatomic, strong) dispatch_block_t actionBlock;


@end

@implementation JHOnlineTopicListView

- (void)setIcon:(NSString *)icon name:(NSString *)name iconType:(JHOnlineTopicIconType)iconType {
    _icon = icon;
    _topic = name;
    _iconType = iconType;
    
    if (_iconType == JHOnlineTopicIconTypeText) {
        _iconImageView.hidden = YES;
        _countLabel.hidden = NO;
        _countLabel.text = [icon isNotBlank] ? icon : @"0+";
    }
    else {
        _iconImageView.hidden = NO;
        _countLabel.hidden = YES;
        if ([_icon isNotBlank]) {
            [_iconImageView jh_setImageWithUrl:_icon];
        }
    }
    _topicLabel.text = [_topic isNotBlank] ? _topic : @"--";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconType = JHOnlineTopicIconTypeImg;
        [self initViews];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleTopicAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)initViews {
    UIImageView *icon = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [self addSubview:icon];
    _iconImageView = icon;
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"0+";
    countLabel.font = [UIFont fontWithName:kFontBoldPingFang size:16.];
    countLabel.textColor = kColorFFF;
    countLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:countLabel];
    _countLabel = countLabel;
    _countLabel.hidden = YES;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"";
    label.font = [UIFont fontWithName:kFontNormal size:12.];
    label.textColor = kColor666;
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:label];
    _topicLabel = label;
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kTopicIconWidth, kTopicIconWidth));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kTopicIconWidth, kTopicIconWidth));
    }];
    
    [_topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
    }];
    
    [_iconImageView yd_setCornerRadius:kTopicIconWidth/2. corners:UIRectCornerAllCorners];
    [_countLabel yd_setCornerRadius:kTopicIconWidth/2. corners:UIRectCornerAllCorners];
    [_countLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xA1B0C7), HEXCOLOR(0xC3CEDE)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)__handleTopicAction {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)topicCellClick:(dispatch_block_t)block {
    _actionBlock = block;
}
@end
