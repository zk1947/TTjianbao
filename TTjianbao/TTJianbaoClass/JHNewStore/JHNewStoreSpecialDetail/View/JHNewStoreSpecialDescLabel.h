//
//  JHNewStoreSpecialDescLabel.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreSpecialDescLabelDelegate <NSObject>
- (void)expandOrPackUp:(CGFloat)maxHeight;
@end

@interface JHNewStoreSpecialDescLabel : YYLabel
@property (nonatomic ,weak) id <JHNewStoreSpecialDescLabelDelegate>delegate;
- (void)addSeeMoreButtonInLabel:(NSString *)descStr;
@end

NS_ASSUME_NONNULL_END
