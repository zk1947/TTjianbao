//
//  JHC2CProductDetailChatInnerCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailChatInnerCell : UITableViewCell

@property(nonatomic, copy) void (^tapCellBlcok)(void);

@property(nonatomic, copy) void (^longPressCellBlcok)(void);

@property(nonatomic, copy) void (^likeBtnTapBlcok)(void);


@end

NS_ASSUME_NONNULL_END
