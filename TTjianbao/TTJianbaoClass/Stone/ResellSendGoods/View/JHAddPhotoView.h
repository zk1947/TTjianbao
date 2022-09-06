//
//  JHAddPhotoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAddPhotoView : JHOrderSubBaseView
@property (strong, nonatomic)  NSMutableArray <OrderPhotoMode *>*allPhotos;
@end

NS_ASSUME_NONNULL_END
