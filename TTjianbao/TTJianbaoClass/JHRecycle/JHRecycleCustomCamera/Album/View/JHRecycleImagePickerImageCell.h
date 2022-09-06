//
//  JHRecycleImagePickerImageCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImagePickerBaseCell.h"

#import "JHRecycleImagePickerCellViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImagePickerImageCell : JHRecycleImagePickerBaseCell
@property (nonatomic, strong) JHRecycleImagePickerCellViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
