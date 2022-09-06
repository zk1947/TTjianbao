//
//  JHStoneSendGoodsView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHGoodSendAddressMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSendGoodsView : UIView
@property (strong, nonatomic)  NSMutableArray <OrderPhotoMode *>*allPhotos;
@property(nonatomic,strong) NSString *expressCompanyCode;
@property(nonatomic,strong) NSString *expressCode;
@property(strong,nonatomic)JHActionBlock completeBlock;
@property(strong,nonatomic) JHGoodSendAddressMode* addressModel;
@end

NS_ASSUME_NONNULL_END
