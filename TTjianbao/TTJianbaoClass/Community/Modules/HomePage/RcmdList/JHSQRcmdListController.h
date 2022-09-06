//
//  JHSQRcmdListController.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区首页 - 推荐列表
//

#import "JHBaseListPlayerViewController.h"
#import "JXCategoryView.h"
#import "JHSQUploadView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHSQRcmdListController : JHBaseListPlayerViewController <JXCategoryListContentViewDelegate>

- (void)showUploadProgress;
@property (nonatomic, assign) JHPageType pageType;
@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

@end

NS_ASSUME_NONNULL_END
