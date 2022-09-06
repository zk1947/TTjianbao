//
//  JHChatCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCell.h"



@implementation JHChatCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupBaseUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBaseViews];
}
- (void)dealloc {
    NSLog(@"IM释放-%@ 释放", [self class]);
}

#pragma mark - Public
- (void)setupNomalData {
    if (self.message == nil) return;
    if (self.message.senderType == JHMessageSenderTypeMe) {
        [self layoutRightBaseViews];
    }else {
        [self layoutLeftBaseViews];
    }
    
    self.readStateLabel.hidden = self.message.senderType == JHMessageSenderTypeOther;
    
    @weakify(self)
    [[RACObserve(self.message, userInfo)
      takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHChatUserInfo *info = x;
        [self.iconView jh_setImageWithUrl:info.vatarUrl placeHolder:@"IM_user_icon"];
    }];
    // 发送状态
    [[RACObserve(self.message, sendState)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger status = [x integerValue];
        switch (status) {
            case JHMessageSendStateFail:  //发送失败
            case JHMessageSendStateBlack:
                self.sendStateButton.hidden = false;
                [self.activityIndicator stopAnimating];
                break;
            case JHMessageSendStateSending:  // 发送中
                self.sendStateButton.hidden = true;
                [self.activityIndicator startAnimating];
                break;
            default: // 发送成功
                self.sendStateButton.hidden = true;
                [self.activityIndicator stopAnimating];
                break;
        }
    }];
    // 已读状态
    [[RACObserve(self.message, isRemoteRead)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger status = [x integerValue];
        self.readStateLabel.text = status == 1 ? @"已读" : @"未读";
    }];
}
- (void)setupData {
    
}
#pragma mark - Event
- (void)didClickSendStateButton : (UIButton *)sender {
    if (self.delegate == nil) return;
    [self.delegate didClickResend : self message :self.message];
}
- (void)didLongPress : (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate == nil) return;
        [self.delegate didLongPress:self message:self.message];
    }
}
- (void)didClickCell : (UITapGestureRecognizer *)sender {
    if (self.delegate == nil) return;
    [self.delegate didClickCell:self message:self.message];
}
- (void)didClickHead : (UITapGestureRecognizer *)sender {
    NSString *userId = self.message.userInfo.customerId;
    if (self.delegate == nil) return;
    [self.delegate didClickHead:self userId:userId];
}

#pragma mark - UI
- (void)setupSubUI {
    
}
- (void)layoutViews {
    
}
- (void)setupBaseUI {
    
    self.backgroundColor = HEXCOLOR(0xf5f6fa);
    [self addSubview:self.iconView];
    [self addSubview:self.messageContent];
    [self addSubview:self.sendStateButton];
    [self addSubview:self.readStateLabel];
    [self addSubview:self.activityIndicator];
    [self setupSubUI];
    
}
- (void)layoutBaseViews {
    [self.iconView jh_cornerRadius:iconWidth / 2];
    [self layoutViews];
}
- (void)layoutLeftBaseViews {
    self.messageContent.backgroundColor = HEXCOLOR(0xffffff);
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconTop);
        make.left.mas_equalTo(leftSpace);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    [self.messageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.mas_equalTo(self.iconView.mas_right).offset(leftSpace);
        make.width.mas_lessThanOrEqualTo(contentMaxWidth);
        make.bottom.mas_equalTo(-contentBottomSpace);
    }];
    [self.sendStateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageContent.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self.messageContent.mas_centerY);
    }];
    [self.activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageContent.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self.messageContent.mas_centerY);
    }];
    [self.readStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.left.mas_equalTo(self.messageContent);
        make.height.mas_equalTo(14);
    }];
    
}
- (void)layoutRightBaseViews {
    self.messageContent.backgroundColor = HEXCOLOR(0xffd70f);
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconTop);
        make.right.mas_equalTo(-leftSpace);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    [self.messageContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.right.mas_equalTo(self.iconView.mas_left).offset(-leftSpace);
        make.width.mas_lessThanOrEqualTo(contentMaxWidth);
        make.bottom.mas_equalTo(-contentBottomSpace);
    }];
    [self.sendStateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageContent.mas_left).offset(-6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self.messageContent.mas_centerY);
    }];
    [self.activityIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messageContent.mas_left).offset(-6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self.messageContent.mas_centerY);
    }];
    [self.readStateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-14);
        make.right.mas_equalTo(self.messageContent);
        make.height.mas_equalTo(14);
    }];
}
#pragma mark - LAZY
- (void)setMessage:(JHMessage *)message {
    _message = message;
    [self setupNomalData];
    [self setupData];
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.image = [UIImage imageNamed:@"IM_user_icon"];
        _iconView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHead:)];
        [_iconView addGestureRecognizer:tap];
        
    }
    return _iconView;
}
- (UIView *)messageContent {
    if (!_messageContent) {
        _messageContent = [[UIView alloc] initWithFrame:CGRectZero];
        [_messageContent jh_cornerRadius:8];
        
        UILongPressGestureRecognizer *longpre = [[UILongPressGestureRecognizer alloc] init];
        [longpre addTarget:self action:@selector(didLongPress:)];
        longpre.minimumPressDuration = 0.5;
        [_messageContent addGestureRecognizer:longpre];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCell:)];
        [self.messageContent addGestureRecognizer:tap];
    }
    return _messageContent;
}
- (UIButton *)sendStateButton {
    if (!_sendStateButton) {
        _sendStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendStateButton setImage:[UIImage imageNamed:@"IM_sendState_icon"] forState:UIControlStateNormal];
        [_sendStateButton addTarget:self action:@selector(didClickSendStateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendStateButton;
}
- (UILabel *)readStateLabel {
    if (!_readStateLabel) {
        _readStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _readStateLabel.text = @"未读";
        _readStateLabel.textColor = HEXCOLOR(0x999999);
        _readStateLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _readStateLabel;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator setHidesWhenStopped:true];
    }
    return _activityIndicator;
}

@end
