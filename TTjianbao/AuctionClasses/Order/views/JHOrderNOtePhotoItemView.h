//
//  JHOrderNOtePhotoItemView.h
//  TTjianbao
//
//  Created by jiang on 2019/10/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"
#import "OrderMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderNOtePhotoItemView : BaseView

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy) JHActionBlock deleteAction;
@property (nonatomic, copy) JHActionBlock addAction;
@property (nonatomic, copy) JHActionBlock clickImageAction;

@property (nonatomic, copy) OrderPhotoMode *photoMode;

- (void)showImageUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
