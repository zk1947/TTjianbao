//
//  JHRecycleHomeSubGoodsViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeSubGoodsViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, copy) NSString *productCateId;
@end

NS_ASSUME_NONNULL_END
