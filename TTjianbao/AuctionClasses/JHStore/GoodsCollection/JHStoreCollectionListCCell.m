//
//  JHStoreCollectionListCCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/1/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreCollectionListCCell.h"
#import "TTjianbao.h"
#import "YYControl.h"
#import "JHStoreHelp.h"

@interface JHStoreCollectionListCCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView; //图片
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *descLabel; //描述
@property (nonatomic, strong) UILabel *curPriceLabel; //售价
//@property (nonatomic, strong) UILabel *discountLabel; //折扣
@property (nonatomic, strong) UILabel *saleTagLabel; //限时购标签
@property (nonatomic, strong) UIButton *shopNameBtn; //店铺名
@property (nonatomic, strong) UIView *bottomLine; //分割线
@property (nonatomic, strong) UIImageView *goodsStateIcon; //商品状态图

@property (nonatomic, strong) UIImageView *videoIcon; //是否有视频标识

@end

@implementation JHStoreCollectionListCCell

+ (CGFloat)cellHeight {
    return 155;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self makeLayout];
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
                    if (self.didSelectedBlock) {
                        self.didSelectedBlock(self.curData);
                    }
                }
            }
        };
    }
    
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.clipsToBounds = YES;
        _imgView.sd_cornerRadius = @4;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_imgView];
    }
    
    if (!_goodsStateIcon) {
        _goodsStateIcon = [UIImageView new];
        //_goodsStateIcon.clipsToBounds = YES;
        _goodsStateIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_imgView addSubview:_goodsStateIcon];
    }
    
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_has_video"]];
        [_imgView addSubview:_videoIcon];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:13] textColor:kColor333];
        [_contentControl addSubview:_titleLabel];
    }
    
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor666];
        //_descLabel.numberOfLines = 2;
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_contentControl addSubview:_descLabel];
    }
    
    if (!_curPriceLabel) {
        _curPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldDIN size:15] textColor:[UIColor colorWithHexString:@"FC4200"]];
        [_contentControl addSubview:_curPriceLabel];
    }
    
//    if (!_discountLabel) {
//        _discountLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:9] textColor:[UIColor colorWithHexString:@"FC4200"]];
//        _discountLabel.layer.cornerRadius = 2.f;
//        _discountLabel.layer.masksToBounds = YES;
//        _discountLabel.layer.borderWidth = 1.f;
//        _discountLabel.layer.borderColor = HEXCOLOR(0xFF4200).CGColor;
//        _discountLabel.textAlignment = NSTextAlignmentCenter;
//        [_contentControl addSubview:_discountLabel];
//    }
    
    if (!_saleTagLabel) {
        _saleTagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:9] textColor:[UIColor whiteColor]];
        _saleTagLabel.backgroundColor = [UIColor colorWithHexString:@"FF4200"];
        _saleTagLabel.textAlignment = NSTextAlignmentCenter;
        _saleTagLabel.sd_cornerRadius = @2.0;
        [_contentControl addSubview:_saleTagLabel];
        _saleTagLabel.hidden = YES;
    }
    
    if (!_shopNameBtn) {
        _shopNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shopNameBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_shopNameBtn setTitleColor:kColor999 forState:UIControlStateNormal];
        _shopNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _shopNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_contentControl addSubview:_shopNameBtn];
    }
    
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = kColorEEE;
        [_contentControl addSubview:_bottomLine];
    }
    
    @weakify(self);
    [[_shopNameBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.didClickShopBlock) {
            self.didClickShopBlock(self.curData);
        }
    }];
}

- (void)makeLayout {
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //图片
    _imgView.sd_layout
    .leftSpaceToView(_contentControl, 10)
    .centerYEqualToView(_contentControl)
    .widthIs(135).heightEqualToWidth();
    
    //商品状态图
    _goodsStateIcon.sd_layout
    .centerXEqualToView(_imgView)
    .centerYEqualToView(_imgView)
    .widthIs(80).heightEqualToWidth();
    
    //视频标识
    _videoIcon.sd_layout
    .rightSpaceToView(_imgView, 5)
    .topSpaceToView(_imgView, 5)
    .widthIs(18).heightEqualToWidth();

    //标题
    _titleLabel.sd_layout
    .topSpaceToView(_contentControl, 10)
    .leftSpaceToView(_imgView, 10)
    .rightSpaceToView(_contentControl, 0)
    .heightIs(18);

    //描述
    _descLabel.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .autoHeightRatio(0);
    [_descLabel setMaxNumberOfLinesToShow:2];
    
    //底部分割线
    _bottomLine.sd_layout
    .bottomEqualToView(_contentControl)
    .leftSpaceToView(_imgView, 10)
    .rightSpaceToView(_contentControl, 0)
    .heightIs(1);
    
    //店铺名
    _shopNameBtn.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomSpaceToView(_bottomLine, 10)
    .heightIs(15);
    
    ///限时购
    _saleTagLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomSpaceToView(_shopNameBtn, 5)
    .widthIs(37).heightIs(13);
    
    //售价
    _curPriceLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomSpaceToView(_saleTagLabel, 5)
    .heightIs(15);
    _curPriceLabel.isAttributedContent = YES;
    [_curPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //折扣
//    _discountLabel.sd_layout
//    .leftSpaceToView(_curPriceLabel, 5)
//    .centerYEqualToView(_curPriceLabel)
//    .heightIs(13);
}

- (void)setCurData:(CStoreCollectionData *)curData {
    if (!curData) {
        return;
    }
    _curData = curData;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:curData.coverImgInfo.imgUrl]
                              placeholder:kDefaultCoverImage];
    if (!_isListLayout) {
        _imgView.sd_layout.heightIs(curData.imgHeight);
    }
    
    [_imgView updateLayout];
    
    _videoIcon.hidden = !curData.has_video;
    
    _titleLabel.text = curData.name;
    _descLabel.text = curData.desc;
    //_curPriceLabel.text = curData.market_price;
    [JHStoreHelp setPrice:curData.market_price forLabel:_curPriceLabel];
    
    //折扣
//    _discountLabel.text = curData.discount;
//    CGFloat width = ceilf([curData.discount getWidthWithFont:_discountLabel.font
//                                           constrainedToSize:CGSizeMake(100, 13)]);
//    _discountLabel.sd_resetLayout
//    .leftSpaceToView(_curPriceLabel, 5)
//    .centerYEqualToView(_curPriceLabel)
//    .widthIs(width + 10).heightIs(13);
    
    [_curPriceLabel updateLayout];
//    [_discountLabel updateLayout];
    
    //限时购标签
    _saleTagLabel.text = curData.flash_sale_tag;
    _saleTagLabel.hidden = ![curData.flash_sale_tag isNotBlank];
    
    _saleTagLabel.sd_layout.heightIs([curData.flash_sale_tag isNotBlank]?13:0);
    [_saleTagLabel updateLayout];

    
    //店铺名
    [_shopNameBtn setTitle:curData.store_name forState:UIControlStateNormal];
    [_shopNameBtn setImage:[UIImage imageNamed:@"goods_collect_list_icon_shop_arrow"] forState:UIControlStateNormal];
    
//    CGFloat nameW = [curData.store_name getWidthWithFont:[UIFont fontWithName:kFontNormal size:12] constrainedToSize:CGSizeMake(kScreenWidth-165-20, 18)];
//    _shopNameBtn.sd_layout.widthIs(nameW + 20);
    [_shopNameBtn setImageInsetStyle:MRImageInsetStyleRight spacing:5];
    
    [_shopNameBtn updateLayout];
    
    //商品状态 【0 待发布 2 已上架 3 已下架 4 已售出】
    if (curData.status == 3) {
        _goodsStateIcon.hidden = NO;
        _goodsStateIcon.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_off_shelf"];
    } else if (curData.status == 4) {
        _goodsStateIcon.hidden = NO;
        _goodsStateIcon.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"];
    } else {
        _goodsStateIcon.hidden = YES;
    }
}

@end
