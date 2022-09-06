//
//  JHPhotoItemView.h
//  TTjianbao
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPhotoItemView : BaseView
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy) JHActionBlock deleteAction;
@property (nonatomic, copy) JHActionBlock clickImageAction;

- (void)showImageUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
