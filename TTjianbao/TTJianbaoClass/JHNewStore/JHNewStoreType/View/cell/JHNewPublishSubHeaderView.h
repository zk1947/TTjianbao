//
//  JHNewPublishSubHeaderView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewPublishSubHeaderView : UICollectionReusableView
@property(nonatomic, assign) NSInteger  section;
@property (nonatomic, strong) NSString *title;
@property(nonatomic, copy) void (^showAllActionBlock)(NSInteger section);
@end

NS_ASSUME_NONNULL_END
