//
//  JHUserInfoEvaluateTableViewCell.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoEvaluateTableViewCell : UITableViewCell
@property (nonatomic, copy) JHFinishBlock userInfoClick;
//数据绑定
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas;
///点击展开按钮
@property (nonatomic, copy)void(^openClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
