//
//  JHSQCollectListViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/6/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
#import "JHBaseListPlayerViewController.h"
#import "JXCategoryListContainerView.h"
#import "JHSQUploadView.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHSQCollectListViewController : JHBaseListPlayerViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) JHFinishBlock refreshCountBlock;

@end

NS_ASSUME_NONNULL_END
