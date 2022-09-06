//
//  JHSearchViewController_NEW.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHSearchFromSource) {
    JHSearchFromStore,     //天天商城
    JHSearchFromLive,      //源头直购（直播）
    JHSearchFromCommunity, //社区
    JHSearchFromC2C,       //C2C
};
@interface JHSearchViewController_NEW : JHBaseViewController

///搜索页面来源
@property (nonatomic, assign) JHSearchFromSource fromSource;
///搜索提示词
@property (nonatomic,   copy) NSString *placeholder;
///搜索词
@property (nonatomic,   copy) NSString *searchWord;

@end

NS_ASSUME_NONNULL_END
