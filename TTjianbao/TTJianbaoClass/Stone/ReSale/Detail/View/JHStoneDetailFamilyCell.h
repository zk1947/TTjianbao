//
//  JHStoneDetailFamilyCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailFamilyCell : JHWBaseTableViewCell

@property (nonatomic, strong) JHWebView *webView;

@property (nonatomic, copy) dispatch_block_t enterFamilyTreeMethod;

- (void)reloadWebView;

@end

NS_ASSUME_NONNULL_END
