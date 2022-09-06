//
//  JHBrowserCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBrowserCell.h"
#import "SDWebImageDownloader.h"
@interface JHBrowserCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *playButton;

@end
@implementation JHBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)setupData {
    if (self.model == nil) return;
    if (self.model.image) {
        self.imageView.image = self.model.image;
    }else {
        if ([self.model.thumbImageUrl hasPrefix:@"http"]) {
            NSURL *url = [NSURL URLWithString:self.model.thumbImageUrl];
            @weakify(self)
            [self.imageView jhSetImageWithURL:url placeholder:[UIImage imageNamed:@"IM_placeholder_icon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                @strongify(self)
                if (self.model.imageUrl.length>0) {
                    [self setOriginalImage:self.model.imageUrl];
                }
            }];
        }else {
            if (self.model.imageUrl) {
                NSURL *url = [NSURL fileURLWithPath:self.model.imageUrl];
                [self.imageView jhSetImageWithURL:url placeholder:[UIImage imageWithContentsOfFile:self.model.thumbImageUrl]];
            }else if (self.model.thumbImageUrl) {
                NSURL *url = [NSURL fileURLWithPath:self.model.thumbImageUrl];
                [self.imageView jhSetImageWithURL:url placeholder:[UIImage imageNamed:@"IM_placeholder_icon"]];
            }
        }
        
    }
    
     self.playButton.hidden = self.model.mediaUrl == nil;
}
- (void)setOriginalImage : (NSString *)imageUrl {
    NSURL *url = [NSURL URLWithString: imageUrl];
    @weakify(self)
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            self.imageView.image = image;
        });
    }];
}
- (void)didClickPlay : (UIButton *)sender {
    
}
#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.playButton];
}
- (void)layoutViews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}
- (void)setModel:(JHBrowserModel *)model {
    _model = model;
    [self setupData];
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = HEXCOLOR(0x000000);
        _imageView.image = [UIImage imageNamed:@"IM_placeholder_icon"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.jh_imageName(@"newStore_play_icon")
        .jh_action(self, @selector(didClickPlay:));
        _playButton.userInteractionEnabled = false;
        _playButton.hidden = true;
    }
    return _playButton;
}
@end
