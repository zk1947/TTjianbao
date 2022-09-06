//
//  JHMallGroupViewController.h
//  TTjianbao
//  Description:其他分类
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHMallBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMallGroupViewController : JHMallBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, copy)NSString *prentId;
@property (nonatomic, copy)NSString *parentName;

@end

NS_ASSUME_NONNULL_END
