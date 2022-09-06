//
//  JHC2CSearchResultSubViewController.h
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSearchResultSubViewController : UIViewController<JXCategoryListContentViewDelegate>
///第几个标签 0：全部 1：拍卖  2：一口价
@property (nonatomic, assign) NSInteger titleTagIndex;
///搜索页--关键字
@property (nonatomic, copy) NSString *keyword;
///搜索页--关键词来源
@property (nonatomic, copy) NSString *keywordSource;

///分类页--分类id
@property (nonatomic, copy) NSString *classID;
///分类页--分类名
@property (nonatomic, copy) NSString *className;
///分类类标点击来源 1:查看全部(一级分类)  2：列表（二级分类）
@property (nonatomic, copy) NSString *classClickFrom;

@end

NS_ASSUME_NONNULL_END
