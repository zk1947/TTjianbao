//
//  JHC2CProductDetailChatCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class JHCommentModel;
@interface JHC2CProductDetailChatCell : UITableViewCell

@property(nonatomic, copy) void (^tapCellBlcok)(void);

@property(nonatomic, copy) void (^longPressCellBlcok)(void);

@property(nonatomic, copy) void (^likeBtnTapBlcok)(void);

@property (nonatomic, strong) JHCommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
