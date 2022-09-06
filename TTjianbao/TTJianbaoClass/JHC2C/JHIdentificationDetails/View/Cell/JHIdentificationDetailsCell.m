//
//  JHIdentificationDetailsCell.m
//  TTjianbao
//
//  Created by miao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsCell.h"
#import "JHIdentificationDetailsModel.h"

@interface JHIdentificationDetailsCell ()

/// 点击播放视频
@property (nonatomic, strong) UIImageView *playImage;

@end

@implementation JHIdentificationDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self p_drawSubViews];
        [self p_makeLayouts];
    }
    return self;
}

- (void)p_drawSubViews {
    
    _videoView = [[UIImageView alloc] init];
    _videoView.userInteractionEnabled = YES;
    _videoView.contentMode = UIViewContentModeScaleAspectFill;
    _videoView.layer.cornerRadius = 4;
    _videoView.layer.masksToBounds = YES;
    _videoView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_videoView];
    
    _playImage = [[UIImageView alloc] init];
    _playImage.image = JHImageNamed(@"recycle_video_icon");
    [_videoView addSubview:_playImage];
    
}

- (void)p_makeLayouts {
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.bottom.equalTo(self.contentView).offset(-3);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(self.videoView);
    }];
}

-(void)setDetailOrVideoModel:(JHIdentDetailImageOrVideoModel *)detailOrVideoModel {
    
    [_videoView jhSetImageWithURL:[NSURL URLWithString:detailOrVideoModel.showImageUrl]
                              placeholder:kDefaultNewStoreCoverImage];
    [self.playImage setHidden:!detailOrVideoModel.isVideo];
    self.videoUrl = detailOrVideoModel.url;
}

@end
