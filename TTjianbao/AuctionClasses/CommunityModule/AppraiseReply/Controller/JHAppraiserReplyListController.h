//
//  JHAppraiserReplyListController.h
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//  鉴定贴回复 - 未回复、已回复列表
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiserReplyListController : JHBaseViewExtController <JXCategoryListContentViewDelegate>

///回复类型 0未回复 1已回复
@property(nonatomic, strong) NSString *applyType;
///标签id
@property(nonatomic, strong) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
