//
//  JHStoreHomeListCCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeListCCell.h"
#import "TTjianbao.h"
#import "YYControl.h"
#import "JHStoreHelp.h"

@interface JHStoreHomeListCCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *curPriceLabel;
@property (nonatomic, strong) UILabel *saleTagLabel; //限时购标签
//@property (nonatomic, strong) UIImageView *goodsStateIcon;
@property (nonatomic, strong) UIImageView *videoIcon; //是否有视频标识
@end

@implementation JHStoreHomeListCCell

- (void)dealloc {
    NSLog(@"");
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
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_imgView];
    }
    
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_has_video"]];
        [_imgView addSubview:_videoIcon];
    }
    
    /*
    if (!_goodsStateIcon) {
        _goodsStateIcon = [UIImageView new];
        //_goodsStateIcon.clipsToBounds = YES;
        _goodsStateIcon.contentMode = UIViewContentModeScaleAspectFit;
        [_imgView addSubview:_goodsStateIcon];
    }
     */
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:13] textColor:kColor333];
        [_contentControl addSubview:_titleLabel];
    }
    
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor666];
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_contentControl addSubview:_descLabel];
    }
    
    if (!_curPriceLabel) {
        _curPriceLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontBoldDIN size:15] textColor:UIColorHex(FC4200)];
        [_contentControl addSubview:_curPriceLabel];
    }
    
    if (!_saleTagLabel) {
        _saleTagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:9] textColor:[UIColor whiteColor]];
        _saleTagLabel.backgroundColor = [UIColor colorWithHexString:@"FF4200"];
        _saleTagLabel.textAlignment = NSTextAlignmentCenter;
        _saleTagLabel.sd_cornerRadius = @2.0;
        [_contentControl addSubview:_saleTagLabel];
    }
}

- (void)makeLayout {
    //默认布局 <Grid Layout>
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //图片 <需要update>
    _imgView.sd_layout
    .topEqualToView(_contentControl)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl);
    
    //视频标识
    _videoIcon.sd_layout
    .rightSpaceToView(_imgView, 5)
    .topSpaceToView(_imgView, 5)
    .widthIs(18).heightEqualToWidth();
    
    //商品状态图
    /*
    _goodsStateIcon.sd_layout
    .centerXEqualToView(_imgView)
    .centerYEqualToView(_imgView)
    .widthIs(80).heightEqualToWidth();
     */
    
    //标题 grid layout显示一行，list layout显示两行
    _titleLabel.sd_layout
    .topSpaceToView(_imgView, 10)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 0)
    .heightIs(18);
    
    //描述
    _descLabel.sd_layout
    .topSpaceToView(_titleLabel, 5)
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(18);
    
    //售价
    _curPriceLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomSpaceToView(_contentControl, 10)
    .heightIs(17);
    _curPriceLabel.isAttributedContent = YES;
    [_curPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //限时购标签
    _saleTagLabel.sd_layout
    .leftSpaceToView(_curPriceLabel, 5)
    .centerYEqualToView(_curPriceLabel)
    .widthIs(37).heightIs(13);
}

- (void)setCurData:(CStoreHomeGoodsData *)curData {
    if (!curData) {
        return;
    }
    _curData = curData;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:curData.coverImgInfo.imgUrl]
                              placeholder:kDefaultCoverImage];
    _imgView.sd_layout.heightIs(curData.imgHeight);
    [_imgView updateLayout];

    _videoIcon.hidden = !curData.has_video;
    
    _titleLabel.text = curData.name;
    _descLabel.text = curData.desc;
    
    //_curPriceLabel.text = curData.market_price;
    [JHStoreHelp setPrice:curData.market_price forLabel:_curPriceLabel];
    
    //限时购标签
    _saleTagLabel.text = curData.flash_sale_tag;
    _saleTagLabel.hidden = ![curData.flash_sale_tag isNotBlank];
    
    
    //商品状态 【0 待发布 2 已上架 3 已下架 4 已售出】
    /*
    if (curData.status == 3) {
        _goodsStateIcon.hidden = NO;
        _goodsStateIcon.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_off_shelf"];
    } else if (curData.status == 4) {
        _goodsStateIcon.hidden = NO;
        _goodsStateIcon.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"];
    } else {
        _goodsStateIcon.hidden = YES;
    }
     */
}

@end
