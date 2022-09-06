//
//  JHChatMediaCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatMediaModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHChatMediaCell : UICollectionViewCell
@property (nonatomic, strong) JHChatMediaModel *model;

- (void)configWithModel : (JHChatMediaModel *)model;
@end

NS_ASSUME_NONNULL_END
