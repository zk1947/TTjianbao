//
//  JHRecycleOrderNodeItemViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderNodeBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderNodeItemViewModel : JHRecycleOrderNodeBaseViewModel
@property (nonatomic, copy) NSString *numText;
@property (nonatomic, copy) NSString *detailText;
/// 是否高亮
@property (nonatomic, assign) BOOL isHighlight;


@end

NS_ASSUME_NONNULL_END
