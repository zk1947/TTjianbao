//
//  JHBusinessPublishGoodsPropertyView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CUploadProductDetailModel.h"
#import "JHC2CProductUploadJianDingButton.h"
#import "JHBusinessPublishBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishGoodsPropertyView : JHBusinessPublishBaseView
@property(nonatomic,copy) void (^btnClickedBlock)(void);//属性
@property(nonatomic,copy) void (^btnClickedBlock2)(void);//分类
- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSArray<BackAttrRelationResponse*>*)arr;
@property(nonatomic,strong) UILabel * seleLabel;  //商品分类
@property(nonatomic,strong) UILabel * seleLabel2;  //商品属性

- (void)resetGoodsCate:(NSString *)cateStr;
- (void)reloadWithArray:(NSArray *)array;

- (void)reloadNullProperty;
@end

NS_ASSUME_NONNULL_END
