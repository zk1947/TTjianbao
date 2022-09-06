//
//  JHPublishCateModel.h
//  TTjianbao
//
//  Created by apple on 2019/7/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHPublishCateModel,JHPublishSubCateModel;

@interface JHPublishChannelModel : NSObject

@property (nonatomic, copy) NSString *channel_id;
@property (nonatomic, copy) NSString *channel_name;
@property (nonatomic, assign) BOOL is_selected;
@property (nonatomic, copy) NSArray <JHPublishCateModel*>*items;

/**
获取发布分类
 @param completion completion description
 */
+ (void)requestPublishCatelist:(JHApiRequestHandler)completion;

/**
 获取搜索分类

 @param completion completion description
 */
+ (void)requestSearchCatelist:(JHApiRequestHandler)completion;
@end


@interface JHPublishCateModel : NSObject

@property (nonatomic, copy) NSString *cateId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <JHPublishSubCateModel*>*items;

@end

@interface JHPublishSubCateModel : NSObject

@property (nonatomic, copy) NSString *subCateId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *show_search_key;
@property (nonatomic, copy) NSString *push_search_key;
@end

NS_ASSUME_NONNULL_END
