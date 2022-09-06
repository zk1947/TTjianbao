//
//  JHRecycleOrderBusinessImageViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessImageViewModel : JHRecycleOrderBusinessBaseViewModel
@property (nonatomic, copy) NSString *imageUrl;

- (void)setupDataWithImageUrl : (NSString *)imageUrl
                        scale : (CGFloat)scale;


@end

NS_ASSUME_NONNULL_END
