//
//  JHStoreDetailCycleItemViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 轮播图 item  viewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"

typedef NS_ENUM(NSUInteger, CycleType) {
    /// 图片
    Image = 1,
    /// 视频
    Video,
};


NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCycleItemViewModel : JHStoreDetailCellBaseViewModel
/// 图片地址
@property (nonatomic, strong) NSString *imageUrl;
/// 类型
@property (nonatomic, assign) CycleType type;

- (instancetype)initWithType : (CycleType)type url : (NSString *)url;
@end

NS_ASSUME_NONNULL_END
