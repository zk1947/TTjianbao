//
//  JHTrackingPostDetailModel.m
//  TTjianbao
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTrackingPostDetailModel.h"

@implementation JHTrackingPostDetailModel
-(void)transitionWithModel:(JHPostDetailModel *)detailModel{
    self.content_id = detailModel.item_id;
    self.content_name = detailModel.title;
//    self.content_type = detailModel.
//    source_page
//    source_module
//    content_type
    NSMutableArray * theme = [NSMutableArray new];
    NSMutableArray * themename = [NSMutableArray new];
    for (JHTopicInfo * info in detailModel.topics) {
        [theme addObject:info.ID];
        [themename addObject:info.name];
    }
    self.theme_id = theme;
    self.theme_name = themename;
    self.section_id = detailModel.plateInfo.ID;
    self.section_name = detailModel.plateInfo.name;
    self.author_id = detailModel.publisher.user_id;
    self.author_name = detailModel.publisher.user_name;
    self.author_role = [self converAuthor_role:detailModel.publisher];
//    self.author_points_level
//    author_consumption_level
}
-(void)transitionWithPostData:(JHPostData *)postModel{
    self.content_id = postModel.item_id;
    self.content_name = postModel.title;
//    self.content_type = detailModel.
//    source_page
//    source_module
//    content_type
    NSMutableArray * theme = [NSMutableArray new];
    NSMutableArray * themename = [NSMutableArray new];
    for (JHTopicInfo * info in postModel.topics) {
        [theme addObject:info.ID];
        [themename addObject:info.name];
    }
    self.theme_id = theme;
    self.theme_name = themename;
    self.section_id = postModel.plate_info.ID;
    self.section_name = postModel.plate_info.name;
    self.author_id = postModel.publisher.user_id;
    self.author_name = postModel.publisher.user_name;
    self.author_role = [self converAuthor_role:postModel.publisher];
}
- (NSString *)converAuthor_role:(JHPublisher *)publisher {
    if (publisher.blRole_default) {
        return @"普通用户";
    } else if (publisher.blRole_appraiseAnchor) {
        return @"鉴定主播";
    } else if (publisher.blRole_saleAnchor) {
        return @"卖货主播";
    } else if (publisher.blRole_saleAnchorAssistant) {
        return @"卖货主播助理";
    } else if (publisher.blRole_communityShop) {
        return @"社区商户";
    } else if (publisher.blRole_maJia) {
        return @"马甲号";
    } else if (publisher.blRole_communityAndSaleAnchor) {
        return @"社区主播、卖货主播";
    } else if (publisher.blRole_restoreAnchor) {
        return @"回血主播";
    } else if (publisher.blRole_restoreAssistant) {
        return @"回血主播助理";
    } else if (publisher.blRole_customize) {
        return @"定制师";
    } else if (publisher.blRole_customizeAssistant) {
        return @"定制师助理";
    } else if (publisher.blRole_recycle) {
        return @"回收师";
    } else if (publisher.blRole_recycleAssistant) {
        return @"回收师助理";
    } else {
        return @"";
    }
}
@end
