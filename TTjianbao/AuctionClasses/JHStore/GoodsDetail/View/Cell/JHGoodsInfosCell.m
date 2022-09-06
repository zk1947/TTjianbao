//
//  JHGoodsInfosCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsInfosCell.h"
#import "TTjianbaoHeader.h"
#import "CGoodsDetailModel.h"

@interface JHGoodsInfosCell ()

@property (nonatomic, strong) YYLabel *nameLabel; //名称
@property (nonatomic, strong) YYLabel *descLabel; //描述

@end

@implementation JHGoodsInfosCell

+ (CGFloat)cellHeight {
    return 80;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    //商品名
    _nameLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontMedium size:16] textColor:kColor333];
    _nameLabel.numberOfLines = 0;

    //商品描述
    _descLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:kColor333];
    _descLabel.numberOfLines = 0;
    _descLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    //加入视图
    [self.contentView sd_addSubviews:@[_nameLabel, _descLabel]];
    [self makeLayout];
}

- (void)makeLayout {
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, 15)
    .widthIs(ScreenWidth-30)
    .heightIs(0);

    _descLabel.sd_layout
    .topSpaceToView(_nameLabel, 5)
    .leftEqualToView(_nameLabel)
    .widthIs(ScreenWidth-30)
    .heightIs(0);
}

- (void)setGoodsInfo:(CGoodsInfo *)goodsInfo {
    if (!goodsInfo) {
        return;
    }
    _goodsInfo = goodsInfo;
    _nameLabel.text = _goodsInfo.name;
    _descLabel.text = _goodsInfo.desc;
    
    CGFloat space = _goodsInfo.sell_type == 1 ? [self getNameTopSpace:_goodsInfo.status] : 0;
    _nameLabel.sd_resetLayout
    .topSpaceToView(self.contentView, space).leftSpaceToView(self.contentView, 15)
    .widthIs(ScreenWidth-30)
    .heightIs(_goodsInfo.titleHeight);

    _descLabel.sd_resetLayout
    .topSpaceToView(_nameLabel, 10)
    .leftEqualToView(_nameLabel)
    .widthIs(ScreenWidth-30)
    .heightIs(_goodsInfo.descHeight);
}

///获取标题距上的space
- (CGFloat)getNameTopSpace:(JHGoodsStatus)status {
    switch (status) {
        case JHGoodsStatusSellEnd:
        case JHGoodsStatusSelled:
        case JHGoodsStatusAlreadyGrounding:
            return 10.f;
            break;
        default:
            return 0;
            break;
    }
}

//#pragma mark -
//#pragma mark - private methods
//
//+ (CGFloat)__getHeightWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
//    if (![text isNotBlank]) return 0;
//    YYTextLayout *layout = [[self class] __layoutWithText:text font:font color:color];
//    return layout.textBoundingSize.height;
//}
//
//+ (YYTextLayout *)__layoutWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
//    //将一个或多个连续的<br>，或者一个或多个连续的<br /> 替换成一个换行符
//    if (!text) return nil;
//    NSString *textStr = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
//    textStr = [textStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
//
//    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\n{1,}" options:0 error:nil];
//    textStr = [regular stringByReplacingMatchesInString:textStr options:0 range:NSMakeRange(0, [textStr length])
//                                           withTemplate:@"\n"];
//
//    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:textStr];
//    attrText.font = font;
//    attrText.color = color;
//    attrText.lineSpacing = 2;
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) text:attrText];
//    return layout;
//}


@end
