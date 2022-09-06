//
//  JHNewStoreHomeTagView.h
//  TTjianbao
//
//  Created by user on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreHomeTagView : UIView
@property (nonatomic, copy) dispatch_block_t clickBlock;
@property (nonatomic, assign) CGFloat tagViewNeedWidth;
@property (nonatomic, assign) CGFloat tagViewNeedHeight;
@property (nonatomic, assign) BOOL isGoodsInfo;

@property (nonatomic, assign) CGFloat tagTextFont;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *textColor;

- (void)setViewModel:(id __nullable)viewModel;
@end

NS_ASSUME_NONNULL_END
