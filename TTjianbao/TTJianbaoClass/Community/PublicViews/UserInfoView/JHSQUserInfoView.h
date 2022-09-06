//
//  JHSQUserInfoView.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  cell的用户信息栏
//

#import <UIKit/UIKit.h>
#import "JHSQModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQUserInfoView : UIView

@property (nonatomic, copy) dispatch_block_t clickUserInfoBlock; //点击用户信息
@property (nonatomic, copy) dispatch_block_t clickMoreBlock; //点击更多

@property (nonatomic, strong) JHPostData *postData;
@property (nonatomic, copy) NSString *pageFrom;
/** 当前所属控制器类型 */
@property (nonatomic, assign) JHPageType pageType;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
