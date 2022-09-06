//
//  JHUploadVideoViewController.h
//  TTjianbao
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUploadVideoViewController : JHBaseViewExtController
@property(nonatomic, strong)OrderMode *orderModel;
@property(nonatomic, copy)JHActionBlock finishBlock;

@end

NS_ASSUME_NONNULL_END
