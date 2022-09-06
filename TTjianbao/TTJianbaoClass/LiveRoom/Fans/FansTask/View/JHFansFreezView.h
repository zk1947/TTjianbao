//
//  JHFansFreezView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHFansClubModel;

@interface JHFansFreezView : UIView

@property(nonatomic, readonly) CGFloat   freezViewHeight;

@property (nonatomic, strong) JHFansClubModel * fansClubModel;

@end

NS_ASSUME_NONNULL_END
