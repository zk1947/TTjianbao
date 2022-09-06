//
//  CStoreChannelModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  商城首页-分类导航标签
//

#import "YDBaseModel.h"

@class CStoreChannelData;

NS_ASSUME_NONNULL_BEGIN

@interface CStoreChannelModel : YDBaseModel

@property (nonatomic, strong) NSMutableArray<CStoreChannelData *> *list;

- (NSString *)toUrl;
- (void)configModel:(CStoreChannelModel *)model;

@end


#pragma mark -
#pragma mark - CStoreChannelData

@interface CStoreChannelData : NSObject
@property (nonatomic, assign) NSInteger channel_id; //int 标签id
@property (nonatomic, assign) NSInteger channel_type; //0默认 1专题分类
@property (nonatomic, assign) BOOL is_default; //BOOL 是否是默认选项
@property (nonatomic,   copy) NSString *channel_name; //标签名
@end

NS_ASSUME_NONNULL_END
