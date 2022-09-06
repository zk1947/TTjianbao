//
//  JHRecycleImageTemplateView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleImageTemplateViewModel.h"

static const CGFloat TemplateItemSpace = 4.f;
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleImageTemplateView : UIView
@property (nonatomic, strong) JHRecycleImageTemplateViewModel *viewModel;

@property (nonatomic, assign) RecycleTemplateCellType type;

@property (nonatomic, copy) void (^cellClickIndex)(NSInteger selectIndex);

- (instancetype)initWithType : (RecycleTemplateCellType)type;
- (void)scrollToItem;
@end

NS_ASSUME_NONNULL_END
