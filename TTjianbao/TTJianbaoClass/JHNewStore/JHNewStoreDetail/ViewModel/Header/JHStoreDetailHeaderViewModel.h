//
//  JHStoreDetailHeaderViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品header ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCycleViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailHeaderViewModel : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) JHStoreDetailCycleViewModel *sycleViewModel;

/// 设置header 数据
/// url : 视频地址
/// list : 图片地址
/// mediumlist : 图片 中图 地址
- (void)setupDataWithVideoUrl : (NSString *)url
                    imageList : (NSArray<NSString *>*)list
                   mediumUrls : (NSArray<NSString *>*)mediumlist;
@end

NS_ASSUME_NONNULL_END
