//
//  JHRecycleOrderBusinessDesViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessDesViewModel : JHRecycleOrderBusinessBaseViewModel
/// 描述
@property (nonatomic, copy) NSAttributedString *attDesText;
/// 描述
@property (nonatomic, copy) NSString *desText;
@end

NS_ASSUME_NONNULL_END
