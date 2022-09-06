//
//  ZQSearchViewController.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/20.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQSearchConst.h"

typedef NS_ENUM(NSUInteger, ZQSearchBarStyle) {
    ZQSearchBarStyleNone,
    ZQSearchBarStyleCannel,
    ZQSearchBarStyleBack,
};

typedef NS_ENUM(NSUInteger, ZQSearchState) {
    ZQSearchStateNormal,
    ZQSearchStateEditing,
    ZQSearchStateResult,
};


typedef NS_ENUM(NSUInteger, ZQSearchFrom) {
    ZQSearchFromStore,     //天天商城
    ZQSearchFromLive,      //源头直购（直播）
    ZQSearchFromCommunity, //社区
    ZQSearchFromC2C,       //C2C
};


@protocol ZQSearchViewDelegate<NSObject>

@required
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from;
@optional
- (void)searchEditViewRefreshWithKeyString:(NSString *)keyString DataBlock:(void(^)(id data))block;
- (void)searchConfirmResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController;

@end


@interface ZQSearchViewController : UIViewController

//channelId之前全部传的0,没有用到.定制二期正好用一下这个自段

- (instancetype)initSearchViewWithFrom:(ZQSearchFrom)from resultController:(UIViewController *)resultController;

- (void)beginToSearch:(NSString *)keyword keywordSource:(NSString *)keywordSource;

@property (nonatomic, weak) id<ZQSearchViewDelegate> delegate;

@property (nonatomic, copy) NSString *placeholder;

@end
