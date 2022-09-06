//
//  JHDiscoverChannelCateModel.m
//  TTjianbao
//
//  Created by jingxin on 2019/5/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHDiscoverChannelCateModel.h"
#import "CTopicDetailModel.h"


@implementation MyShareModel
@end

@implementation Publisher

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"isSpecialSale" : @"is_special_sale",
        @"sellerId" : @"seller_id",
        @"userTycoonLevelIcon" : @"consume_tag_icon",
    };
}

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isSpecialSale" : @"is_special_sale",
             @"sellerId" : @"seller_id",
             @"userTycoonLevelIcon" : @"consume_tag_icon"
    };
}

@end

@interface JHDiscoverChannelCateModel()
/// 是否文字内容赋值
@property (nonatomic , assign) BOOL isTitleValua;
/// 是否文字行数赋值
@property (nonatomic , assign) BOOL isTitleNumValua;
/// 是否赋值图片宽比
@property (nonatomic , assign) BOOL isWHValua;
//是否赋值标签属性
@property (nonatomic, assign) BOOL isSaleTagValue;
@end

@implementation JHDiscoverChannelCateModel
@synthesize wh_scale = _wh_scale;

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"saleInfo" : @"especially_buy_info"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"saleInfo" : [CTopicSaleInfo class]};
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _isTitleNumValua = YES;
        _title_row = 1;
        _isSaleTagValue = YES;
        [JHDiscoverChannelCateModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"saleInfo" : @"especially_buy_info"
                     };
        }];
    }
    return self;
}

- (CGFloat)wh_scale {
    return _wh_scale;
}

- (void)setWh_scale:(CGFloat)wh_scale
{
    if (wh_scale <= 0.75) {
        _wh_scale = 0.75;
    }else if (wh_scale >= 1) {
        _wh_scale = 1.0;
    }
    else {
        _wh_scale = wh_scale;
    }
    self.picHeight = (ScreenW-25) * 0.5 / _wh_scale;
    self.isWHValua = YES;
    [self calculateCellheigh];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.isTitleValua = YES;
    [self calculateTitleheigh];
    [self calculateCellheigh];
}
- (void)setTitle_row:(NSInteger)title_row
{
    _title_row = title_row;
    self.isTitleNumValua = YES;
    [self calculateTitleheigh];
    [self calculateCellheigh];
}

- (void)setSale_tag:(NSString *)sale_tag {
    _sale_tag = sale_tag;
    self.isSaleTagValue = YES;
    [self calculateTitleheigh];
    [self calculateCellheigh];
}

- (void)calculateTitleheigh
{
    if (self.isTitleValua && self.isTitleNumValua && self.isSaleTagValue)
    {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:self.title ? self.title : @""];//
        if ([self.sale_tag isEqualToString:@"1"]) {
            UIImage *image = [UIImage imageNamed:@"dis_canSale"];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = image;
            attch.bounds = CGRectMake(0, -2, image.size.width, image.size.height);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
        }
        
        [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:14] range:NSMakeRange(0, attri.length)];
        
        CGFloat titleH = [attri boundingRectWithSize:CGSizeMake((ScreenW-25) * 0.5 - 10, 25 * self.title_row) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
        self.titleHeight = titleH > 25 * self.title_row ? 25 * self.title_row : ceil(titleH);
    }
}

- (void)calculateCellheigh
{
    if (self.isTitleNumValua && self.isTitleValua && self.isWHValua && self.isSaleTagValue)
    {
        self.height = ceil(self.picHeight)+ceil(self.titleHeight)+35;
    }
}

- (BOOL)isLegalData {
    switch (self.item_type) {
        case JHSQItemTypeArticle:
        case JHSQItemTypeGoods: {
            if (self.layout == JHSQLayoutTypeImageText ||
                self.layout == JHSQLayoutTypeVideo ||
                self.layout == JHSQLayoutTypeAppraisalVideo) {
                return YES;
            } else {
                return NO;
            }
        }
            break;
        case JHSQItemTypeAD: {
            if (self.layout == JHSQLayoutTypeAD ||
                self.layout == JHSQLayoutTypeLiveStore) {
                return YES;
            } else {
                return NO;
            }
        }
        case JHSQItemTypeTopic: {
            if (self.layout == JHSQLayoutTypeTopic) {
                return YES;
            } else {
                return NO;
            }
        }
        case JHSQItemTypeVote:
        case JHSQItemTypeGuess: {
            if (self.layout == JHSQLayoutTypeImageText) {
                return YES;
            } else {
                return NO;
            }
        }
        default:
            return NO;
            break;
    }
}
/*
 *校验API返回的数据，过滤掉不合法的数据
 */
+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray {
    NSMutableArray *array = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    NSMutableArray *endArr = [NSMutableArray arrayWithCapacity:array.count];
    for (JHDiscoverChannelCateModel *model in array) {
        if ([model isLegalData]) {
            [endArr addObject:model];
        }
    }
    return endArr;
}

@end
