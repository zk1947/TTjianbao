//
//  JHTimeSelectPickerView.h
//  TTjianbao
//
//  Created by zk on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PickerStyle){
    PickerStartStyle = 1, //发布日期
    PickerEndStyle = 2,   //结束日期
};

typedef void(^SelectTimeBlock)(NSString *timeString);

@interface JHTimeSelectPickerView : UIView

@property (nonatomic, copy) SelectTimeBlock selectTimeBlock;

- (instancetype)initWithFrame:(CGRect)frame withStyle:(PickerStyle)pickerStyle;

-(void)showAlert;

@end

NS_ASSUME_NONNULL_END
