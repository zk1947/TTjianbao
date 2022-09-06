//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"

@class JHProviceModel;
@class JHCityModel;
@class JHAreaModel;

NS_ASSUME_NONNULL_BEGIN
@class STPickerArea;
@protocol  STPickerAreaDelegate<NSObject>

///old
//- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area;

///new  --- lh
- (void)pickerArea:(STPickerArea *)pickerArea province:(JHProviceModel *)province city:(JHCityModel *)city area:(JHAreaModel *)area;



@end
@interface STPickerArea : STPickerView
/** 1.中间选择框的高度，default is 32*/
@property(nonatomic, assign)CGFloat heightPickerComponent;
/** 2.保存之前的选择地址，default is NO */
@property(nonatomic, assign, getter=isSaveHistory)BOOL saveHistory;

@property(nonatomic, weak)id <STPickerAreaDelegate>delegate;

@end
NS_ASSUME_NONNULL_END
