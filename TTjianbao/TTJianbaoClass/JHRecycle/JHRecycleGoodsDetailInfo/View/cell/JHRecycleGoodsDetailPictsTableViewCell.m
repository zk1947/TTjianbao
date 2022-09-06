//
//  JHRecycleGoodsDetailPictsTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailPictsTableViewCell.h"
#import "JHGoodsDetailCustomizeHeaderCycleView.h"
#import "CGoodsDetailModel.h"
#import "JHRecycleGoodsInfoModel.h"
#import "JHCustomerDescInProcessModel.h"

@interface JHRecycleGoodsDetailPictsTableViewCell ()
@property (nonatomic, strong) JHGoodsDetailCustomizeHeaderCycleView *cycleView;//轮播图
@property (nonatomic, strong) CGoodsImgInfo                         *videoInfo;
@end

@implementation JHRecycleGoodsDetailPictsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _cycleView = [[JHGoodsDetailCustomizeHeaderCycleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _cycleView.noNeedAspectFill = YES;
    [self.contentView addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    @weakify(self);
    _cycleView.cycleScrollEndDeceleratingBlock = ^(BOOL isVideoIndex) {
        @strongify(self);
        if (self.bannerCycleScrollEndDeceleratingBlock) {
            self.bannerCycleScrollEndDeceleratingBlock(isVideoIndex);
        }
    };
}

- (void)setIsPlayEnd:(BOOL)isPlayEnd {
    _cycleView.isPlayEnd = isPlayEnd;
}

- (void)setViewModel:(id)viewModel {
    NSArray<JHRecycleDetailInfoProductImgUrlsModel *> *productImgUrls = viewModel;
    NSArray<JHAttachmentVOModel *> *images = [productImgUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductImgUrlsModel * _Nonnull obj, NSUInteger idx) {
        JHAttachmentVOModel *voModel = [[JHAttachmentVOModel alloc] init];
        voModel.type = 0;
        voModel.url = obj.productImage.medium;
        return voModel;
    }];
    
    self.cycleView.headImgList = nil;
    if (images && images.count >0) {
        NSArray<CGoodsImgInfo *> *arr = (NSArray<CGoodsImgInfo *> *)[images jh_map:^id _Nonnull(JHAttachmentVOModel *_Nonnull model, NSUInteger idx) {
            CGoodsImgInfo *info = [[CGoodsImgInfo alloc] init];
            if (model.type == 0) { /// 图片
                info.url       = model.url;
            } else {
                info.url       = model.coverUrl;
                info.video_url = model.url;
            }
            info.type      = model.type;
            return info;
        }];
        self.cycleView.headImgList = arr;
        self.cycleView.canLookOriginImg = YES;
        self.cycleView.originArr = [productImgUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductImgUrlsModel * _Nonnull obj, NSUInteger idx) {
            return obj.productImage.origin;
        }];
        self.cycleView.mediumArr = [productImgUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductImgUrlsModel * _Nonnull obj, NSUInteger idx) {
            return obj.productImage.medium;
        }];
    }
}


@end
