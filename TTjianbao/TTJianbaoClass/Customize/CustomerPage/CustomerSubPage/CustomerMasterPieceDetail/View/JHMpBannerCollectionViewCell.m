//
//  JHMpBannerCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMpBannerCollectionViewCell.h"
//#import "JHGoodsDetailHeaderCycleView.h"
#import "JHGoodsDetailCustomizeHeaderCycleView.h"


@interface JHMpBannerCollectionViewCell ()
@property (nonatomic, strong) JHGoodsDetailCustomizeHeaderCycleView *cycleView; //轮播图
@end

@implementation JHMpBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _cycleView = [[JHGoodsDetailCustomizeHeaderCycleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kCycleViewH)];
    [self.contentView addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
//    /// 轮播图回调 <视频>
    @weakify(self);
//    _cycleView.hasVideoBlock = ^(CGoodsImgInfo * _Nonnull videoInfo, UITapImageView * _Nonnull videoContainer) {
//        @strongify(self);
//        if (self.bannerHasVideoBlock) {
//            self.bannerHasVideoBlock(videoInfo, videoContainer);
//        }
//    };
//
//    _cycleView.playClickBlock = ^{
//        @strongify(self);
//        if (self.bannerPlayClickBlock) {
//            self.bannerPlayClickBlock();
//        }
//    };
    
    _cycleView.cycleScrollEndDeceleratingBlock = ^(BOOL isVideoIndex) {
        @strongify(self);
        if (self.bannerCycleScrollEndDeceleratingBlock) {
            self.bannerCycleScrollEndDeceleratingBlock(isVideoIndex);
        }
    };
}

- (NSArray *)testArray {
    CGoodsImgInfo *info = [[CGoodsImgInfo alloc] init];
    info.orig_image = @"totalHeader_bg_179";
    return @[info];
}

- (void)setViewModel:(NSArray<NSString *> *)viewModel {
    if (viewModel.count == 0) {
        self.cycleView.headImgList = [self testArray];
        return;
    }
    NSArray<CGoodsImgInfo *> *array = [viewModel jh_map:^id _Nonnull(NSString * _Nonnull obj, NSUInteger idx) {
        CGoodsImgInfo *info = [[CGoodsImgInfo alloc] init];
        info.orig_image = obj;
        return info;
    }];
    self.cycleView.headImgList = array;
}

@end
