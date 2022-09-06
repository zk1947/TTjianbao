//
//  JHRecycleItemViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleItemViewModel : NSObject
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, strong) id dataModel;
@property (nonatomic, assign) NSInteger operatingPosition;
@end

NS_ASSUME_NONNULL_END
