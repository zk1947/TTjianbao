//
//  JHDetailHotNewSwtchView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDetailHotNewSwtchView : UIView

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void (^selectBlock) (NSInteger index);

+ (CGSize)viewSize;

- (void)setSwitchBtnName:(NSArray<NSString *>*)nameArr;

@end

NS_ASSUME_NONNULL_END
