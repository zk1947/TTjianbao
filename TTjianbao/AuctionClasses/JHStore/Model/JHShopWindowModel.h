//
//  JHShopWindowModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/5/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  3.1.7专题(橱窗)页改版 - 橱窗信息数据
//  不包含导航标签列表下的商品数据（使用 JHShopWindowListModel）
//

#import "YDBaseModel.h"
#import "JHStoreHomeCardModel.h"

@class JHShopWindowInfo;
@class JHShopWindowTagInfo;

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowModel : YDBaseModel

//自定义接口请求字段
@property (nonatomic, assign) NSInteger sc_id; //橱窗id

//接口返回数据
@property (nonatomic, strong) JHShopWindowInfo *windowInfo; //专题信息<cover_info>
@property (nonatomic, strong) NSMutableArray <JHShopWindowTagInfo *> *tagList; //导航标签列表<tag_list>
@property (nonatomic, strong) JHShareInfo *shareInfo; //<share_info>

//自定义导航标签栏标题
@property (nonatomic, strong) NSMutableArray <NSString *> *tagTitles;

- (NSString *)toUrl; //获取专题信息url
- (void)configModel:(JHShopWindowModel *)model;

@end


#pragma mark - 专题信息
@interface JHShopWindowInfo : JHStoreHomeShowcaseModel

@end


#pragma mark - 标签信息
@interface JHShopWindowTagInfo : NSObject
@property (nonatomic, assign) NSInteger tag_id; //标签id
@property (nonatomic,   copy) NSString *tag_name; //标签名
@end


NS_ASSUME_NONNULL_END
