//
//  JHMeChatCell.h
//  TTjianbao
//
//  Created by YJ on 2021/1/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectRowBlock)(NSString *urlString);

@interface JHMeChatCell : UITableViewCell

@property (strong, nonatomic) JHChatModel *model;

+ (CGFloat)heightWithModel:(JHChatModel *)model;

@property (copy, nonatomic) SelectRowBlock block;

@end

NS_ASSUME_NONNULL_END
