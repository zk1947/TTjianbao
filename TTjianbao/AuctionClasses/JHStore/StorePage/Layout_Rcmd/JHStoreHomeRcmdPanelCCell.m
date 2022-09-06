//
//  JHStoreHomeRcmdPanelCCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/22.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeRcmdPanelCCell.h"
#import "TTjianbaoHeader.h"
#import "YYControl.h"
#import "UIView+CornerRadius.h"
#import "CStoreHomeListModel.h"
#import "YDCountDownManager.h"
#import "YDCountDownView.h"

@interface JHStoreHomeRcmdPanelCCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *goodsStatusImgView;
@property (nonatomic, strong) UILabel *tagLabel; //tag标签（捡漏）

@property (nonatomic, strong) UIView *countDownMaskView; //倒计时视图
@property (nonatomic, strong) YDCountDownView *countDownView;

@property (nonatomic, strong) UILabel *goodsTitleLabel; //商品标题
@property (nonatomic, strong) UILabel *goodsDescLabel; //商品描述
@property (nonatomic, strong) UILabel *curPriceLabel; //商品当前价格(平台价)
@property (nonatomic, strong) UILabel *saleTagLabel; //限时购标签

@end

@implementation JHStoreHomeRcmdPanelCCell

- (void)dealloc {
    //倒计时相关
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self __addCountDownObserver];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.backgroundColor = [UIColor whiteColor];
        _contentControl.layer.cornerRadius = 4;
        _contentControl.clipsToBounds = YES;
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.didSelectedItemBlock) { //点击事件
                        self.didSelectedItemBlock(self.goodsData);
                    }
                }
            }
        };
    }
    
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_imgView];
    }
    
    if (!_goodsStatusImgView) {
        _goodsStatusImgView = [UIImageView new];
        _goodsStatusImgView.clipsToBounds = YES;
        _goodsStatusImgView.hidden = YES;
        _goodsStatusImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_goodsStatusImgView];
    }
    
    if (!_tagLabel) {
        _tagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:11] textColor:[UIColor whiteColor]];
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"FC4200"];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        //[_tagLabel yd_setCornerRadius:6 color:[UIColor whiteColor] corners:UIRectCornerTopLeft | UIRectCornerBottomRight];
        [_tagLabel yd_setCornerRadius:5 corners:UIRectCornerTopLeft | UIRectCornerBottomRight];
        _tagLabel.clipsToBounds = YES;
        [_contentControl addSubview:_tagLabel];
        _tagLabel.hidden = YES;
    }
    
    //倒计时视图
    if (!_countDownMaskView) {
        _countDownMaskView = [UIView new];
        _countDownMaskView.backgroundColor = [UIColor colorWithHexStr:@"333333" alpha:0.5];
        _countDownMaskView.userInteractionEnabled = NO;
        [_contentControl addSubview:_countDownMaskView];
    }
    
    if (!_countDownView) {
        YDCountDownConfig *config = [[YDCountDownConfig alloc] init];
        config.title = @"距结束";
        config.titleColor = [UIColor whiteColor];
        config.ddColor = [UIColor whiteColor];
        config.spColor = [UIColor whiteColor];
        _countDownView = [YDCountDownView countDownWithConfig:config endBlock:^{
            
        }];
        [_countDownMaskView addSubview:_countDownView];
    }
    
    //标题、描述、价格、折扣信息
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:14] textColor:kColor333];
        [_contentControl addSubview:_goodsTitleLabel];
    }
    
    if (!_goodsDescLabel) {
        _goodsDescLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor666];
        _goodsDescLabel.numberOfLines = 2;
        _goodsDescLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_contentControl addSubview:_goodsDescLabel];
    }
    
    if (!_curPriceLabel) {
        _curPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldDIN size:13] textColor:[UIColor colorWithHexString:@"FC4200"]];
        [_contentControl addSubview:_curPriceLabel];
    }
    
    //限时购标签
    if (!_saleTagLabel) {
        _saleTagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:9] textColor:[UIColor whiteColor]];
        _saleTagLabel.backgroundColor = [UIColor colorWithHexString:@"FF4200"];
        _saleTagLabel.textAlignment = NSTextAlignmentCenter;
        _saleTagLabel.sd_cornerRadius = @2.0;
        [_contentControl addSubview:_saleTagLabel];
    }
    
    //布局
    [self makeLayout];
}

//布局
- (void)makeLayout {
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _imgView.sd_layout
    .topEqualToView(_contentControl)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightEqualToWidth();
    
    _goodsStatusImgView.sd_layout
    .centerXEqualToView(self.imgView)
    .centerYEqualToView(self.imgView)
    .widthIs(80).heightEqualToWidth();

    _tagLabel.sd_layout
    .leftSpaceToView(_contentControl, 5)
    .topSpaceToView(_contentControl, 5)
    .heightIs(21);
    
    //倒计时视图
    _countDownMaskView.sd_layout
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .bottomEqualToView(_imgView)
    .heightIs(30);
    
    _countDownView.sd_layout
    .centerYEqualToView(_countDownMaskView)
    .rightEqualToView(_countDownMaskView)
    .heightIs(30);
    
    //标题
    _goodsTitleLabel.sd_layout
    .leftSpaceToView(_contentControl, 5)
    .rightSpaceToView(_contentControl, 0)
    .topSpaceToView(_imgView, 5)
    .heightIs(18);
    
    //描述
    _goodsDescLabel.sd_layout
    .leftSpaceToView(_contentControl, 5)
    .rightSpaceToView(_contentControl, 0)
    .topSpaceToView(_goodsTitleLabel, 2)
    .autoHeightRatio(0);
    
    //售价
    _curPriceLabel.sd_layout
    .leftSpaceToView(_contentControl, 5)
    .bottomSpaceToView(_contentControl, 5)
    .heightIs(16);
    
    //限时购标签
    _saleTagLabel.sd_layout
    .leftSpaceToView(_curPriceLabel, 5)
    .centerYEqualToView(_curPriceLabel)
    .widthIs(37).heightIs(13);
    
    [_goodsTitleLabel setMaxNumberOfLinesToShow:1];
    [_goodsDescLabel setMaxNumberOfLinesToShow:2];
    
    [_curPriceLabel setSingleLineAutoResizeWithMaxWidth:70];
}

- (void)setGoodsStatus:(NSInteger)status {
    if (status == 3) {
        ///已下架
        _goodsStatusImgView.hidden = NO;
        _goodsStatusImgView.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_off_shelf"];
        _countDownMaskView.hidden = YES;
    }
    else if (status == 4) {
        ///已结缘
        _goodsStatusImgView.hidden = NO;
        _goodsStatusImgView.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"];
        _countDownMaskView.hidden = YES;

    }else {
        _goodsStatusImgView.hidden = YES;
        _countDownMaskView.hidden = NO;
    }
}

- (void)setGoodsData:(CStoreHomeGoodsData *)goodsData {
    _goodsData = goodsData;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:goodsData.coverImgInfo.imgUrl]
                              placeholder:kDefaultCoverImage];
    ///商品状态图片
    [self setGoodsStatus:goodsData.status];
    
    _tagLabel.text = goodsData.tag_name;
    _tagLabel.hidden = ![goodsData.tag_name isNotBlank];
    
    CGFloat tagWidth = [goodsData.tag_name getWidthWithFont:_tagLabel.font
                                          constrainedToSize:CGSizeMake(100, 23)];
    _tagLabel.sd_resetLayout
    .topSpaceToView(_contentControl, 5)
    .leftSpaceToView(_contentControl, 5)
    .widthIs(tagWidth + 10).heightIs(23);
    
    _goodsTitleLabel.text = goodsData.name;
    _goodsDescLabel.text = goodsData.desc;
    _curPriceLabel.text = goodsData.market_price; //售价
    
    //限时购标签
    _saleTagLabel.text = goodsData.flash_sale_tag;
    _saleTagLabel.hidden = ![goodsData.flash_sale_tag isNotBlank];
    
    [_curPriceLabel updateLayout];
    [_saleTagLabel updateLayout];
    
    //倒计时相关
    [self handleCountDownEvent];
}

//设置带删除线的原价
/*
- (void)__setOrigPriceStr:(NSString *)oriStr {
    if (!oriStr) {return;}
    
    NSUInteger length = [oriStr length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oriStr];
    
    [attri addAttribute:NSStrikethroughStyleAttributeName
                  value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                  range:NSMakeRange(0, length)];
    
    [attri addAttribute:NSStrikethroughColorAttributeName
                  value:kColor666
                  range:NSMakeRange(0, length)];
    
    //[_oriPriceLabel setAttributedText:attri];
}
*/

//倒计时相关 - 添加通知
- (void)__addCountDownObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self handleCountDownEvent];
    }];
    
    /**
    RACSignal *signal = [[JHNotificationCenter rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal];
    
    [signal subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        [self handleCountDownEvent];
    }];
    
    [signal subscribeCompleted:^{
        NSLog(@"JHStoreHomeRcmdPanelCCell::通知被移除");
    }];
     */
}

//倒计时相关 - 设置倒计时数据
- (void)handleCountDownEvent {
    NSInteger timeInterval = 0;
    if (_goodsData.timerSourceIdentifier) {
        timeInterval = [kCountDownManager timeIntervalWithId:_goodsData.timerSourceIdentifier];
    } else {
        timeInterval = kCountDownManager.runLoopTimeInterval;
    }
    
    //second是总秒数
    NSInteger second = _goodsData.offline_at.integerValue - _goodsData.server_at.integerValue;
    NSInteger countDownValue = second - timeInterval;
    if (countDownValue <= 0) {
        NSLog(@"今日推荐样式-倒计时结束");
        if (self.countDownEndBlock) {
            self.countDownEndBlock(_goodsData);
        }
        return;
    }
    [_countDownView setCountDownTime:countDownValue];
}

@end
