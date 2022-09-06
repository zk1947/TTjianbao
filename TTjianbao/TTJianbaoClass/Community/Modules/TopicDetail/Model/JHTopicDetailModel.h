//
//  JHTopicDetailModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailCateModel : NSObject

/// 阅读
@property (nonatomic, copy) NSString *scan_num;

/// 评论
@property (nonatomic, copy) NSString *comment_num;

/// 内容
@property (nonatomic, copy) NSString *content_num;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@end


@interface JHTopicDetailShareInfoModel : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@end

@interface JHTopicDetailInfoModel : NSObject

@property (nonatomic, copy) NSString *bg_image;

@property (nonatomic, copy) NSString *bg_wh_scale;

@property (nonatomic, copy) NSString *comment_num;

@property (nonatomic, copy) NSString *content_num;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) BOOL is_show_join;

@property (nonatomic, copy) NSString *join_num;

@property (nonatomic, copy) NSString *scan_num;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *desc_num;

@property (nonatomic, strong) JHShareInfo *share_info;

@end

@interface JHTopicDetailModel : NSObject

@property (nonatomic, strong) JHTopicDetailInfoModel *topic;

@property (nonatomic, copy) NSArray <JHTopicDetailCateModel *> *cate_tabs;

@end

NS_ASSUME_NONNULL_END
