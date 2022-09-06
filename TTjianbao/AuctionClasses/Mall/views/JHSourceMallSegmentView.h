//
//  JHSourceMallSegmentView.h
//  TTjianbao
//
//  Created by jiang on 2019/8/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "VideoCateMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSourceMallSegmentView : BaseView
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIColor *backColor;
/// titles
@property (nonatomic, copy) NSArray<VideoCateMode *> *titles;

/// 初始选中的下标
@property (nonatomic) NSInteger originalIndex;

/// 当前选中的下标
@property (nonatomic, assign) NSInteger selectedIndex;

/// item点击事件的回调
@property (nonatomic, copy) void (^selectedItemHelper)(NSInteger index);

@property (nonatomic) CGFloat segmentWidth;
/**
 使collectionViewd滚动到指定的cell
 
 @param targetIndex 目标cell的index
 */
- (void)changeItemToTargetIndex:(NSUInteger)targetIndex;
-(void)initSegmentScrollView;
-(void)showRedDot;
@end

NS_ASSUME_NONNULL_END
