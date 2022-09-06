//
//  JHProcessPicOrVideoCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHProcessPicOrVideoCollectionViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@interface JHProcessPicOrVideoCollectionViewCell ()
@property (nonatomic, strong) UIImageView *playIconImageView;
@end

@implementation JHProcessPicOrVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _pictImageView     = [[UIImageView alloc] init];
    _pictImageView.layer.cornerRadius = 8.f;
    _pictImageView.layer.masksToBounds = YES;
    _pictImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_pictImageView];
    [_pictImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    _playIconImageView = [[UIImageView alloc] init];
    _playIconImageView.image = [UIImage imageNamed:@"icon_video_play"];
    _playIconImageView.hidden = YES;
    [self.contentView addSubview:_playIconImageView];
    [_playIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(24.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeCommentPublishImgList *model = [JHCustomizeCommentPublishImgList cast:viewModel];
    self.model = model;
    if (model.type == 0) {
        /// 图片
        [self.pictImageView jhSetImageWithURL:[NSURL URLWithString:model.url] placeholder:kDefaultCoverImage];
        self.playIconImageView.hidden = YES;
    } else {
        /// 视频
        [self.pictImageView jhSetImageWithURL:[NSURL URLWithString:model.coverUrl] placeholder:kDefaultCoverImage];
        self.playIconImageView.hidden = NO;
    }
}

@end
