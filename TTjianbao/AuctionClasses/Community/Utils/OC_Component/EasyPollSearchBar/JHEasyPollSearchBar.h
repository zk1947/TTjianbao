//
//  JHEasyPollSearchBar.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  轮询显示placeholder文本的搜索框
//

#import "UITapView.h"
#import "JHHotWordModel.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kEasyPollSearchBarHeight = 30; //搜索框高度

typedef NS_ENUM(NSInteger, JHSearchBarShowFromSoure) {
    JHSearchBarShowFromSoureHome           = 1,  //一级首页
//    JHSearchBarShowFromSoureCate           = 2,  //分类页
};

@interface JHEasyPollSearchBar : UITapView
@property (nonatomic, copy) void(^didSelectedBlock)(NSInteger selectedIndex, BOOL isLeft);
@property (nonatomic, strong) NSArray<JHHotWordModel *> *placeholderArray; //轮询显示的占位字符串数组
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIImageView *iconView; //图标
@property (nonatomic, assign) BOOL stopScroll;

///搜索框显示来源
@property (nonatomic, assign) JHSearchBarShowFromSoure searchBarShowFrom;

@end

NS_ASSUME_NONNULL_END
