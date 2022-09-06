//
//  UIView+PressMenu.h
//  EMeal_Cook
//
//  Created by Ease on 15/10/17.
//  Copyright (c) 2015年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PressMenu)

@property (nonatomic, copy) void(^menuClickedBlock)(NSInteger index, NSString *title);

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressGR;
@property (nonatomic, strong) UIMenuController *menuVC;

- (void)addPressMenuTitles:(NSArray *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;
- (void)showMenuTitles:(NSArray *)menuTitles menuClickedBlock:(void(^)(NSInteger index, NSString *title))block;

- (BOOL)isMenuVCVisible;
- (void)removePressMenu;

@end
