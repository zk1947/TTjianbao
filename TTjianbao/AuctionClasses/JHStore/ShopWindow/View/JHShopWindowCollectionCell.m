//
//  JHShopWindowCollectionCell.m
//  TTjianbao
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopWindowCollectionCell.h"
#import "JHGoodsInfoMode.h"
#import "UIImageView+JHWebImage.h"
#import "UIView+CornerRadius.h"
#import "YDCountDownManager.h"
//#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "YDCountDownView.h"
#import "JHStoreHelp.h"

@interface JHShopWindowCollectionCell ()

///商品图片
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIImageView *goodsStatusImage;  ///显示已结缘
@property (nonatomic, strong) UIImageView *videoIcon; //是否有视频标识
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *goodsDescLabel;
@property (nonatomic, strong) UILabel *limitTimeLabel;
@property (nonatomic, strong) UILabel *currentPriceLabel;
//@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *pickLabel;
@property (nonatomic, strong) UIView *countBottomView;
@property (nonatomic, strong) YDCountDownView *countDownView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation JHShopWindowCollectionCell

///倒计时相关
//倒计时相关 - 添加通知
- (void)__addCountDownObserver {
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self handleCountDownEvent];
    }];
}

//倒计时相关 - 设置倒计时数据
- (void)handleCountDownEvent {
    NSInteger timeInterval = 0;
    if (_layout.goodsInfo.timerSourceIdentifier) {
        timeInterval = [kCountDownManager timeIntervalWithId:_layout.goodsInfo.timerSourceIdentifier];
    }
    else {
        timeInterval = kCountDownManager.runLoopTimeInterval;
    }
    
    if ([_layout.goodsInfo.sell_type intValue] == 0) {
        return;
    }

    NSInteger second = (NSInteger)(_layout.goodsInfo.offline_at - _layout.goodsInfo.server_at);
    NSInteger countDownValue = second - timeInterval;
    if (countDownValue <= 0) {
        [_countDownView showEndStyle];
        if (self.countDownEndBlock) {
            self.countDownEndBlock(_layout);
        }
        return;
    }
    
    [_countDownView setCountDownTime:countDownValue];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self __addCountDownObserver];
        self.contentView.layer.cornerRadius = 4;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _goodsImageView = [UIImageView new];
    _goodsImageView.frame = CGRectMake(0, 0, self.contentView.width, 60);
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImageView.clipsToBounds = YES;
    _goodsImageView.image = [UIImage imageNamed:@"cover_default_list"];
    
    _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_has_video"]];
    [_goodsImageView addSubview:_videoIcon];

    _goodsStatusImage = [UIImageView new];
    _goodsStatusImage.frame = CGRectMake(0, 0, self.contentView.width, 60);
    _goodsStatusImage.contentMode = UIViewContentModeScaleAspectFill;
    _goodsStatusImage.clipsToBounds = YES;
    _goodsStatusImage.image = [UIImage imageNamed:@""];
    _goodsStatusImage.hidden = YES;

    _pickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 21)];
    _pickLabel.backgroundColor = HEXCOLOR(0xFC4200);
    _pickLabel.text = @"";
    _pickLabel.preferredMaxLayoutWidth = (ScreenW - 25)*0.5 - 25;
    _pickLabel.textColor = [UIColor whiteColor];
    _pickLabel.textAlignment = NSTextAlignmentCenter;
    _pickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _pickLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _pickLabel.hidden = YES;
    
    //倒计时视图
    if (!_countDownView) {
        _countBottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [_goodsImageView addSubview:_countBottomView];
        _countBottomView.bottom = self.goodsImageView.bottom;
        _countBottomView.left = self.goodsImageView.left;
        _countBottomView.width = self.goodsImageView.width;
        _countBottomView.height = 30;
        _countBottomView.backgroundColor = HEXCOLORA(0x333333, .5f);
        
        YDCountDownConfig *config = [[YDCountDownConfig alloc] init];
        config.titleColor = [UIColor whiteColor];
        config.ddColor = [UIColor whiteColor];
        config.spColor = [UIColor whiteColor];
        _countDownView = [YDCountDownView countDownWithConfig:config endBlock:^{
        }];
        [_goodsImageView addSubview:_countDownView];
    }
    
    _goodsTitleLabel = [[UILabel alloc] init];
    _goodsTitleLabel.top = _goodsImageView.bottom+10;
    _goodsTitleLabel.left = 10;
    _goodsTitleLabel.width = _goodsImageView.width - 15;
    _goodsTitleLabel.height = 18;
    _goodsTitleLabel.text = @"--";
    _goodsTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    _goodsTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
    
    _goodsDescLabel = [[UILabel alloc] init];
    _goodsDescLabel.top = _goodsTitleLabel.bottom + 10;
    _goodsDescLabel.left = 10;
    _goodsDescLabel.width = _goodsTitleLabel.width;
    _goodsDescLabel.height = 15;
    _goodsDescLabel.text = @"--";
    _goodsDescLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _goodsDescLabel.numberOfLines = 2;
    _goodsDescLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _goodsDescLabel.textColor = HEXCOLOR(0x666666);
    
    _currentPriceLabel = [[UILabel alloc] init];
    _currentPriceLabel.top = _goodsTitleLabel.bottom + 10;
    _currentPriceLabel.left = 10;
    _currentPriceLabel.width = _goodsTitleLabel.width - 5;
    _currentPriceLabel.height = 16;
    //_currentPriceLabel.text = @"￥0";
    _currentPriceLabel.font = [UIFont fontWithName:kFontBoldDIN size:15];
    _currentPriceLabel.textColor = HEXCOLOR(0xFC4200);
     
    _limitTimeLabel = [[UILabel alloc] init];
    _limitTimeLabel.backgroundColor = HEXCOLOR(0xFF4200);
    _limitTimeLabel.bottom = _currentPriceLabel.bottom;
    _limitTimeLabel.left = _currentPriceLabel.right + 5;
    _limitTimeLabel.width = 32;
    _limitTimeLabel.height = 15;
    _limitTimeLabel.textAlignment = NSTextAlignmentCenter;
    _limitTimeLabel.text = @"";
    _limitTimeLabel.font = [UIFont fontWithName:kFontNormal size:10];
    _limitTimeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _limitTimeLabel.textColor = HEXCOLOR(0xffffff);
    _limitTimeLabel.layer.cornerRadius = 2.f;
    _limitTimeLabel.layer.masksToBounds = YES;
    
//    _discountLabel = [[UILabel alloc] init];
//    _discountLabel.bottom = _currentPriceLabel.bottom;
//    _discountLabel.left = _currentPriceLabel.right + 5;
//    _discountLabel.width = 40;
//    _discountLabel.height = 15;
//    _discountLabel.text = @"0折";
//    _discountLabel.font = [UIFont fontWithName:kFontNormal size:10];
//    _discountLabel.textColor = HEXCOLOR(0x666666);
    
    [self.contentView addSubview:_goodsImageView];
    [self.contentView addSubview:_goodsStatusImage];
    [_goodsImageView addSubview:_pickLabel];
    _countBottomView.hidden = YES;
    _countDownView.hidden = YES;
 
    [self.contentView addSubview:_goodsTitleLabel];
    [self.contentView addSubview:_goodsDescLabel];
    [self.contentView addSubview:_currentPriceLabel];
    [self.contentView addSubview:_limitTimeLabel];
//    [self.contentView addSubview:_discountLabel];
    ///初始时不显示标签
    _limitTimeLabel.hidden = YES;
    
    //视频标识
    _videoIcon.sd_layout
    .rightSpaceToView(_goodsImageView, 5)
    .topSpaceToView(_goodsImageView, 5)
    .widthIs(18).heightEqualToWidth();
}


- (void)setLayout:(JHShopWindowLayout *)layout {
    _layout = layout;
    
    _goodsImageView.height = _layout.imageHeight;
    _goodsStatusImage.size = CGSizeMake(80, 80);
    _goodsStatusImage.center = _goodsImageView.center;

    _videoIcon.hidden = !layout.goodsInfo.has_video;
    
    _countBottomView.bottom = _goodsImageView.bottom;
    _countDownView.right = _goodsImageView.right;
    _countDownView.height = 30;
    
    _countDownView.bottom = _goodsImageView.bottom;
    _countDownView.left = _goodsImageView.left;
    _countDownView.right = _goodsImageView.right;
    _countDownView.height = 30;
    
    _goodsTitleLabel.top = _goodsImageView.bottom + _layout.imgTitleSpace;
    _goodsTitleLabel.height = _layout.titleHeight;
    
    _goodsDescLabel.top = _goodsTitleLabel.bottom + _layout.titleDescSpace;
    _goodsDescLabel.height = _layout.descHeight;
    
    _currentPriceLabel.top = _goodsDescLabel.bottom + _layout.descPriceSpace;
    _currentPriceLabel.width = _layout.curPriceWidth;
    
//    _discountLabel.left = _originPriceLabel.right + 5;
//    _discountLabel.bottom = _originPriceLabel.bottom;
//    _discountLabel.width = _layout.discountWidth;
    
    JHGoodsInfoMode *goodInfo = _layout.goodsInfo;
    [_goodsImageView jhSetImageWithURL:[NSURL URLWithString:goodInfo.coverImage.url] placeholder:[UIImage imageNamed:@"cover_default_list"]];
    //商品状态: 0待发布 1待上架 2已上架 3已下架 4已售出 5待审核 6特卖中
    if ([goodInfo.status intValue] == 3) {
        _goodsStatusImage.hidden = NO;
        _goodsStatusImage.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_off_shelf"];
    }
    else if ([goodInfo.status intValue] == 4) {
        _goodsStatusImage.hidden = NO;
        _goodsStatusImage.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"];
    } else {
        _goodsStatusImage.hidden = YES;
    }
    _goodsTitleLabel.text = goodInfo.name;
    _goodsDescLabel.text = goodInfo.desc;
    //_currentPriceLabel.text = [NSString stringWithFormat:@"%@",goodInfo.market_price];
    [JHStoreHelp setPrice:goodInfo.market_price forLabel:_currentPriceLabel];
    
    ///设置专题标签
    _limitTimeLabel.left = _currentPriceLabel.right + 5;
    _limitTimeLabel.bottom = _currentPriceLabel.bottom;
    _limitTimeLabel.width = _layout.oriPriceWidth;
    ///设置文字
    _limitTimeLabel.text = goodInfo.flash_sale_tag;
    _limitTimeLabel.hidden = ![goodInfo.flash_sale_tag isNotBlank];

    //    _originPriceLabel.attributedText = [self addLineAttributeString:goodInfo.orig_price];
//    _discountLabel.text = [NSString stringWithFormat:@"%@", goodInfo.discount];
    if (!goodInfo.tag_name || !goodInfo.tag_name.length) {
        _pickLabel.hidden = YES;
    }else {
        _pickLabel.hidden = NO;
        _pickLabel.text = goodInfo.tag_name;
        _pickLabel.width = _layout.tagWidth;
        [self viewCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornersView:_pickLabel Radius:6.f];
    }
    
    if ([goodInfo.sell_type intValue] == 1) {
        if (goodInfo.offline_at - goodInfo.server_at <= 0) {
            return;
        }
        //_countBottomView.hidden = NO;
        //_countDownView.hidden = NO;
          ///倒计时
        [self handleCountDownEvent];
    }
}

///切部分圆角
- (void)viewCorners:(UIRectCorner)corners cornersView:(UIView *)view Radius:(CGFloat)radius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    view.layer.mask = shapeLayer;
}

- (NSMutableAttributedString *)addLineAttributeString:(NSString *)textString {
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",textString]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(1, newPrice.length-1)];
    return newPrice;
}



@end
