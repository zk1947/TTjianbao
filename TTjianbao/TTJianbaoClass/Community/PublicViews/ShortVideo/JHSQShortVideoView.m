//
//  JHSQShortVideoView.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQShortVideoView.h"
#import "TTjianbao.h"
#import "JHSQModel.h"
#import "JHSQManager.h"
#import "UITapImageView.h"

extern NSInteger const JHContainerVideoViewTag;

@interface JHSQShortVideoView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *playButton; //播放按钮
@property (nonatomic, strong) UIImageView *maskView; //底部阴影
@property (nonatomic, strong) UILabel *durLabel; //视频时长
@property (nonatomic, strong) UIButton *muteButton; //静音开关 默认静音
@end

@implementation JHSQShortVideoView

+ (CGFloat)viewHeight {
    return (ScreenW - 20);
//    return 214.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self configUI];
        
        @weakify(self);
        [[[JHNotificationCenter rac_addObserverForName:NSUserDefaultsDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.muteButton.selected = [JHSQManager isMute];
            });
        }];
    }
    return self;
}

- (void)configUI {
    CGFloat videoWidth = [[self class] viewHeight];

    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.sd_cornerRadius = @(8);
        [self addSubview:_contentView];
    }
    
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, videoWidth, videoWidth)];
        _videoImageView.backgroundColor = HEXCOLOR(0x1F1F1F);
        _videoImageView.clipsToBounds = YES;
        _videoImageView.sd_cornerRadius = @(8);
        _videoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentView addSubview:_videoImageView];
    }
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"sq_video_icon_play"] forState:UIControlStateNormal];
        _playButton.contentMode = UIViewContentModeScaleAspectFit;
        _playButton.tag = JHContainerVideoViewTag;
        _playButton.clipsToBounds = YES;
        _playButton.sd_cornerRadius = @(8);
        _playButton.userInteractionEnabled = NO;
        [_contentView addSubview:_playButton];
        
        @weakify(self);
        [[_playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.clickPlayBlock) {
                self.clickPlayBlock();
            }
        }];
    }
    
    if (!_maskView) {
        _maskView = [UIImageView new];
        _maskView.image = JHImageNamed(@"bg_video_bottom_back");
        [_contentView addSubview:_maskView];
    }
    
    if (!_durLabel) {
        _durLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:[UIColor whiteColor]];
        [_contentView addSubview:_durLabel];
    }
    
    //静音图标
    if (!_muteButton) {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteButton setImage:JHImageNamed(@"sq_video_icon_mute_on") forState:UIControlStateNormal];
        [_muteButton setImage:JHImageNamed(@"sq_video_icon_mute_off") forState:UIControlStateSelected];
        [_contentView addSubview:_muteButton];
        @weakify(self);
        [[_muteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            self.muteButton.selected = !self.muteButton.selected;
            [JHSQManager setMute:self.muteButton.selected];
        }];
    }
    
    //布局
    _contentView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 10)
    .widthIs(videoWidth).heightIs(videoWidth);
    
    _videoImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _playButton.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _maskView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(videoWidth - 34, 0, 0, 0));
    
    _durLabel.sd_layout
    .leftSpaceToView(_contentView, 10)
    .centerYEqualToView(_maskView)
    .heightIs(34);
    [_durLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _muteButton.sd_layout
    .rightSpaceToView(_contentView, 0)
    .centerYEqualToView(_maskView)
    .widthIs(35.0).heightIs(34);
}

- (void)setVideoInfo:(JHVideoInfo *)videoInfo {
    _videoInfo = videoInfo;
    @weakify(self);
    [_videoImageView jhSetImageWithURL:[NSURL URLWithString:videoInfo.image]
                           placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        @strongify(self);
        self.videoInfo.coverImage = image;
    } ];
    
    _durLabel.text = videoInfo.duration;
    _muteButton.selected = [JHSQManager isMute];
}


@end
