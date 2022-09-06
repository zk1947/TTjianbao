//
//  JHStoreHomeSeckillHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHStoreHomeShowcaseModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kHeaderId_JHSeckillHeaderId = @"JHStoreHomeSeckillHeaderIdentifer";

@interface JHStoreHomeSeckillHeader : UICollectionReusableView

@property (nonatomic, strong) JHStoreHomeShowcaseModel *showcaseModel;

+ (CGFloat)headerHeight;

@end


NS_ASSUME_NONNULL_END
