//
//  JHSellerInfo.h
//  TTjianbao
//
//  Created by apple on 2019/12/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "YDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHGoodsInfoMode;

/*
 "show_post_int" = 0;
 
 */


@interface JHSellerInfo : YDBaseModel

@property (nonatomic, strong) NSNumber *seller_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head_img;
@property (nonatomic, copy) NSString *bg_img;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSString *publish_num;
@property (nonatomic, strong) NSString *like_num;
@property (nonatomic, assign) NSInteger fans_num_int;
@property (nonatomic, strong) NSString *fans_num;
@property (nonatomic, strong) NSNumber *follow_status;
@property (nonatomic, copy) NSString *onsale_desc;
@property (nonatomic, strong) NSString *show_post_num;   ///晒宝数

///商品数据
@property (nonatomic,strong) NSArray <JHGoodsInfoMode*>*goodsArray;

///自己加的字段
@property (nonatomic,assign) CGFloat cellheight;

@end

NS_ASSUME_NONNULL_END
