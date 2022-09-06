//
//  JHMarketImagesUpLoadView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketImagesUpLoadView : BaseView
@property (nonatomic, strong) NSArray *imagesUrlArray;
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *imagesArray;
- (instancetype)initWithMaxPhotos:(NSInteger)maxCount;
@end

NS_ASSUME_NONNULL_END
