//
//  JHMyCenterAssisstantView.h
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterAssisstantView : UIView
///滑动的回调block
@property (nonatomic, copy) void(^scrollBlock)(CGFloat offSet);

-(void)reload;
@end

NS_ASSUME_NONNULL_END
