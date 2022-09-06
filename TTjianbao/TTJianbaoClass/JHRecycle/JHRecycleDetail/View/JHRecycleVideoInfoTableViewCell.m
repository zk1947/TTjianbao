//
//  JHRecycleVideoInfoTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleVideoInfoTableViewCell.h"
#import "JHRecycleDetailModel.h"
#import "JHVideoCropManager.h"
#import "UIImageView+WebCache.h"

@interface JHRecycleVideoInfoTableViewCell ()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation JHRecycleVideoInfoTableViewCell

- (void)setupViews{
    [self.backView addSubview:self.videoView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(5);
        make.bottom.equalTo(self.backView).offset(-10);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
        make.height.mas_equalTo((kScreenWidth-24)*9/16);//视频大小比例16:9
    }];
    
    [self.videoView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(self.videoView);
    }];
    
}


- (void)playClick {
    if (self.playCallback) {
        self.playCallback(self);
    }
}

- (void)bindViewModel:(id)dataModel{
    JHRecycleDetailProductDetailUrlsModel *productUrlModel = dataModel;
    self.videoUrl = productUrlModel.detailVideoUrl;

    [self.videoView sd_setImageWithURL:[NSURL URLWithString:productUrlModel.detailVideoCoverUrl]];
}

- (UIImageView *)videoView{
    if (!_videoView) {
        _videoView = [[UIImageView alloc] init];
        _videoView.backgroundColor = UIColor.blackColor;
        _videoView.userInteractionEnabled = YES;
        _videoView.contentMode = UIViewContentModeScaleAspectFit;
        _videoView.layer.cornerRadius = 4;
        _videoView.layer.masksToBounds = YES;
    }
    return _videoView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {//icon_play_cirle
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setBackgroundImage:JHImageNamed(@"recycle_video_icon") forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


@end
