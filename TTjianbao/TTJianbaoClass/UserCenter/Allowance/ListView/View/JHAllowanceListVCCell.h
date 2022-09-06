//
//  JHAllowanceListVCCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHAllowanceListViewModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 津贴 type View
@interface JHAllowanceListVCCell : JHBaseCollectionViewCell

@property (nonatomic, strong) JHAllowanceListViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
