//
//  MCDatePicker.h
//  Mclouds
//
//  Created by Jiwei Wang on 2020/8/4.
//  Copyright © 2020 Mclouds. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDatePicker : UIView
@property (nonatomic, strong)void(^selectBlock)(NSString *str);

@property (nonatomic, strong) NSDate *minBegionTime;
@property (nonatomic, strong) NSDate *maxBegionTime;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *titleText;

- (void)setupDate : (NSDate *)date;
@end

NS_ASSUME_NONNULL_END
