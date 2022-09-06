//
//  JHCustomizeAddPhotoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeAddPhotoView : UIControl
@property (nonatomic, strong) JHActionBlock completeBlock;
- (void)showAlert;
- (void)hiddenAlert;
@end

NS_ASSUME_NONNULL_END
