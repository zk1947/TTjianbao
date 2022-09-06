//
//  CGoodsDetailModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "CGoodsDetailModel.h"

#pragma mark -
#pragma mark - 详情数据模型
@implementation CGoodsDetailModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsInfo" : @"goods_info",
             @"shopInfo" : @"seller_info"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsInfo" : [CGoodsInfo class],
             @"shopInfo" : [CShopInfo class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pay_msg = [NSMutableArray new];
    }
    return self;
}

@end


#pragma mark -
#pragma mark - 商品信息
@implementation CGoodsInfo

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"coverImgInfo" : @"cover_img",
             @"safeHeadImgInfo" : @"safeguard_head",
             @"safeBottomImgInfo" : @"safeguard_bottom",
             @"shareInfo" : @"share_info",
             @"attrList" : @"attr",
             @"headImgList" : @"head_res",
             @"detailImgList" : @"detail_res"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coverImgInfo" : [CGoodsImgInfo class],
             @"safeHeadImgInfo" : [CGoodsImgInfo class],
             @"safeBottomImgInfo" : [CGoodsImgInfo class],
             @"shareInfo" : [JHShareInfo class],
             @"attrList" : [CGoodsAttrData class],
             @"headImgList" : [CGoodsImgInfo class],
             @"detailImgList" : [CGoodsImgInfo class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _server_at = @0;
        _offline_at = @0;
        _attrList = [NSMutableArray new];
        _headImgList = [NSMutableArray new];
        _detailImgList = [NSMutableArray new];
    }
    return self;
}

- (void)setName:(NSString *)name {
    if (!name) {
        return;
    }
    _name = name;
    
    YYTextLayout *nameLayout = [self __layoutWithText:_name font:[UIFont fontWithName:kFontMedium size:16] color:kColor333];
    _titleHeight = nameLayout.textBoundingSize.height;
    
}

- (void)setDesc:(NSString *)desc {
    if (!desc) {
        return;
    }
    _desc = desc;
    
    YYTextLayout *descLayout = [self __layoutWithText:_desc font:[UIFont fontWithName:kFontNormal size:13] color:kColor333];
    _descHeight = descLayout.textBoundingSize.height;
    
}

- (CGFloat)cellHeight {
    return _titleHeight + _descHeight + 30;
}

#pragma mark -
#pragma mark - private methods

- (CGFloat)__getHeightWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    if (![text isNotBlank]) return 0;
    YYTextLayout *layout = [[self class] __layoutWithText:text font:font color:color];
    return layout.textBoundingSize.height;
}

- (YYTextLayout *)__layoutWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    //将一个或多个连续的<br>，或者一个或多个连续的<br /> 替换成一个换行符
    if (!text) return nil;
    NSString *textStr = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    textStr = [textStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];

    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"\n{1,}" options:0 error:nil];
    textStr = [regular stringByReplacingMatchesInString:textStr options:0 range:NSMakeRange(0, [textStr length])
                                           withTemplate:@"\n"];

    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:textStr];
    attrText.font = font;
    attrText.color = color;
    attrText.lineSpacing = 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) text:attrText];
    return layout;
}

@end


#pragma mark -
#pragma mark - 图片资源信息
@implementation CGoodsImgInfo

- (CGFloat)imageHeight {
    if (_width == 0 || _height == 0) {
        return ScreenWidth;
    }
    CGFloat scale = _width/_height;
    return round(ScreenWidth/scale);
}

- (void)setUrl:(NSString *)url {
    //url中文转码
    _url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setOrig_image:(NSString *)orig_image {
    //url中文转码
    _orig_image = [orig_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setVideo_url:(NSString *)video_url {
    //url中文转码
    _video_url = [video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end


#pragma mark -
#pragma mark - 商品参数
@implementation CGoodsAttrData

@end


#pragma mark -
#pragma mark - 商家店铺信息
@implementation CShopInfo

- (void)setHead_img:(NSString *)head_img {
    //url中文转码
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

