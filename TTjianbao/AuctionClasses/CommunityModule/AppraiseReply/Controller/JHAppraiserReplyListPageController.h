//
//  JHAppraiserReplyListPageController.h
//  TTjianbao
//
//  Created by lihui on 2020/3/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  鉴定贴回复 - 带有标签栏的 未回复、已回复 列表框架
//

#import "BaseTitleBarController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiserReplyListPageController : BaseTitleBarController <JXCategoryListContentViewDelegate>

///回复类型
@property(nonatomic, strong) NSString *applyType;


@end

NS_ASSUME_NONNULL_END
