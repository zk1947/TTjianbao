//
//  NTESFiterMenuView.h
//  NEUIDemo
//
//  Created by Netease on 17/1/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESMenuViewProtocol;

typedef NS_ENUM(NSInteger,NTESMenuType)
{
    NTESMenuTypeFilter, //滤镜选项
    NTESMenuTypeAudio , //伴音选项
};

@interface NTESFiterMenuView : UIControl

@property (nonatomic, weak) id <NTESMenuViewProtocol> delegate;

@property (nonatomic, assign) NSInteger selectedIndex; //选择

@property (nonatomic, assign) CGFloat constrastValue; //对比度

@property (nonatomic, assign) CGFloat smoothValue; //磨皮

- (instancetype)initWithType:(NTESMenuType)type;

- (void)show;

- (void)dismiss;

@end

@protocol NTESMenuViewProtocol <NSObject>
@optional
- (void)menuView:(NTESFiterMenuView *)menu didSelect:(NSInteger)index;

- (void)menuView:(NTESFiterMenuView *)menu contrastDidChanged:(CGFloat)value;

- (void)menuView:(NTESFiterMenuView *)menu smoothDidChanged:(CGFloat)value;

- (void)onFilterViewCancelButtonPressed;

- (void)onFilterViewConfirmButtonPressed;

@end
