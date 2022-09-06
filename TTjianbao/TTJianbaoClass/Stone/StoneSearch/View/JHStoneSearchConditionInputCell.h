//
//  JHStoneSearchConditionInputCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSearchConditionInputCell : JHBaseCollectionViewCell

@property (nonatomic, strong) UITextField *lowPriceTf;

@property (nonatomic, strong) UITextField *heighPriceTf;

@property (nonatomic, copy) void(^inputChangeBlock)(NSString *lowStr,NSString *heighStr);

@end

NS_ASSUME_NONNULL_END
