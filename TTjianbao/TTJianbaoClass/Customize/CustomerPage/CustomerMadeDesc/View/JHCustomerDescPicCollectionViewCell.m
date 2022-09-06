//
//  JHCustomerDescPicCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescPicCollectionViewCell.h"
//#import "JHGoodsDetailHeaderCycleView.h"
#import "JHGoodsDetailCustomizeHeaderCycleView.h"
#import "JHCustomerDescInProcessModel.h"
#import "JHCustomizeSwitch.h"


@interface JHCustomerDescPicCollectionViewCell ()
@property (nonatomic, strong) JHGoodsDetailCustomizeHeaderCycleView *cycleView; //轮播图
@property (nonatomic, strong) UIImageView *completeLogoImageView; // 完成logo
//@property (nonatomic, strong) UIButton *stuffBtn; // 原料信息

@property (nonatomic, strong) CGoodsImgInfo *videoInfo;
@property (nonatomic, strong) UITapImageView *videoContainer;
@property (nonatomic, strong) JHCustomizeSwitch *stuffSwitch;
@end

@implementation JHCustomerDescPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _cycleView = [[JHGoodsDetailCustomizeHeaderCycleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    [self.contentView addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    /// 轮播图回调 <视频>
    @weakify(self);
    _cycleView.hasVideoBlock = ^(CGoodsImgInfo * _Nonnull videoInfo, UITapImageView * _Nonnull videoContainer) {
        @strongify(self);
        self.videoInfo = videoInfo;
        self.videoContainer = videoContainer;
        
        if (self.bannerHasVideoBlock) {
            self.bannerHasVideoBlock(videoInfo, videoContainer);
        }
    };
    
    _cycleView.playClickBlock = ^{
        @strongify(self);
        if (self.bannerPlayClickBlock) {
            self.bannerPlayClickBlock();
        }
    };
    
    _cycleView.cycleScrollEndDeceleratingBlock = ^(BOOL isVideoIndex) {
        @strongify(self);
        if (self.bannerCycleScrollEndDeceleratingBlock) {
            self.bannerCycleScrollEndDeceleratingBlock(isVideoIndex);
        }
    };
    
    _completeLogoImageView = [[UIImageView alloc] init];
    _completeLogoImageView.image = [UIImage imageNamed:@"customize_detail_completelogo"];
    _completeLogoImageView.hidden = YES;
    [self.contentView addSubview:_completeLogoImageView];
    [_completeLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(103.f);
        make.width.height.mas_equalTo(60.f);
    }];
    
//    _stuffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _stuffBtn.backgroundColor = HEXCOLORA(0x000000, 0.4f);
//    _stuffBtn.layer.cornerRadius = 15.f;
//    _stuffBtn.layer.masksToBounds = YES;
//    _stuffBtn.selected = NO;
//    [_stuffBtn setTitle:@"原料信息" forState:UIControlStateNormal];
//    [_stuffBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//    _stuffBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:15.f];
//    _stuffBtn.hidden = YES;
//    [_stuffBtn addTarget:self action:@selector(stuffBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_stuffBtn];
//    [_stuffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(-15.f);
//        make.top.equalTo(self.completeLogoImageView.mas_top);
//        make.width.mas_equalTo(105.f);
//        make.height.mas_equalTo(31.f);
//    }];
    
    
    _stuffSwitch =  [[JHCustomizeSwitch alloc] initWithFrame:CGRectMake(0, 0, 140.f, 30.f)];
    [self.contentView addSubview:_stuffSwitch];
    [_stuffSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset((44.f)/2.f-15.f + UI.statusBarHeight);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(140.f);
        make.height.mas_equalTo(30.f);
    }];
    [_stuffSwitch setSwitchState:YES animation:NO];
//    @weakify(self);
    _stuffSwitch.block = ^(BOOL state) {
        @strongify(self);
        /// NO 是原料， YES 是成品
        if (!state) {
            [self setCompleteLogoHidden:NO];
        } else {
            [self setCompleteLogoHidden:YES];
        }
        if (self.stuffBtnActionBlock) {
            self.stuffBtnActionBlock(!state);
        }
    };
}

- (void)setIsPlayEnd:(BOOL)isPlayEnd {
    _cycleView.isPlayEnd = isPlayEnd;
}


//- (void)stuffBtnAction {
//    self.stuffBtn.selected = !self.stuffBtn.selected;
//    if (!self.stuffBtn.selected) {
//        [self setCompleteLogoHidden:NO];
//        [self.stuffBtn setTitle:@"原料信息" forState:UIControlStateNormal];
//    } else {
//        [self setCompleteLogoHidden:YES];
//        [self.stuffBtn setTitle:@"成品信息" forState:UIControlStateNormal];
//    }
//    if (self.stuffBtnActionBlock) {
//        self.stuffBtnActionBlock(self.stuffBtn.selected);
//    }
//}

- (void)setViewModel:(id)viewModel {
    NSDictionary *dict = [NSDictionary cast:viewModel];
    if (!dict) {
        return;
    }
    
    NSArray<JHAttachmentVOModel *> *images = [NSArray cast: dict[@"images"]];
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
    }
    if ([dict[@"isChange"] boolValue] == NO) {
        if ([dict[@"completeStatus"] integerValue] == 2) {
            self.completeLogoImageView.hidden = NO;
            self.stuffSwitch.hidden = NO;
        } else {
            self.completeLogoImageView.hidden = YES;
            self.stuffSwitch.hidden = YES;
        }
    } else {
        if ([dict[@"completeStatus"] integerValue] == 2) {
            self.completeLogoImageView.hidden = NO;
            self.stuffSwitch.hidden = NO;
        } else {
            self.completeLogoImageView.hidden = YES;
            self.stuffSwitch.hidden = NO;
        }
    }
}

- (void)setCompleteLogoHidden:(BOOL)isComplete {
    self.completeLogoImageView.hidden = !isComplete;
}

@end
