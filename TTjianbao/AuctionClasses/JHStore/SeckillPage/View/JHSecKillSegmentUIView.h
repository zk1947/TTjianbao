//
//  JHSecKillSegmentUIView.h
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSecKillTitleMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSecKillSegmentUIView :UIView
@property (nonatomic, copy) NSArray<JHSecKillTitleMode *> *titles;
-(void)setUpSegmentView:(NSArray<JHSecKillTitleMode *> *)titles;
/// item点击事件的回调
@property (nonatomic, copy) void (^selectedItemHelper)(NSInteger index);

- (void)setCurrentIndex:(NSUInteger)targetIndex;

@end
NS_ASSUME_NONNULL_END
