//
//  JHRecycleOrderBusinessVideoViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessVideoViewModel : JHRecycleOrderBusinessBaseViewModel
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) RACSubject *playEvent;

- (void)setupDataWithImageUrl : (NSString *)imageUrl
                     videoUrl : (NSString *)videoUrl
                        scale : (CGFloat)scale;
@end

NS_ASSUME_NONNULL_END
