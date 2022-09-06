//
//  CSaleListModel.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/6.
//  Copyright © 2019 Netease. All rights reserved.
//  特卖列表数据模型
//

#import "YDBaseModel.h"
#import "CTopicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSaleListModel : YDBaseModel

//请求参数 - especially/buy/:item_id/:last_id/:page (last_id：uniq_id)
@property (nonatomic, copy) NSString *last_id; //最后一条数据uniq_id

//返回数据
@property (nonatomic, copy) NSString *item_id; //特卖item_id
@property (nonatomic, copy) NSString *server_time; //服务器当前时间
@property (nonatomic, copy) NSString *end_time; //特卖结束时间
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *contentList;//特卖列表（对应content_list）

- (NSString *)toParams;

- (void)configModel:(CSaleListModel *)model;

@end

NS_ASSUME_NONNULL_END
