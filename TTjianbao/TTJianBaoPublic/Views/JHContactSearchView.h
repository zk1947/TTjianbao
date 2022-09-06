//
//  JHContactSearchView.h
//  TTjianbao
//
//  Created by YJ on 2021/1/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHContactUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectRowBlock)(JHContactUserInfoModel *model);

@interface JHContactSearchView : UIView

@property (strong, nonatomic) NSMutableArray *modelsArray;
@property (strong, nonatomic) UIButton *cancelButton;
@property (copy, nonatomic) SelectRowBlock block;

@end

NS_ASSUME_NONNULL_END
