//
//  JHPlayerVerticalBigView.m
//  TTJB
//
//  Created by 王记伟 on 2021/1/6.
//

#import "JHPlayerVerticalBigView.h"
#import "JHPlaySliderView.h"
#import "JHPostDetailModel.h"
#import "UIView+JHGradient.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHBaseOperationAction.h"
#import "JHVideoPlayerLoadingView.h"


@interface JHPlayerVerticalBigView()<JHPlaySliderViewDelegate>

{
    CGPoint gestureStartPoint;
}
/** 顶部交互视图*/
@property (nonatomic, strong) UIView *topBarView;
/** 返回按钮*/
@property (nonatomic, strong) UIButton *backButton;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 加号按钮*/
@property (nonatomic, strong) UIImageView *addImageView;
/** 点赞按钮*/
@property (nonatomic, strong) UIButton *likeButton;
/** 评论按钮*/
@property (nonatomic, strong) UIButton *commentButton;
/** 分享按钮*/
@property (nonatomic, strong) UIButton *shareButton;
/** 作者名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 详情文本*/
@property (nonatomic, strong) YYLabel *detailLabel;
/** 底部view*/
@property (nonatomic, strong) UIView *blackView;
/** 评论输入框*/
@property (nonatomic, strong) UIView *textFiledView;
/** 评论输入占位图*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/** 底部渐变部分*/
@property (nonatomic, strong) UIView *bottomGradientLayer;
/** 进度条*/
@property (nonatomic, strong) JHPlaySliderView *progressSlider;
/** 滑块正在进行中*/
@property (nonatomic, assign) BOOL isDragging;
/** 总时长*/
@property (nonatomic, assign) NSTimeInterval totalTime;
/** 中间的播放暂停键*/
@property (nonatomic, strong) UIButton *centrPlayButton;
/** 加载框*/
@property (nonatomic, strong) JHVideoPlayerLoadingView *loadingView;
@end

@implementation JHPlayerVerticalBigView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonClickAction:)];
        [self addGestureRecognizer:tap];
        [self configUI];
    }
    return self;
}

- (void)setPostDetail:(JHPostDetailModel *)postDetail {
    _postDetail = postDetail;
//
    [self.iconImageView jh_setImageWithUrl:postDetail.publisher.avatar];
    if (postDetail.is_self) {
        self.addImageView.hidden = YES;
    }
    else {
        self.addImageView.hidden = postDetail.publisher.is_follow;
    }

    NSString *name = [NSString stringWithFormat:@"%@ · %@", ([postDetail.publisher.user_name isNotBlank]?postDetail.publisher.user_name:@""), postDetail.publish_time];
    NSMutableAttributedString *nameAttri = [[NSMutableAttributedString alloc] initWithString:name];
    [nameAttri addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.], NSForegroundColorAttributeName:kColorFFF} range:NSMakeRange(0, name.length)];
    [nameAttri addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:16.], NSForegroundColorAttributeName:kColorFFF} range:NSMakeRange(0, postDetail.publisher.user_name.length)];
    _nameLabel.attributedText = nameAttri;

    NSMutableAttributedString *contentAttri = [[NSMutableAttributedString alloc] initWithString:postDetail.content];
    [contentAttri addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13.], NSForegroundColorAttributeName:kColorFFF} range:NSMakeRange(0, postDetail.content.length)];
    _detailLabel.attributedText = contentAttri;

    [_commentButton setTitle:[NSString stringWithFormat:@"%@", postDetail.comment_num > 0 ? @(postDetail.comment_num).stringValue : @"评论"] forState:UIControlStateNormal];
    [_shareButton setTitle:(postDetail.share_num > 0 ? postDetail.shareString:@"分享") forState:UIControlStateNormal];
    [_likeButton setTitle:([postDetail.like_num integerValue] > 0?postDetail.like_num:@"赞") forState:UIControlStateNormal];
    _likeButton.selected = postDetail.is_like;

}

- (void)setPlay:(BOOL)play {
    [super setPlay:play];
    self.centrPlayButton.hidden = play;
}

// 快速评论
- (void)fastComment {
    [self handleClickAction:JHFullScreenControlActionTypeFastComment];
}

///进入个人主页
- (void)handleIconActionEvent {
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:NO];
    }
    [self handleClickAction:JHFullScreenControlActionTypeIcon];
}

///关注
- (void)handleFollowActionEvent {
    [self handleClickAction:JHFullScreenControlActionTypeFollow];
}

///评论
- (void)handleCommentEvent {
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:NO];
    }
    [self handleClickAction:JHFullScreenControlActionTypeComment];
}

///点赞
- (void)handleLikeEvent {
    [self handleClickAction:JHFullScreenControlActionTypeLike];
}

///分享
- (void)handleShareEvent {
    [self handleClickAction:JHFullScreenControlActionTypeShare];
}

- (void)handleAllInfoEvent {
    [self handleClickAction:JHFullScreenControlActionTypeAllInfo];
}

// 页面点击事件从这里统一传回到上一级
- (void)handleClickAction:(JHFullScreenControlActionType)actionType {
    // 响应跳转事件
    if (self.actionBlock) {
        self.actionBlock(actionType);
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime{
    if (self.isDragging) {
        return;
    }
    self.totalTime = totalTime;
    self.progressSlider.bufferValue = prePlayTime / totalTime;
    self.progressSlider.value = currentTime / totalTime;
}
// 转时间格式
- (NSString *)transformValueToTime:(NSTimeInterval)timeInterval {
    int minute = (int)timeInterval / 60;
    int second = (int)timeInterval % 60;
    return [NSString stringWithFormat:@"%02i:%02i", minute, second];
}

//全屏返回按钮
- (void)backButtonClickAction{
    if ([self.delegate respondsToSelector:@selector(controlView:fullScreen:)]) {
        [self.delegate controlView:self fullScreen:NO];
    }
}

// 播放/暂停
- (void)playButtonClickAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(controlView:playStatus:)]) {
        [self.delegate controlView:self playStatus:!self.centrPlayButton.hidden];
    }
}

- (void)startLoading {
    [self.loadingView startLoading];
}

- (void)stopLoading {
    [self.loadingView stopLoading];
}

- (void)showRetry {
    [self.loadingView showRetry];
}

- (void)setIsDragging:(BOOL)isDragging {
    _isDragging = isDragging;
    self.progressSlider.minimumTrackTintColor = isDragging ? HEXCOLORA(0xffffff, 1) : HEXCOLORA(0xffffff, 0.3);
    self.progressSlider.sliderHeight = isDragging ? 4 : 2;
    self.progressSlider.thumbSize = isDragging ? CGSizeMake(12, 12) : CGSizeMake(6, 6);
}
#pragma JHPlaySliderViewDelegate
- (void)sliderTapped:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:changeProgress:)]) {
        [self.delegate controlView:self changeProgress:value];
    }
}
- (void)sliderTouchBegan:(float)value {
    self.isDragging = YES;
}
- (void)sliderTouchEnded:(float)value {
    self.isDragging = NO;
    if ([self.delegate respondsToSelector:@selector(controlView:changeProgress:)]) {
        [self.delegate controlView:self changeProgress:value];
    }
}

- (void)setCompleteView:(UIView *)completeView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.centrPlayButton.hidden = YES;
    });
    completeView.frame = self.bounds;
    [self insertSubview:completeView belowSubview:self.topBarView];
}


- (void)configUI {
    
    [self addSubview:self.loadingView];
    [self addSubview:self.centrPlayButton];
    ///顶部菜单
    [self addSubview:self.topBarView];
    [self.topBarView addSubview:self.backButton];
    ///输入框部分
    [self addSubview:self.blackView];
    [self.blackView addSubview:self.textFiledView];
    [self.textFiledView addSubview:self.placeholderLabel];
    [self addSubview:self.bottomGradientLayer];
    [self addSubview:self.iconImageView];
    [self addSubview:self.addImageView];
    [self addSubview:self.likeButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.progressSlider];
    [self addSeeMoreButton];
    
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(140);
    }];
    
    [self.centrPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(UI.topSafeAreaHeight + 20);
        make.height.mas_equalTo(44);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBarView.mas_left).offset(10);
        make.top.bottom.mas_equalTo(self.topBarView);
        make.width.mas_equalTo(40);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(46);
    }];

    [self.textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackView).offset(15.);
        make.top.equalTo(self.blackView).offset(8.);
        make.right.equalTo(self.blackView).offset(-15);
        make.height.mas_equalTo(32.);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFiledView).offset(10.);
        make.top.bottom.equalTo(self.textFiledView);
        make.right.equalTo(self.textFiledView).offset(-10.);
    }];
    
    [self.bottomGradientLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.blackView.mas_top);
        make.height.mas_equalTo(140.);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.);
        make.right.equalTo(self).offset(-15.);
        make.bottom.equalTo(self.blackView.mas_top).offset(-12.);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel);
        make.bottom.equalTo(self.detailLabel.mas_top).offset(-12.);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detailLabel.mas_top).offset(-35);
        make.right.equalTo(self).offset(-21.);
        make.size.mas_equalTo(CGSizeMake(35.f, 50.f));
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.shareButton.mas_top).offset(-12.);
        make.size.mas_equalTo(CGSizeMake(35.f, 50.f));
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.commentButton.mas_top).offset(-12.);
        make.size.mas_equalTo(CGSizeMake(35.f, 50.f));
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.likeButton.mas_top).offset(-30.);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.centerY.equalTo(self.iconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.blackView.mas_top).offset(9);
        make.height.mas_equalTo(20);
    }];
    
    [self layoutIfNeeded];
    [_likeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_commentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [self.bottomGradientLayer jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000,0.f), HEXCOLORA(0x000000,0.5f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
}

- (UIView *)topBarView{
    if (_topBarView == nil) {
        _topBarView = [[UIView alloc] init];
        _topBarView.hidden = NO;
    }
    return _topBarView;
}

- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"navi_icon_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
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
        _textFiledView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fastComment)];
        [_textFiledView addGestureRecognizer:tap];
    }
    return _textFiledView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.text = @"宝友，期待你的神评";
        _placeholderLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _placeholderLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _placeholderLabel;
}

- (UIView *)bottomGradientLayer {
    if (!_bottomGradientLayer) {
        _bottomGradientLayer = [[UIView alloc] init];
    }
    return _bottomGradientLayer;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"石头大神 · 1天前";
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:18];
        _nameLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _nameLabel;
}

- (YYLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:kColorFFF];
        _detailLabel.numberOfLines = 3;
        _detailLabel.text = @"--";
        _detailLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
        _detailLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAllInfoEvent)];
        [_detailLabel addGestureRecognizer:tap];
    }
    return _detailLabel;
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
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.cornerRadius = 44 / 2.f;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderWidth = 1.f;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIconActionEvent)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
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

- (JHPlaySliderView *)progressSlider {
    if (_progressSlider == nil) {
        _progressSlider = [[JHPlaySliderView alloc] init];
        _progressSlider.maximumTrackTintColor = HEXCOLOR(0x505050);
        _progressSlider.minimumTrackTintColor = HEXCOLORA(0xffffff, 0.6);
        _progressSlider.bufferTrackTintColor  = [UIColor clearColor];
        _progressSlider.sliderHeight = 2.;
        _progressSlider.value = 0;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_post_detail_track"] forState:UIControlStateNormal];
        _progressSlider.thumbSize = CGSizeMake(6, 6);
        _progressSlider.delegate = self;
    }
    return _progressSlider;
}

- (UIButton *)centrPlayButton {
    if (_centrPlayButton == nil) {
        _centrPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centrPlayButton setImage:[UIImage imageNamed:@"appraisal_home_play"] forState:UIControlStateNormal];
        _centrPlayButton.hidden = YES;
        [_centrPlayButton addTarget:self action:@selector(playButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centrPlayButton;
}


- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" ...全文"];
    [text setColor:[UIColor colorWithHexString:@"408FFE"] range:[text.string rangeOfString:@"全文"]];
    [text setColor:[UIColor colorWithHexString:@"ffffff"] range:[text.string rangeOfString:@"..."]];
    text.font = _detailLabel.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    seeMore.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClickAction)];
    [seeMore addGestureRecognizer:tapGesture];
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _detailLabel.truncationToken = truncationToken;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    gestureStartPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    CGFloat deltaX = (gestureStartPoint.x - currentPosition.x);
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    float MINDISTANCE = sqrt(deltaX * deltaX + deltaY * deltaY)/2;
    //上下滑动
    if(fabs(deltaY) > fabs(deltaX))
    {
        //向上滑动
        if (deltaY > MINDISTANCE && deltaY > 50)   //有效滑动距离 MINDISTANCE
        {
            [self backButtonClickAction];
        }
    }
}
@end
