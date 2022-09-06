//
//  JHNewSearchResultRecommendTagsModel.h
//  TTjianbao
//
//  Created by hao on 2021/10/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewSearchResultRecommendTagsListModel : NSObject
///关键词ID
@property (nonatomic,   copy) NSString *cateId;
///图标地址
@property (nonatomic,   copy) NSString *tagIocnUrl;
///标签关键字
@property (nonatomic,   copy) NSString *tagWord;

@end


@interface JHNewSearchResultRecommendTagsModel : NSObject
@property (nonatomic,   copy) NSArray<JHNewSearchResultRecommendTagsListModel *> *keyTagList;

@end

NS_ASSUME_NONNULL_END
