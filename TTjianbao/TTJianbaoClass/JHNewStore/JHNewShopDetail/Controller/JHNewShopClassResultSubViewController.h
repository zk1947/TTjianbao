//
//  JHNewShopClassResultSubViewController.h
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopClassResultSubViewController : UIViewController<JXCategoryListContentViewDelegate>
///第几个标签 0：全部 1：拍卖  2：一口价
@property (nonatomic, assign) NSInteger titleTagIndex;
///店铺ID
@property (nonatomic, copy) NSString *shopID;
///是否显示标题标签
@property (nonatomic, assign) BOOL isShowTitleTag;
///分类ID
@property (nonatomic, assign) NSInteger cateId;

@end

NS_ASSUME_NONNULL_END
