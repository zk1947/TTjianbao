//
//  JHRecycleMinePublishedViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleMinePublishedViewController : JHBaseViewController <JXCategoryListContentViewDelegate>
/** 是否是发布中*/
@property (nonatomic, copy) NSString *listType;
@end

NS_ASSUME_NONNULL_END
