//
//  JHStoreDetailCellViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHStoreDetailConst.h"

typedef NS_ENUM(NSInteger, CellType){
    PriceCell,
    TitleCell,
    TagCell,
    SpecialCell,
    CouponCell,
    EducationCell,
    ShopTitleCell,
    ShopCell,
    SpecCell,
    SectionTitleCell,
    GoodsDesCell,
    ImageCell,
    SecurityCell,
    ///拍卖出价记录
    AuctionListCell,
    ///评论header
    CommentHeaderCell,
    ///评价留言
    CommentCell,
    ///同店好货
    SameShopCell,
    ///为你推荐
    RecommentCell,

};

typedef NS_ENUM(NSInteger, SectionType){
    /// 标题、价格、标签区
    SectionType_topPrice,
    /// 优惠券 区
    SectionType_Coupon,
    /// 用户教育
    SectionType_Education,
    ///规格参数、 商品介绍、商品大图、区
    SectionType_ProductDetail,
    ///店铺 区域
    SectionType_Shop,
    ///保障图片区域
    SectionType_BaoZhang,
    ///拍卖出价记录
    SectionType_AuctionList,
    ///评论 区域
    SectionType_Comment,
    ///同店好货
    SectionType_SameShop,
    ///为你推荐
    SectionType_Recomment,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCellBaseViewModel : NSObject

/// 区域类型 当作为section model
@property (nonatomic, assign) SectionType sectionType;

/// cell 类型  作为cell model
@property (nonatomic, assign) CellType cellType;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) RACSubject *reloadCellSubject;
@property (nonatomic, strong) RACSubject *pushvc;

@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger rowIndex;
@end

NS_ASSUME_NONNULL_END
