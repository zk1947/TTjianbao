//
//  NTESAudienceConnectView.m
//  TTjianbao
//
//  Created by chris on 16/7/21.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESAudienceConnectView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"

@interface NTESAudienceConnectView()

@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NIMAvatarImageView *avatar;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation NTESAudienceConnectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 158.f)];
        [_bar setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bar];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_bar addSubview:_titleLabel];
        
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_bar addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:9.f];
        [_nameLabel setTextColor:HEXCOLOR(0x999999)];
        [_bar addSubview:_nameLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.height = 40.f;
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"icon_cell_red_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch]  forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[[UIImage imageNamed:@"icon_cell_red_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch]  forState:UIControlStateHighlighted];
        [_cancelButton setTitle:@"取消连线" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_cancelButton];
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setType:(NIMNetCallMediaType)type
{
    _type = type;
    NSString *connect = @"";
    switch (type) {
        case NIMNetCallMediaTypeVideo:
            connect = @"视频";
            break;
        case NIMNetCallMediaTypeAudio:
            connect = @"音频";
            break;
        default:
            break;
    }
    _titleLabel.text = [NSString stringWithFormat:@"已申请与主播%@连线", connect];
    [_titleLabel sizeToFit];
}

- (void)setRoomId:(NSString *)roomId
{
    [self.avatar nim_setImageWithURL:nil placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
    NIMChatroom *chatroom = [[NTESLiveManager sharedInstance] roomInfo:roomId];
    [_nameLabel setText:chatroom.creator];
    [_nameLabel sizeToFit];
    __weak typeof(self) weakSelf = self;
    [[NTESLiveManager sharedInstance] anchorInfo:chatroom.roomId handler:^(NSError *error, NIMChatroomMember *anchor) {
        [weakSelf.avatar nim_setImageWithURL:nil placeholderImage:[NTESDataManager sharedInstance].defaultUserAvatar];
        [weakSelf.nameLabel setText:anchor.roomNickname];
        [weakSelf.nameLabel sizeToFit];
        [weakSelf setNeedsLayout];
    }];
}

- (void)onTapBackground:(UIButton *)button
{
    [self dismiss];
}


- (void)onTouchButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onCancelConnect:)]) {
        [self.delegate onCancelConnect:self];
    }
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bar.bottom = self.height;
    
    CGFloat buttonSpacing = 65.f;
    self.cancelButton.width = self.width - 2 * buttonSpacing;
    
    CGFloat top = 10;
    CGFloat titleAndAvatarSpacing = 14;
    CGFloat avatarAndNameSpacing  = 2;
    CGFloat nameAndButtonSpacing  = 10;
    
    self.titleLabel.top = top;
    self.titleLabel.centerX = self.width * .5f;
    self.avatar.top = self.titleLabel.bottom + titleAndAvatarSpacing;
    self.avatar.centerX = self.width * .5f;
    self.nameLabel.top = self.avatar.bottom + avatarAndNameSpacing;
    self.nameLabel.centerX = self.width * .5f;
    self.cancelButton.top  = self.nameLabel.bottom + nameAndButtonSpacing;
    self.cancelButton.centerX = self.width * .5f;
}

@end
