//
//  JHMallGroupHeaderView.h
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHOperationImageModel;

static NSString *const kJHMallGroupHeaderViewIdentifer = @"kJHMallGroupHeaderViewIdentifer";

typedef void (^HeaderClickBlock)(JHOperationImageModel *bannerModel, NSInteger selectIndex);

@interface JHMallGroupHeaderView : UICollectionReusableView

@property (nonatomic, copy) HeaderClickBlock clickBlock;
@property (nonatomic, strong) NSArray<JHOperationImageModel *> *bannerList;

+ (CGFloat)bannerHeight;

@end

NS_ASSUME_NONNULL_END
