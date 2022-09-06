//
//  JHIssueGoodsEditModel.h
//  TTjianbao
//
//  Created by zk on 2021/8/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHIssueGoodsEditModel : NSObject

@property (nonatomic, copy) NSString *thirdCategoryName;

@property (nonatomic, strong) NSArray *mainImageUrl;

@property (nonatomic, copy) NSString *productDesc;

@property (nonatomic, strong) NSArray *backProductPicConfResponses;

@property (nonatomic, strong) NSDictionary *orderDiscountListResp;

@property (nonatomic, assign) int productId;

@property (nonatomic, strong) NSArray *detailImages;

@property (nonatomic, assign) int productType;

@property (nonatomic, strong) NSArray *backAttrRelationResponses;

@property (nonatomic, strong) NSArray *attrs;

@property (nonatomic, copy) NSString *secondCategoryName;

@property (nonatomic, assign) int secondCategoryId;

@property (nonatomic, copy) NSString *firstCategoryName;

@property (nonatomic, strong) NSDictionary *area;

@property (nonatomic, strong) NSDictionary *price;

@property (nonatomic, strong) NSDictionary *auction;

@property (nonatomic, copy) NSString *productSn;

@property (nonatomic, strong) NSDictionary *appraisalCategoryAttrDTO;

@property (nonatomic, assign) int firstCategoryId;

@property (nonatomic, assign) int thirdCategoryId;

@end

@interface JHIssueGoodsEditImageItemModel : NSObject

@property (nonatomic, assign) int height;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) int width;

@property (nonatomic, copy) NSString *middleUrl;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *detailVideoCoverUrl;

@property (nonatomic, copy) NSString *path;

@end


NS_ASSUME_NONNULL_END
