//
//  JHUnionPayFooter.h
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionPayFooter : UIView

@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) void(^doneBlock)(void);



@end

NS_ASSUME_NONNULL_END
