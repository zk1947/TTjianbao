//
//  JHOperationBanView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOperationBanView : UIControl
@property (nonatomic, copy)JHActionBlock completeBlock;
-(void)show;
@end

NS_ASSUME_NONNULL_END
