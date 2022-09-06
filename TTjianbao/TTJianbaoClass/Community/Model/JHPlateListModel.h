//
//  JHPlateListModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  版块数据
//

#import "YDBaseModel.h"

@class JHPlateListData;

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateListModel : YDBaseModel
@property (nonatomic, strong) NSMutableArray <JHPlateListData *> *list;
- (NSString *)toUrl;
@end


@interface JHPlateListData : NSObject
@property (nonatomic, copy) NSString  *channel_id;
@property (nonatomic, copy) NSString  *channel_name;
@property (nonatomic, copy) NSString  *image;

///评论数字
@property (nonatomic, copy) NSString *comment_num;

///内容数字
@property (nonatomic, copy) NSString *content_num;

///浏览数字
@property (nonatomic, copy) NSString *scan_num;
@property (nonatomic, copy) NSString *desc;

/// 埋点统计用
@property (nonatomic, assign) NSInteger index;

@end


NS_ASSUME_NONNULL_END
