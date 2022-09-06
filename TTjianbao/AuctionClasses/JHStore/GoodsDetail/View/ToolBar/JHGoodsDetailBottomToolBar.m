//
//  JHGoodsDetailBottomToolBar.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailBottomToolBar.h"
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"
#import "JHStoreApiManager.h"
#import "JHQYChatManage.h"
#import "JHChatBusiness.h"
#define kCollectIconW   (19)
#define kCollectIconH   (18)

@interface JHGoodsDetailBottomToolBar ()

@property (nonatomic, strong) UIButton      *serviceBtn; //客服
@property (nonatomic, strong) UIButton      *shopBtn; //店铺

@property (nonatomic, strong) UIButton      *collectBtn; //收藏按钮
@property (nonatomic, strong) UIView        *collectIconBg; //收藏按钮图标背景（为了动画）
@property (nonatomic, strong) UIImageView   *collectIcon; //收藏按钮图标
@property (nonatomic, strong) UILabel       *collectLabel; //收藏按钮标题

@property (nonatomic, strong) UIButton      *buyBtn; //立即抢购

@end

@implementation JHGoodsDetailBottomToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [UIView new];
        topLine.backgroundColor = kColorEEE;
        
        _serviceBtn = [UIButton buttonWithTitle:@"联系平台" titleColor:kColor666];
        _serviceBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_serviceBtn setImage:[UIImage imageNamed:@"icon_goods_detail_service"] forState:UIControlStateNormal];
        _serviceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _serviceBtn.adjustsImageWhenHighlighted = NO;
        [_serviceBtn setImageInsetStyle:MRImageInsetStyleTop spacing:2];
        
        _shopBtn = [UIButton buttonWithTitle:@"店铺" titleColor:kColor666];
        _shopBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_shopBtn setImage:[UIImage imageNamed:@"icon_goods_detail_shop"] forState:UIControlStateNormal];
        _shopBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _shopBtn.adjustsImageWhenHighlighted = NO;
        [_shopBtn setImageInsetStyle:MRImageInsetStyleTop spacing:2];
        
        //收藏按钮
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn.exclusiveTouch = YES;
        
        _collectIconBg = [UIView new];
        _collectIconBg.userInteractionEnabled = NO;
        [_collectBtn addSubview:_collectIconBg];
        
        _collectIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_goods_detail_collect_normal"]];
        _collectIcon.userInteractionEnabled = NO;
        [_collectIconBg addSubview:_collectIcon];

        _collectLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12.0] textColor:kColor666];
        _collectLabel.textAlignment = NSTextAlignmentCenter;
        _collectLabel.userInteractionEnabled = NO;
        [_collectBtn addSubview:_collectLabel];
        
        //立即抢购
        _buyBtn = [UIButton buttonWithTitle:@"立即抢购" titleColor:kColor333];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFEE100)] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateDisabled];
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitle:@"已下架" forState:UIControlStateDisabled];
        [_buyBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [_buyBtn setTitleColor:kColor999 forState:UIControlStateDisabled];
        _buyBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _buyBtn.adjustsImageWhenDisabled = NO;
        _buyBtn.adjustsImageWhenHighlighted = NO;
        _buyBtn.clipsToBounds = YES;
        _buyBtn.sd_cornerRadiusFromHeightRatio = @0.5;
        
        @weakify(self);
        [[_serviceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.clickServiceBlock) {
                self.clickServiceBlock();
            }
        }];
        
        [[_shopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.clickShopBlock) {
                self.clickShopBlock();
            }
        }];
        
        [[_collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self didClickCollectBtn];
        }];
        
        [[_buyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.clickBuyBlock) {
                self.clickBuyBlock();
            }
        }];
        
        [self sd_addSubviews:@[topLine, _serviceBtn, _shopBtn, _collectBtn, _buyBtn]];
        
        topLine.sd_layout
        .topEqualToView(self).leftEqualToView(self).widthIs(kScreenWidth).heightIs(1);
        
        _serviceBtn.sd_layout
        .topSpaceToView(self, 1)
        .leftSpaceToView(self, 5)
        .widthIs(60).heightIs(44);
        
        _shopBtn.sd_layout
        .topSpaceToView(self, 1)
        .leftSpaceToView(_serviceBtn, 0)
        .widthIs(60).heightIs(44);
        
        _collectBtn.sd_layout
        .topSpaceToView(self, 1)
        .leftSpaceToView(_shopBtn, 0)
        .widthIs(60).heightIs(44);
        
        _collectIconBg.sd_layout
        .topSpaceToView(_collectBtn, 0)
        .centerXEqualToView(_collectBtn)
        .widthIs(kCollectIconW*1.5).heightIs(kCollectIconH*1.5);
        
        _collectIcon.sd_layout
        .centerXEqualToView(_collectIconBg)
        .centerYEqualToView(_collectIconBg).offset(-1)
        .widthIs(kCollectIconW).heightIs(kCollectIconH);
        
        _collectLabel.sd_layout
        .bottomSpaceToView(_collectBtn, 3.5)
        .centerXEqualToView(_collectBtn)
        .widthIs(60).heightIs(17);
        
        _buyBtn.sd_layout
        .centerYEqualToView(self)
        .rightSpaceToView(self, 15)
        .widthIs(136).heightIs(34);
    }
    return self;
}

- (void)setGoodsInfo:(CGoodsInfo *)goodsInfo {
    if (!goodsInfo) {
        return;
    }
    _goodsInfo = goodsInfo;
    
    [JHChatBusiness getServeceWithUserId:@(goodsInfo.seller_id).stringValue successBlock:^(RequestModel * _Nullable respondObject) {
        NSUInteger code = [respondObject.data integerValue];
        if (code == 1) {
            [self.serviceBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        }else {
            [JHQYChatManage checkChatTypeWithCustomerId:@(goodsInfo.seller_id).stringValue saleType:JHChatSaleTypeFront completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
                [self.serviceBtn setTitle:isShop?@"联系商家":@"联系平台" forState:UIControlStateNormal];
                //[self.bottomBar setChatTitle:isShop?@"联系商家":@"联系平台"];
            }];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];

    /* 售卖类型[0 非特卖 ， 1 特卖] */
    NSInteger sellType = _goodsInfo.sell_type; //商品类型 0普通类型，1限时特卖
    JHGoodsStatus status = _goodsInfo.status;
    ///设置按钮状态
    [self getBuyButtonTitle:status sellType:sellType];
    [self updateCollectAnimated:NO];
}

- (void)getBuyButtonTitle:(JHGoodsStatus)status sellType:(NSInteger)sellType {
    /*   lh
     商品状态 [0待发布 1待上架 2 已上架 3 已下架 4 已售出 5待审核 6特卖中]
     活动状态 [ 11 提醒我，12 已设提醒, 13 已结束]
     */
    switch (status) {
        case JHGoodsStatusAlreadyGrounding:  ///已上架
        {
            _buyBtn.enabled = YES;
            [_buyBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFEE100)] forState:UIControlStateNormal];
            if (sellType == 1) {
                ///特卖
                [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
            }
            else {
                [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            }
        }
            break;
        case JHGoodsStatusOutOfStock:  ///已下架
        {
            _buyBtn.enabled = NO;
            [_buyBtn setTitle:@"已下架" forState:UIControlStateDisabled];
        }
            break;
        case JHGoodsStatusSelled:  ///已结缘
        {
            _buyBtn.enabled = NO;
            [_buyBtn setTitle:@"已结缘" forState:UIControlStateDisabled];
        }
            break;
        case JHGoodsStatusRemindMe: ///提醒我
        {
            _buyBtn.enabled = YES;
            [_buyBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFEE100)] forState:UIControlStateNormal];
            [_buyBtn setTitle:@"提醒我" forState:UIControlStateNormal];
        }
            break;
        case JHGoodsStatusSetReminded: ///已设提醒
        {
            _buyBtn.enabled = YES;
            [_buyBtn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateNormal];
            [_buyBtn setTitle:@"已设提醒" forState:UIControlStateNormal];
        }
            break;
        case JHGoodsStatusSellEnd:  ///已结束
        {
            _buyBtn.enabled = NO;
            [_buyBtn setTitle:@"已结束" forState:UIControlStateDisabled];
        }
            break;
        default:
        {
            _buyBtn.enabled = NO;
            NSString *btnString = (sellType==1) ? @"已结束" : @"已下架";
            [_buyBtn setTitle:btnString forState:UIControlStateDisabled];
        }
            break;
    }
}

//更新收藏按钮
- (void)updateCollectAnimated:(BOOL)animated {
    
    NSString *collectTitle = _goodsInfo.is_collected ? @"已收藏" : @"收藏";
    NSString *collectImgName = _goodsInfo.is_collected ? @"icon_goods_detail_collect_selected" : @"icon_goods_detail_collect_normal";
    _collectIcon.image = [UIImage imageNamed:collectImgName];
    _collectLabel.text = collectTitle;
    
    if (animated) {
        self.collectIcon.sd_layout.widthIs(kCollectIconW*1.2).heightIs(kCollectIconH*1.2);
        [self.collectIcon updateLayout];
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.collectIcon.sd_layout.widthIs(kCollectIconW*0.5).heightIs(kCollectIconH*0.5);
            [self.collectIcon updateLayout];

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.collectIcon.sd_layout.widthIs(kCollectIconW).heightIs(kCollectIconH);
                [self.collectIcon updateLayout];
            }];
        }];
    }
}


#pragma mark -
#pragma mark - 网络请求
//收藏/取消收藏
- (void)didClickCollectBtn {
    NSLog(@"点击收藏");
    
    if (![self isLogin]) {
        return;
    }
    if(_clickCollectBlock)
    {
        _clickCollectBlock(!_goodsInfo.is_collected);
    }
    @weakify(self);
    if (_goodsInfo.is_collected) {
        //执行取消收藏操作
        [JHStoreApiManager cancelCollectionWithGoodsId:_goodsInfo.goods_id block:^(id  _Nullable respObj, BOOL hasError) {
            if (respObj) {
                @strongify(self);
                self.goodsInfo.is_collected = NO;
                [self updateCollectAnimated:NO];
            }
        }];
        
    } else {
        //执行收藏操作
        [JHStoreApiManager collectionWithGoodsId:_goodsInfo.goods_id block:^(id  _Nullable respObj, BOOL hasError) {
            if (respObj) {
                @strongify(self);
                self.goodsInfo.is_collected = YES;
                [self updateCollectAnimated:YES];
            }
        }];
    }
}

- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {}];
        return  NO;
    }
    return  YES;
}

@end
