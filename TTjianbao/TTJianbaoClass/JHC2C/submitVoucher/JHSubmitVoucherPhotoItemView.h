//
//  JHSubmitVoucherPhotoItemView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "OrderMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSubmitVoucherPhotoItemView : BaseView

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy) JHActionBlock deleteAction;
@property (nonatomic, copy) JHActionBlock addAction;
@property (nonatomic, copy) JHActionBlock clickImageAction;

@property (nonatomic, copy) OrderPhotoMode *photoMode;

- (void)showImageUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
