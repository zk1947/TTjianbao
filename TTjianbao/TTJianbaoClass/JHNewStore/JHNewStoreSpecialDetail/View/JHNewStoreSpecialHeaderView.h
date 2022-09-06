//
//  JHNewStoreSpecialHeaderView.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNewStoreSpecialModel.h"
#import "JHNewStoreSpecialShowUser.h"
NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreSpecialHeaderViewDelegate <NSObject>

- (void)descExpandOrPackUp:(CGFloat)maxHeight;

@end

@interface JHNewStoreSpecialHeaderView : UIView

@property (nonatomic ,weak) id <JHNewStoreSpecialHeaderViewDelegate>delegate;

///滚动下拉放大
- (void)updateImageHeight:(float)height;
- (void)resetSpecialDescLabelNumLine;
- (void)resetHeaderViewWithModel:(JHNewStoreSpecialModel *)model;
- (void)resetHeaderViewWithUserModel:(JHNewStoreSpecialShowUser *)model;
- (CGFloat)getDesclabelheight;
@end

NS_ASSUME_NONNULL_END
