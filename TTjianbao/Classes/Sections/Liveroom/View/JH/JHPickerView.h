//
//  JHPickerView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "STPickerSingle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPickerView : STPickerSingle <UIPickerViewDelegate>
@property (nonatomic, assign)NSInteger selectedIndex;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
