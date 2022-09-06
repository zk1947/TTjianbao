//
//  JHOrderHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol JHOrderSegmentViewViewDelegate <NSObject>

- (void)segMentButtonPress:(UIButton *)button;

@end

@interface JHOrderSegmentView : BaseView
-(void)setUpSegmentView:(NSArray*)titles;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, assign)int currentIndex;
@property (nonatomic, weak) id<JHOrderSegmentViewViewDelegate> delegate;
-(void)setIndicateViewImage:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
