//
//  JHSaleGoodsView.h
//  TTjianbao
//  Description:商品橱窗-添加商品UI
//  Created by jesee on 18/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPickerView.h"
#import "JHShopwindowGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSaleGoodsView : UIView <STPickerSingleDelegate, UITextFieldDelegate>
@property (nonatomic, strong) JHPickerView* catePicker;

@property (nonatomic, copy) void (^hiddenBlock) (BOOL hidden);

- (instancetype)initWithData:(JHShopwindowGoodsListModel*)model;
//设置选中图片,从相册中选择
- (void)setSelectedAlbumIcon:(UIImage*)img;
//获取当前添加商品信息
- (JHShopwindowGoodsListModel*)goodsAddInfos;
- (void)showCatePicker:(UIButton *)button;
- (BOOL)finishAction:(UIButton *)button;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
