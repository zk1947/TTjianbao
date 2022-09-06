//
//  JHAutoRunView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, RunDirectionType) {
    LeftType = 0,
    RightType = 1,
};

typedef NS_ENUM(NSInteger, ViewMaskDirectionType) {
    ViewMaskDirectionTypeLeft = 0,
    ViewMaskDirectionTypeRight,
};

@class JHAutoRunView;

@protocol JHAutoRunViewDelegate <NSObject>

@optional
- (void)operateLabel:(JHAutoRunView *)autoLabel animationDidStopFinished: (BOOL)finished;

@end

@interface JHAutoRunViewModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic,assign) NSInteger showStyle;
@end

@interface JHAutoRunView : BaseView

@property (nonatomic, weak) id <JHAutoRunViewDelegate> delegate;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) RunDirectionType directionType;
@property (nonatomic, assign) ViewMaskDirectionType viewMaskDirectionType;

-(void)addAnimationText:(NSString *)text andIcon:(NSString *)iconurl andshowStyle:(NSInteger)showStyle;
//- (void)addContentView:(UIView *)view;
- (void)startAnimation;
- (void)stopAnimation;
- (void)stopAndRemove;

@end

NS_ASSUME_NONNULL_END
