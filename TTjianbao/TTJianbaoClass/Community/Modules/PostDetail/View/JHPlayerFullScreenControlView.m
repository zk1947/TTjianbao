//
//  JHPlayerFullScreenControlView.m
//  TTjianbao
//
//  Created by lihui on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlayerFullScreenControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayerController.h>
#import "ZFSliderView.h"
#import "UIImageView+ZFCache.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYControl.h"
#import "UIButton+zan.h"

#define nameTopSpace        36.f
#define nameHeight          25.f
#define nameContentSpace    10.f
#define contentBottomSpace  10.f
#define bottomViewHeight    150.f
#define buttonWidth         35.f
#define buttonHeight        50.f
#define iconWidth           44.f

#define inputViewHeight     (UI.bottomSafeAreaHeight + 46);

@interface JHPlayerFullScreenControlView ()

///左侧按钮
@property (nonatomic, strong) UIButton *leftButton;
///右侧按钮
@property (nonatomic, strong) UIButton *rightButton;

///全屏模式下的控制层
@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) YYLabel *detaiLabel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;

/// 滑杆
@property (nonatomic, strong) ZFSliderView *sliderView;
@property (nonatomic, strong) ZFSliderView *bottomPgrogress;

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *textFiledView;
@property (nonatomic, strong) UILabel *placeholder;

/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;


@property (nonatomic, assign) CGFloat nameWidth;
@property (nonatomic, assign) CGFloat timeWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation JHPlayerFullScreenControlView

@synthesize player = _player;

- (void)setPostInfo:(JHPostDetailModel *)postInfo {
    if (!postInfo) {
        return;
    }
    
    _postInfo = postInfo;
    
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_postInfo.publisher.avatar] placeholder:kDefaultAvatarImage];
    if (_postInfo.is_self) {
        _addImageView.hidden = YES;
    }
    else {
        _addImageView.hidden = _postInfo.publisher.is_follow;
    }
    _nameLabel.text = [NSString stringWithFormat:@"@%@", _postInfo.publisher.user_name];
    _timeLabel.text = _postInfo.publish_time;
//    _detaiLabel.attributedText = _postInfo.contentAttrText;
    NSMutableAttributedString *mutableString = _postInfo.postContentAttrText;
    NSDictionary *attrs = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [mutableString addAttributes:attrs range:NSMakeRange(0, [[mutableString string] length])];
    _detaiLabel.attributedText = mutableString;
    _detaiLabel.userInteractionEnabled = _postInfo.showAll;

    [_commentButton setTitle:[NSString stringWithFormat:@"%@", _postInfo.comment_num > 0 ? @(_postInfo.comment_num).stringValue : @"评论"] forState:UIControlStateNormal];
    [_shareButton setTitle:(_postInfo.share_count_int > 0 ? @(_postInfo.share_count_int).stringValue:@"分享") forState:UIControlStateNormal];
    [_likeButton setTitle:(_postInfo.like_num_int> 0?@(_postInfo.like_num_int).stringValue:@"赞") forState:UIControlStateNormal];
    
    _likeButton.selected = _postInfo.is_like;
    if (_likeButton.selected) {
        [_likeButton zanAnimation];
    }
    
    _nameWidth = _postInfo.publisher.nameWidth;
    _timeWidth = _postInfo.timeWidth;
    _contentHeight = _postInfo.contentHeight;
    
    [self layoutIfNeeded];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _nameWidth = 0.f;
        _timeWidth = 0.f;
        _contentHeight = 0.f;
        
        // 添加子控件
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.leftButton];
        [self.topToolView addSubview:self.rightButton];

        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.nameLabel];
        [self.bottomToolView addSubview:self.timeLabel];
        [self.bottomToolView addSubview:self.detaiLabel];
        /** 这里暂时去掉了,当bug下次改*/
//        [self addSeeMoreButton];

        [self addSubview:self.iconImageView];
        [self addSubview:self.addImageView];
        [self addSubview:self.likeButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.shareButton];
        
        ///输入框部分
        [self addSubview:self.blackView];
        [self.blackView addSubview:self.textFiledView];
        [self.textFiledView addSubview:self.placeholder];
        
        [self addSubview:self.sliderView];
        
        [self addSubview:self.playBtn];
        [self resetControlView];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = (iPhoneX && self.player.isFullScreen) ? 80 : UI.statusAndNavBarHeight;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.isFullScreen) ? 40 : (self.player.isFullScreen ? 15 : 0);
    min_y = iPhoneX ? 44 : 20;
    min_w = 60.f;
    min_h = 44;
    self.leftButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = min_view_w - 60;
    min_y = iPhoneX ? 44 : 20;
    min_w = 60.f;
    min_h = 44;
    self.rightButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    ///底部的view布局
    min_x = 0;
    min_h = inputViewHeight;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.blackView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 15.0;
    min_h = 32.0;
    min_y = 8.f;
    min_w = min_view_w - min_x*2;
    self.textFiledView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 10.0;
    min_h = self.textFiledView.zf_height;
    min_y = 0;
    min_w = min_view_w - min_x*2;
    self.placeholder.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_w = min_view_w;
    min_h = 2.f;
    min_y = min_view_h - self.blackView.zf_height - min_h;
    self.sliderView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_h = bottomViewHeight;
    min_y = min_view_h - min_h - self.blackView.zf_height - self.sliderView.zf_height;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    ///描述信息
    min_x = 15.f;
    min_h = _contentHeight;
    min_y = bottomViewHeight - _contentHeight - contentBottomSpace;
    min_w = (ScreenW - 15.f - 80);
    self.detaiLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);

    ///昵称
    CGFloat nameMaxWidth = (ScreenW - 15.f - 80 - 10 - 60.f);
    min_x = _detaiLabel.zf_left;
    min_h = nameHeight;
    min_y = _detaiLabel.zf_top - nameHeight - nameContentSpace;
    min_w = _nameWidth < nameMaxWidth ? _nameWidth : nameMaxWidth;
    self.nameLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.nameLabel.zf_right + 10;
    min_h = self.nameLabel.zf_height;
    min_y = 36.f;
    min_w = _timeWidth;
    self.timeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.timeLabel.zf_centerY = self.nameLabel.zf_centerY;

    min_x = min_view_w - 54;
    min_h = buttonHeight;
    min_y = min_view_h - contentBottomSpace - buttonHeight - inputViewHeight;
    min_w = buttonWidth;
    self.shareButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.shareButton.left;
    min_h = buttonHeight;
    min_y = self.shareButton.zf_top - buttonHeight - 25.f;
    min_w = buttonWidth;
    self.commentButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.shareButton.left;
    min_h = buttonHeight;
    min_y = self.commentButton.zf_top - buttonHeight - 25.f;
    min_w = buttonWidth;
    self.likeButton.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = min_view_w - iconWidth - 15.f;
    min_w = iconWidth;
    min_h = iconWidth;
    min_y = self.likeButton.zf_top - min_h - 35.f;
    self.iconImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.iconImageView.zf_centerX = self.shareButton.zf_centerX;
        
    min_x = 0;
    min_y = 0;
    min_w = 20.f;
    min_h = 20.f;
    self.addImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.addImageView.zf_centerX = self.shareButton.zf_centerX;
    self.addImageView.zf_centerY = self.iconImageView.zf_bottom;
        
    min_w = 40;
    min_h = 40;
    self.playBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playBtn.center = self.center;
    
    [_likeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_commentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];

}

- (void)resetControlView {
    self.playBtn.hidden = YES;
    self.sliderView.value = 0;
    self.sliderView.bufferValue = 0;
}

- (void)prepareToRePlay {
    self.playBtn.hidden = NO;
    self.playBtn.selected = YES;
    self.sliderView.value = 0;
    self.sliderView.bufferValue = 0;
    [self.player.currentPlayerManager pause];
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.sliderView startAnimating];
    } else {
        [self.sliderView stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.sliderView.value = videoPlayer.progress;
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
        self.playBtn.hidden = NO;
        self.playBtn.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        [UIView animateWithDuration:0.2f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.playBtn.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        [self.player.currentPlayerManager play];
        self.playBtn.hidden = YES;
    }
    
    if (self.playBlock) {
        self.playBlock(self.playBtn.hidden);
    }
}

- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
}

- (void)showCoverViewWithUrl:(NSString *)coverUrl {
//    [self.player.currentPlayerManager.view.coverImageView setImageWithURLString:coverUrl placeholder:[UIImage imageNamed:@"img_video_loading"]];
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:[UIImage imageNamed:@"icon_play_cirle"] forState:UIControlStateSelected];
    }
    return _playBtn;
}

- (ZFSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZFSliderView alloc] init];
        _sliderView.maximumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.bufferTrackTintColor  = [UIColor clearColor];
        _sliderView.sliderHeight = 1;
        _sliderView.isHideSliderBlock = NO;
        _sliderView.userInteractionEnabled = NO;
    }
    return _sliderView;
}

/// 滑动中手势事件
- (void)gestureChangedPan:(ZFPlayerGestureControl *)gestureControl panDirection:(ZFPanDirection)direction panLocation:(ZFPanLocation)location withVelocity:(CGPoint)velocity {
    if (direction == ZFPanDirectionV) {
        if (location == ZFPanLocationRight) { /// 调节声音
             ///非全屏下手势处理 需要跟随手势的滑动 改变播放器的大小
             CGPoint point = [gestureControl.panGR translationInView:gestureControl.panGR.view];
             if (self.delegate && [self.delegate respondsToSelector:@selector(gesturePanChanged:)]) {
                 [self.delegate gesturePanChanged:point.y];
             }
         }
    }
}

#pragma mark -
#pragma mark - lazy loading

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:kNavBackWhiteShadowImg forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(handleLeftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"icon_post_detail_point"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(handleRightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
    }
    return _bottomToolView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:18];
        _nameLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.textColor = HEXCOLOR(0xffffff);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:15];
    }
    return _timeLabel;
}

- (YYLabel *)detaiLabel {
    if (!_detaiLabel) {
        _detaiLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColorFFF];
        _detaiLabel.numberOfLines = 3;
        _detaiLabel.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAllInfoEvent)];
        [_detaiLabel addGestureRecognizer:tap];
    }
    return _detaiLabel;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setTitle:@"0" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"icon_post_detail_video_comment"] forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"icon_post_detail_video_comment"] forState:UIControlStateSelected];
        _commentButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_commentButton addTarget:self action:@selector(handleCommentEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"icon_post_detail_video_share"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"icon_post_detail_video_share"] forState:UIControlStateSelected];
        [_shareButton setTitle:@"0" forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_shareButton addTarget:self action:@selector(handleShareEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView ) {
        _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = iconWidth/2.f;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 1.f;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIconActionEvent)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

///进入个人主页
- (void)handleIconActionEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeIcon);
    }
}

///关注
- (void)handleFollowActionEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeFollow);
    }
}

///评论
- (void)handleCommentEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeComment);
    }
}

///点赞
- (void)handleLikeEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeLike);
    }
}

///分享
- (void)handleShareEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeShare);
    }
}

- (void)handleAllInfoEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeAllInfo);
    }
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_post_video_add"]];
        _addImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFollowActionEvent)];
        [_addImageView addGestureRecognizer:tap];
    }
    return _addImageView;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setImage:[UIImage imageNamed:@"icon_post_detail_video_like_normal"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_post_detail_video_like_selected"] forState:UIControlStateSelected];
        [_likeButton setTitle:@"0" forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_likeButton addTarget:self action:@selector(handleLikeEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _likeButton;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = HEXCOLOR(0x141414);
    }
    return _blackView;
}

- (UIView *)textFiledView {
    if (!_textFiledView) {
        _textFiledView = [[UIView alloc] init];
        _textFiledView.backgroundColor = HEXCOLOR(0x353535);
        _textFiledView.layer.cornerRadius = 16.f;
        _textFiledView.layer.masksToBounds = YES;
//        _textFiledView.exclusiveTouch = YES;
        _textFiledView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fastComment)];
        [_textFiledView addGestureRecognizer:tap];
    }
    return _textFiledView;
}

- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" ...全文"];
    
    YYTextHighlight *hlText = [YYTextHighlight new];
    [hlText setColor:kColorFFF];
    @weakify(self);
    hlText.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        [self handleCommentEvent];
    };
    
    [text setColor:[UIColor colorWithHexString:@"408FFE"] range:[text.string rangeOfString:@"全文"]];
    [text setTextHighlight:hlText range:[text.string rangeOfString:@"全文"]];
    text.font = _detaiLabel.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _detaiLabel.truncationToken = truncationToken;
}

- (void)fastComment {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeFastComment);
    }
}

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.text = @"宝友，期待你的神评";
        _placeholder.font = [UIFont fontWithName:kFontNormal size:13];
        _placeholder.textColor = kColor999;
    }
    return _placeholder;
}


- (void)handleLeftButtonEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypeBack);
    }
}

- (void)handleRightButtonEvent {
    if (self.actionBlock) {
        self.actionBlock(JHFullScreenControlActionTypePop);
    }
}

@end
