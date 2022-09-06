//
//  JHOrderListSegmentView.h
//  TTjianbao
//
//  Created by jiang on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JHDiscoverSegmentClickAction)(UIButton *titleBtn);
typedef void (^JHDiscoverSegmentClickMoreAction)(void);

@interface JHOrderListSegmentView :UIView
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger selectIndex;
/// titles
@property (nonatomic, copy) NSArray<NSString *> *titles;
/// 初始选中的下标
@property (nonatomic) NSInteger originalIndex;
/// 当前选中的下标
@property (nonatomic, readonly) NSInteger selectedIndex;
/// item点击事件的回调
@property (nonatomic, copy) void (^selectedItemHelper)(NSInteger index);

/**
 使collectionViewd滚动到指定的cell
 
 @param targetIndex 目标cell的index
 */
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex;
@end
