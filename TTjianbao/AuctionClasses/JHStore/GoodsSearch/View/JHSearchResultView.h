//
//  JHSearchResultView.h
//  TTjianbao
//
//  Created by LiHui on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///特卖搜索结果页

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchResultView : UIView


///提交热搜词
@property (nonatomic, copy) NSString *keyword;
//展示热搜词
@property (nonatomic, copy) NSString *showKeyword;
@property (nonatomic, copy) NSString *keywordSource;

@property (nonatomic, assign) BOOL isFromSQ; //是否从社区进入

@property (nonatomic, copy) void(^hideKeyBoardBlock)(void);

@property (nonatomic, copy) void (^ disPlayDataIdBlock) (NSString *Id);

///刷新数据
- (void)refresh;

///离开页面前上报浏览商品
- (void)uploadInfoBeforeLeave;


@end

NS_ASSUME_NONNULL_END
