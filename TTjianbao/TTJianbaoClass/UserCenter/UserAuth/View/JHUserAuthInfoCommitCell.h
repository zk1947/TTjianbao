//
//  JHUserAuthInfoCommitCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthInfoCommitCell : JHWBaseTableViewCell

@property (nonatomic, assign) JHUserAuthState authState;

@property (nonatomic, copy) dispatch_block_t commitBlock;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
