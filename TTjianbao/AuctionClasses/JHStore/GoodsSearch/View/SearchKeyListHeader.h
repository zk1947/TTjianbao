//
//  SearchKeyListHeader.h
//  ForkNews
//
//  Created by wuyd on 2018/5/14.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHeaderId_SearchKeyListHeader   @"SearchKeyListHeaderIdentifier"

/** 搜索词分类 */
typedef NS_ENUM(NSInteger, YDSearchKeyType) {
    YDSearchKeyTypeHistory = 0, //搜索历史
    YDSearchKeyTypeHot  //猜你关心的
};

@interface SearchKeyListHeader : UICollectionReusableView

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) YDSearchKeyType keyType;

@property (nonatomic, copy) void(^deleteBtnClickBlock)(void);

+ (CGFloat)headerHeight;

@end
