//
//  JHStoreDetailTitleViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 标题ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailConst.h"
#import "NSAttributedString+YYText.h"

static const CGFloat TitleTopSpace = 10.0f;
static const CGFloat TitleFontSize = 16.0f;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTitleViewModel : JHStoreDetailCellBaseViewModel
/// 标题文本
@property (nonatomic, copy) NSAttributedString *titleText;

/// isOrphan : 是否孤品
- (instancetype)initWithText : (NSString *) text
                    isOrphan : (BOOL)isOrphan;
@end

NS_ASSUME_NONNULL_END
