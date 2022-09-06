//
//  JHStoreRankTagModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreRankTagListModel : NSObject
//标签id
@property (nonatomic, copy) NSString *tagId;
//标签名
@property (nonatomic, copy) NSString *tagName;

@end

@interface JHStoreRankTagModel : NSObject
//显示名称
@property (nonatomic, copy) NSString *topTitleName;
//显示名称
@property (nonatomic, copy) NSString *showName;
//背景图
@property (nonatomic, copy) NSString *bgImgUrl;
//榜单标签列表
@property (nonatomic, strong) NSArray <JHStoreRankTagListModel *>*tagList;

@end

NS_ASSUME_NONNULL_END
