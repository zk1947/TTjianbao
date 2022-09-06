//
//  JHStoreDetailPriceCell.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailPriceCell.h"

#import "JHStoreDetailNewUserView.h"
#import "JHStoreDetailNormalView.h"
#import "JHStoreDetailPriceHotView.h"
#import "JHStoreDetailPricePreview.h"
#import "JHStoreDetailPriceView.h"
#import "JHStoreAutionPriceView.h"


@interface JHStoreDetailPriceCell()
/// 价格
@property (nonatomic, strong) JHStoreDetailPriceView *priceView;
/// 正常售价
@property (nonatomic, strong) JHStoreDetailNormalView *normalView;
/// 热卖
@property (nonatomic, strong) JHStoreDetailPriceHotView *hotView;
/// 预告
@property (nonatomic, strong) JHStoreDetailPricePreview *preview;
/// 新人
@property (nonatomic, strong) JHStoreDetailNewUserView *newestUserView;

/// 拍卖
@property (nonatomic, strong) JHStoreAutionPriceView *autionView;


@end
@implementation JHStoreDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    RAC(self.priceView.salePriceLabel, attributedText) = [RACObserve(self.viewModel, salePriceText)
                                                          takeUntil:self.rac_prepareForReuseSignal];

    RAC(self.priceView.priceLabel, attributedText) = [RACObserve(self.viewModel, priceText)
                                                      takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceView.saleLabel, text) = [RACObserve(self.viewModel, saleText)
                                           takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self)
    [[RACObserve(self.viewModel, type)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        NSInteger type = [x integerValue];
        switch (type) {
            case HotSale: // 热卖
                [self layoutHotSaleViews];
                [self bindHotData];
                break;
            case Preview: // 预告
                [self layoutPreviewViews];
                [self bindPreviewData];
                break;
            case NewUser: // 新人
                [self layoutNewUserViews];
                [self bindNewData];
                break;
                
            case Auction: // 拍卖
                [self layoutAuctionViews];
                [self bindAuctionData];
                break;
            case RushPurChase: // 拍卖
            {
                [self layoutHotSaleViews];
                [self bindHotData];
            }
                break;
            default: // 正常
                [self layoutNomalViews];
                break;
        }
        
    }];
}

- (void) bindAuctionData {
    
    RAC(self.autionView.countdownView, timeStamp) = [RACObserve(self.viewModel, countdownTime)
                                                  takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.autionView.noticeLbl, text) = [RACObserve(self.viewModel, remindCount)
                                          takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.autionView, auStarStr) = [RACObserve(self.viewModel, auStartTime)
                                          takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self);
    [[RACObserve(self.viewModel, auctionStatus)
         takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        StoreDetailAuctionStatus status = [x integerValue];
        [self.autionView changeAuctionStatus:status];
    }];

}

- (void) bindHotData {
    RAC(self.hotView.countdownView, timeStamp) = [RACObserve(self.viewModel, countdownTime)
                                                  takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.hotView.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                          takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.hotView.detailLabel, text) = [RACObserve(self.viewModel, detailText)
                                          takeUntil:self.rac_prepareForReuseSignal];
}
- (void) bindPreviewData {
    RAC(self.preview.dateLabel, text) = [RACObserve(self.viewModel, previewSaleDateText)
                                         takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.preview.numLabel, text) = [RACObserve(self.viewModel, previewNumText)
                                        takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.preview.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                          takeUntil:self.rac_prepareForReuseSignal];
}
- (void) bindNewData {
    RAC(self.newestUserView.titleLabel, text) = [RACObserve(self.viewModel, titleText)
                                          takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self)
    [[self.newestUserView.detailAction
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.pushvc sendNext:@"NewUserActivities"];
    }];
}


#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.priceView];
}
/// 热卖、预告、公共部分
- (void) layoutViews {
    self.backgroundColor = UIColor.whiteColor;
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.bottom.equalTo(self).offset(-4);
        make.height.mas_equalTo(35);
    }];
   
}
- (void) removeViews {
    [self.normalView removeFromSuperview];
    [self.hotView removeFromSuperview];
    [self.preview removeFromSuperview];
    [self.newestUserView removeFromSuperview];
}
- (void) layoutNomalViews {
    [self removeViews];
    [self insertSubview:self.normalView belowSubview:self.priceView];
    [self.normalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void) layoutHotSaleViews {
    [self removeViews];
    [self insertSubview:self.hotView belowSubview:self.priceView];
    [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void) layoutPreviewViews {
    [self removeViews];
    [self insertSubview:self.preview belowSubview:self.priceView];
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void) layoutNewUserViews {
    [self removeViews];
    [self insertSubview:self.newestUserView belowSubview:self.priceView];
    [self.newestUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void) layoutAuctionViews {
    [self removeViews];
    [self insertSubview:self.autionView belowSubview:self.priceView];
    [self.autionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailPriceViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (JHStoreDetailNormalView *)normalView {
    if (!_normalView) {
        _normalView = [[JHStoreDetailNormalView alloc]initWithFrame:CGRectZero];
    }
    return _normalView;
}
- (JHStoreDetailPriceHotView *)hotView {
    if (!_hotView) {
        _hotView = [[JHStoreDetailPriceHotView alloc]initWithFrame:CGRectZero];
    }
    return _hotView;
}
- (JHStoreDetailPricePreview *)preview {
    if (!_preview) {
        _preview = [[JHStoreDetailPricePreview alloc]initWithFrame:CGRectZero];
    }
    return _preview;
}
- (JHStoreDetailNewUserView *)newestUserView {
    if (!_newestUserView) {
        _newestUserView = [[JHStoreDetailNewUserView alloc]initWithFrame:CGRectZero];
    }
    return _newestUserView;
}
- (JHStoreDetailPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[JHStoreDetailPriceView alloc] initWithFrame:CGRectZero];
    }
    return _priceView;
}
- (JHStoreAutionPriceView *)autionView {
    if (!_autionView) {
        _autionView = [[JHStoreAutionPriceView alloc]initWithFrame:CGRectZero];
    }
    return _autionView;
}
@end
