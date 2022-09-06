//
//  UMengShareButton.h
//  TTjianbao
//
//  Created by wuyd on 2019/10/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMShareButton : UIButton

/** 上下间距 */
@property (nonatomic , assign ) CGFloat range;

/** 设置标题图标 */
- (void)setTitle:(NSString *)title image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
