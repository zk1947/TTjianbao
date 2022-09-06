//
//  JHBuyAppraiseVideoTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseVideoTableViewCell.h"
#import "JHVideoPlayerLoadingView.h"
#import "JHPlaySliderView.h"
#import "JHGradientView.h"
#import "JHBuyAppraiseModel.h"
#import "UIImageView+WebCache.h"

@interface JHBuyAppraiseVideoTableViewCell () <JHPlaySliderViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
/** 进度条*/
@property (nonatomic, strong) JHPlaySliderView *progressSlider;
/** 滑块正在进行中*/
@property (nonatomic, assign) BOOL isDragging;
/** 总时长*/
@property (nonatomic, assign) NSTimeInterval duringTime;
/** 加载框*/
@property (nonatomic, strong) JHVideoPlayerLoadingView *loadingView;
@end

@implementation JHBuyAppraiseVideoTableViewCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥", __func__);
}

- (void)setVideoModel:(JHBuyAppraiseModel *)videoModel {
    if (!videoModel) {
        return;
    }
    
    _videoModel = videoModel;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.videoUrl] placeholderImage:kDefaultCoverImage];
    _nameLabel.text = [_videoModel.appraiser.appraiserName isNotBlank] ? _videoModel.appraiser.appraiserName : @"暂无昵称";
    NSTimeInterval timeInterval = [self.videoModel.datetime integerValue];
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSString *dateStr = [formatter stringFromDate:datenow];
    _timeLabel.text = [NSString stringWithFormat:@" · %@",dateStr];
    _contentLabel.text = [videoModel.appraiseDesc isNotBlank] ? videoModel.appraiseDesc : @"";
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        self.contentView.backgroundColor = HEXCOLOR(0x222222);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonClickAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)initViews {
    _coverImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_coverImageView];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    JHGradientView *bottomBgView = [[JHGradientView alloc] init];
    [bottomBgView setGradientColor:@[(__bridge id)RGBA(0,0,0,0.0).CGColor,(__bridge id)RGBA(0,0,0,0.5).CGColor] orientation:JHGradientOrientationVertical];
    [self.contentView addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
    }];

    //滑动条
    [bottomBgView addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBgView).offset(10);
        make.right.equalTo(bottomBgView).offset(-10);
        make.bottom.equalTo(bottomBgView.mas_bottom).offset(- UI.bottomSafeAreaHeight - 10);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *descabel = [UILabel jh_labelWithText:self.videoModel.appraiseDesc font:13 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:bottomBgView];
    descabel.numberOfLines = 3;
    _contentLabel = descabel;
    [self.contentView addSubview:descabel];
    [descabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBgView).offset(10);
        make.bottom.equalTo(self.progressSlider.mas_top).offset(- 10);
        make.right.equalTo(bottomBgView).offset(-10);
    }];

    UILabel *nameLabel = [UILabel jh_labelWithText:self.videoModel.appraiser.appraiserName font:16 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:bottomBgView];
    self.nameLabel = nameLabel;
//    [bottomBgView addSubview:self.nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBgView).offset(10);
        make.bottom.equalTo(descabel.mas_top).offset(-10);
        make.top.mas_equalTo(bottomBgView.mas_top);
    }];

    UILabel *timeLabel = [UILabel jh_labelWithText:@"" font:14 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:bottomBgView];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right);
        make.centerY.equalTo(nameLabel.mas_centerY);
    }];

    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(140);
    }];

    [self.contentView addSubview:self.centrPlayButton];
    [self.centrPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
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
    if (self.sliderBlock) {
        self.sliderBlock(self.duringTime * value);
    }
}
- (void)sliderTouchBegan:(float)value {
    self.isDragging = YES;
}
- (void)sliderTouchEnded:(float)value {
    self.isDragging = NO;
    if (self.sliderBlock) {
        self.sliderBlock(self.duringTime * value);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
