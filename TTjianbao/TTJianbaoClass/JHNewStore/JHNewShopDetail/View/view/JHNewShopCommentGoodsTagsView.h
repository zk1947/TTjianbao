//
//  JHNewShopCommentGoodsTagsView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width-24
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define TagsTitleFont [UIFont systemFontOfSize:12]

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopCommentGoodsTagsView : UIView
/** 标签名字数组 */
@property (nonatomic, copy) NSArray *tagsArray;
/** 标签frame数组 */
@property (nonatomic, strong) NSMutableArray *tagsFrames;
/** 全部标签的高度 */
@property (nonatomic, assign) CGFloat tagsViewHeight;
/** 标签间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMargin;
/** 标签行间距 default is 10*/
@property (nonatomic, assign) CGFloat tagsLineSpacing;
/** 标签最小内边距 default is 10*/
@property (nonatomic, assign) CGFloat tagsMinPadding;
/** 标签高度 default is 30*/
@property (nonatomic, assign) CGFloat tagHeight;

@end

NS_ASSUME_NONNULL_END
