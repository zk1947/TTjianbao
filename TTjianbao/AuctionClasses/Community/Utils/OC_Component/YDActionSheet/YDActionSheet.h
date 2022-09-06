//
//  YDActionSheet.h
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/29.
//  Copyright © 2019 Wuyd. All rights reserved.
//  v1.0.1
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDActionSheet : UIView

+ (void)yd_showActionSheetTitle:(nullable NSString *)title
                     itemTitles:(nullable NSArray<NSString *> *)itemTitles
                          block:(void(^)(NSInteger index))block;

+ (void)yd_showActionSheetTitle:(nullable NSString *)title
                     itemTitles:(nullable NSArray<NSString *> *)itemTitles
               destructiveIndex:(NSInteger)destructiveIndex
                          block:(void(^)(NSInteger index))block;

@end

NS_ASSUME_NONNULL_END
