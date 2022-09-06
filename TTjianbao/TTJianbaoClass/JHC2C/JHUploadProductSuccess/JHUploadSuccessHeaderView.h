//
//  JHUploadSuccessHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "AdressMode.h"
#import "OrderMode.h"
#import "JHOrderDetailMode.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JHOrderHeaderTitleView.h"
#import "JHC2CPublishSuccessBackModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface JHUploadSuccessHeaderView : BaseView
@property(nonatomic, strong) JHC2CPublishSuccessBackModel * model;
@property(strong,nonatomic)NSArray * friendAgentpayArr;
@property(strong,nonatomic)JHActionBlocks shareHandle;
@property(nonatomic,strong) UIView * contentScroll;
@property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;


/// 是否支持鉴定
@property(nonatomic) BOOL  canAuth;

-(void)initBottomView;
@end

NS_ASSUME_NONNULL_END
