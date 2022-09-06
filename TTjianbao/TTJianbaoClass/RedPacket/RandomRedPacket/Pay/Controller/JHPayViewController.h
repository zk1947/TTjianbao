//
//  JHPayViewController.h
//  TTjianbao
//
//  Created by jiang on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
#import "PayMode.h"
#import "JHMakeRedpacketModel.h"
@interface JHPayViewController : JHBaseViewExtController
@property(strong,nonatomic)JHMakeRedpacketModel *redPacketMode;
@property (nonatomic, copy) dispatch_block_t complete;
@end

