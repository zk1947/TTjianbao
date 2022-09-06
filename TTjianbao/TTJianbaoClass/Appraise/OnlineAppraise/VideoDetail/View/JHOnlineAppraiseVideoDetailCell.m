//
//  JHOnlineAppraiseVideoDetailCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseVideoDetailCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYLabel+YDAdd.h"
#import "YYControl.h"
#import "UIButton+zan.h"
#import "JHPostDetailModel.h"
#import "UIView+JHGradient.h"
#import "JHPlaySliderView.h"
#import "JHVideoPlayerLoadingView.h"

#define iconWidth           44.f
#define buttonWidth         35.f
#define buttonHeight        50.f
#define inputViewHeight     (UI.bottomSafeAreaHeight + 46)

#define MAX_CONTENT_LINE    3
@interface JHOnlineAppraiseVideoDetailCell () <JHPlaySliderViewDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) YYLabel *detailLabel;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *textFiledView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, assign) CGFloat contentHeight;
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
/** 总时长*/
@property (nonatomic, assign) NSTimeInterval duringTime;

@end

@implementation JHOnlineAppraiseVideoDetailCell

//播放器交互事件
- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    self.centrPlayButton.hidden = isPlaying;
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
//播放
- (void)playButtonClickAction:(UIButton *)sender {
    if (self.playerStatusChangedBlock) {
        self.playerStatusChangedBlock(!self.centrPlayButton.hidden);
    }
}

- (void)setIsDragging:(BOOL)isDragging {
    _isDragging = isDragging;
    self.progressSlider.minimumTrackTintColor = isDragging ? HEXCOLORA(0xffffff, 1) : HEXCOLORA(0xffffff, 0.3);
    self.progressSlider.sliderHeight = isDragging ? 4 : 2;
    self.progressSlider.thumbSize = isDragging ? CGSizeMake(12, 12) : CGSizeMake(6, 6);
}

#pragma JHPlaySliderViewDelegate
- (void)sliderTapped:(float)value {
    if (self.seekToTimeIntervalBlock) {
        self.seekToTimeIntervalBlock(self.duringTime * value);
    }
}
- (void)sliderTouchBegan:(float)value {
    self.isDragging = YES;
}
- (void)sliderTouchEnded:(float)value {
    self.isDragging = NO;
    if (self.seekToTimeIntervalBlock) {
        self.seekToTimeIntervalBlock(self.duringTime * value);
    }
}

- (void)sliderValueChanged:(float)value {

}

//更新播放进度
- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime {
    if (self.isDragging) {
        return;
    }
    self.duringTime = totalTime;
    self.progressSlider.bufferValue = prePlayTime / totalTime;
    self.progressSlider.value = currentTime / totalTime;
}

- (void)refreshAnimation {
    
}

- (void)setShowFollowBtn:(BOOL)showFollowBtn {
    _showFollowBtn = showFollowBtn;
    _addImageView.hidden = showFollowBtn;
}
- (void)updateFollowStatus:(BOOL)isFollow {
    _addImageView.hidden = isFollow;
}

- (void)updateCommentInfo:(NSInteger)commentCount {
    [_commentButton setTitle:[NSString stringWithFormat:@"%@", commentCount > 0 ? @(commentCount).stringValue : @"评论"] forState:UIControlStateNormal];
}

- (void)updateLikeInfo:(NSInteger)likeCount isLike:(BOOL)isLike {
    [_likeButton setTitle:(likeCount > 0 ? @(likeCount).stringValue:@"赞") forState:UIControlStateNormal];
    _likeButton.selected = isLike;
    if (_likeButton.selected) {
        [_likeButton zanAnimation];
    }
}
- (void)setPostDetail:(JHPostDetailModel *)postDetail {
    if (!postDetail) {
        return;
    }
    _postDetail = postDetail;
    
    [self.coverImageView jhSetImageWithURL:[NSURL URLWithString:_postDetail.videoInfo.image] placeholder:kDefaultCoverImage];
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
//    postDetail.content
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:postDetail.content];
    NSDictionary *attrs = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13.]};
    [mutableString addAttributes:attrs range:NSMakeRange(0, [[mutableString string] length])];
    _detailLabel.attributedText = mutableString;

    [_commentButton setTitle:[NSString stringWithFormat:@"%@", postDetail.comment_num > 0 ? @(postDetail.comment_num).stringValue : @"评论"] forState:UIControlStateNormal];
    [_shareButton setTitle:(postDetail.share_num > 0 ? postDetail.shareString:@"分享") forState:UIControlStateNormal];
    [_likeButton setTitle:([postDetail.like_num integerValue] > 0?postDetail.like_num:@"赞") forState:UIControlStateNormal];
    _likeButton.selected = postDetail.is_like;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0x222222);
        _contentHeight = 0.f;
        [self initViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonClickAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)bottomGradientLayer {
    if (!_bottomGradientLayer) {
        _bottomGradientLayer = [[UIView alloc] init];
    }
    return _bottomGradientLayer;
}

- (void)initViews {
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.bottomGradientLayer];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.addImageView];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self addSeeMoreButton];
    
    ///输入框部分
    [self.contentView addSubview:self.blackView];
    [self.blackView addSubview:self.textFiledView];
    [self.textFiledView addSubview:self.placeholder];
    
    [self addSubview:self.progressSlider];
    [self addSubview:self.loadingView];
    [self addSubview:self.centrPlayButton];
    [self makeLayouts];
}

- (void)makeLayouts {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(inputViewHeight);
    }];

    [self.textFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackView).offset(15.);
        make.top.equalTo(self.blackView).offset(8.);
        make.right.equalTo(self.blackView).offset(-15);
        make.height.mas_equalTo(32.);
    }];
    
    [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFiledView).offset(10.);
        make.top.bottom.equalTo(self.textFiledView);
        make.right.equalTo(self.textFiledView).offset(-10.);
    }];
    
    
    [self.bottomGradientLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.blackView.mas_top);
        make.height.mas_equalTo(140.);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.);
        make.right.equalTo(self.contentView).offset(-15.);
        make.bottom.equalTo(self.blackView.mas_top).offset(-12.);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel);
        make.bottom.equalTo(self.detailLabel.mas_top).offset(-12.);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detailLabel.mas_top).offset(-35);
        make.right.equalTo(self.contentView).offset(-21.);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.shareButton.mas_top).offset(-12.);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.commentButton.mas_top).offset(-12.);
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareButton);
        make.bottom.equalTo(self.likeButton.mas_top).offset(-30.);
        make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
    }];
    
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.centerY.equalTo(self.iconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.blackView.mas_top).offset(9);
        make.height.mas_equalTo(20);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(140);
    }];
    
    [self.centrPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    

    [self layoutIfNeeded];
    [_likeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_commentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [_shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:4];
    [self.bottomGradientLayer jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000,0.f), HEXCOLORA(0x000000,0.5f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
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
        _detailLabel.numberOfLines = MAX_CONTENT_LINE;
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
        [_likeButton addTarget:self action:@selector(handleLikeEvent:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.text = @"宝友，期待你的神评";
        _placeholder.font = [UIFont fontWithName:kFontNormal size:13];
        _placeholder.textColor = kColor999;
    }
    return _placeholder;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageView;
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

- (JHVideoPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JHVideoPlayerLoadingView alloc] initWithFrame:CGRectMake((self.width - 140) / 2, (self.height - 140) / 2, 140, 140)];
        @weakify(self);
        [_loadingView setRetryCall:^{
            @strongify(self);
            if (self.playerStatusChangedBlock) {
                self.playerStatusChangedBlock(YES);
            }
        }];
    }
    return _loadingView;
}

- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" ...全文"];
    [text setColor:[UIColor colorWithHexString:@"408FFE"] range:[text.string rangeOfString:@"全文"]];
    [text setColor:[UIColor colorWithHexString:@"ffffff"] range:[text.string rangeOfString:@"..."]];
    text.font = _detailLabel.font;
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _detailLabel.truncationToken = truncationToken;
}

- (void)fastComment {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeFastComment);
    }
    //快速评论 埋点
    NSMutableDictionary *params = [self sa_getParams];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_makecomment_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

///进入个人主页
- (void)handleIconActionEvent {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeIcon);
    }
    
    NSMutableDictionary *params = [self sa_getParams];
    [JHAllStatistics jh_allStatisticsWithEventId:@"jdsphdHeadClick" params:params type:JHStatisticsTypeSensors];
}

///关注
- (void)handleFollowActionEvent {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeFollow);
    }
    NSMutableDictionary *params = [self sa_getParams];
    [JHAllStatistics jh_allStatisticsWithEventId:@"jdsphdAttention" params:params type:JHStatisticsTypeSensors];
    //关注 埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_follow_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

///评论
- (void)handleCommentEvent {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeComment);
    }
    NSMutableDictionary *params = [self sa_getParams];
    [JHAllStatistics jh_allStatisticsWithEventId:@"jdsphdComment" params:params type:JHStatisticsTypeSensors];
    //关注 埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_allcomment_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

///点赞
- (void)handleLikeEvent:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeLike);
    }
    
    NSMutableDictionary *params = [self sa_getParams];
    [params setValue:(sender.selected ? @"取消点赞" : @"点赞") forKey:@"operation_type"];
    if(self.indexPath) {
        [params setValue:OBJ_TO_STRING(@(self.indexPath.row)) forKey:@"page_position"];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"jdsphdLike" params:params type:JHStatisticsTypeSensors];
    //点赞 埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_like_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

///分享
- (void)handleShareEvent {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeShare);
    }
    //分享 埋点
    NSMutableDictionary *params = [self sa_getParams];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail__share_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

- (void)handleAllInfoEvent {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath.row, JHFullScreenControlActionTypeAllInfo);
    }
}

- (NSMutableDictionary *)sa_getParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postDetail.item_id forKey:@"vedio_id"];
    [params setValue:self.postDetail.content forKey:@"vedio_name"];
    [params setValue:@"onlineAppraise" forKey:@"from"];
    if([JHRootController isLogin]) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        [params setValue:user.name forKey:@"user_name"];
    }
    return params;
}

@end
