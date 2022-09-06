//
//  JHImageRecordTimePickerView.h
//  TTjianbao
//
//  Created by liuhai on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHImageRecordTimePickerViewDelegate <NSObject>
-(void)reloadRecordData;

@end

@interface JHImageRecordTimePickerView : UIView
+ (JHImageRecordTimePickerView *)shareManger;
@property(nonatomic,weak) id<JHImageRecordTimePickerViewDelegate>delegate;
-(NSString *)getStartTime;
-(NSString *)getEndTime;
- (void)resetTime;
@end

NS_ASSUME_NONNULL_END
