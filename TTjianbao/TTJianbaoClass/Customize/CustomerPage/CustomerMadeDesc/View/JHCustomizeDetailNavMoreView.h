//
//  JHCustomizeDetailNavMoreView.h
//  TTjianbao
//
//  Created by user on 2020/11/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeDetailNavMoreView : UIView
@property (nonatomic,   copy) dispatch_block_t shareActionBlock;
@property (nonatomic,   copy) dispatch_block_t hiddenActionBlock;
@property (nonatomic, assign) BOOL hasHidden;

@property (nonatomic, assign) BOOL hasHiddenButton;

@end

NS_ASSUME_NONNULL_END
