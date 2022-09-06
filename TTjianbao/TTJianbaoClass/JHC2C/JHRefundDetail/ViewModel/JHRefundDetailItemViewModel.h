//
//  JHRefundDetailItemViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundDetailItemViewModel : NSObject
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) id dataModel;

@end

NS_ASSUME_NONNULL_END
