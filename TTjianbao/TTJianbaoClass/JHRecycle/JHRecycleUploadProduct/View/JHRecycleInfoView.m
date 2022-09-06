//
//  JHRecycleInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleInfoView.h"
#import "JHRecycleProductTopTypeView.h"
#import "JHRecycleProductPictureView.h"
#import "JHRecycleProductDetailView.h"
#import "JHRecycleProductIllustrationView.h"
#import "JHRecyclePublishProcessView.h"
#import "JHRecycleExpectPriceView.h"
@interface JHRecycleInfoView()

/// 滚动试图
@property(nonatomic, strong) UIScrollView * backScrollView;

/// 流程背景
@property(nonatomic, strong) UIView *processBackView;

///流程
@property(nonatomic, strong) JHRecyclePublishProcessView *processView;

/// 宝贝类型
@property(nonatomic, strong) JHRecycleProductTopTypeView * topTypeView;

/// 宝贝图片
@property(nonatomic, strong) JHRecycleProductPictureView * productView;

/// 宝贝细节
@property(nonatomic, strong) JHRecycleProductDetailView * productDetailView;

/// 宝贝描述
@property(nonatomic, strong) JHRecycleProductIllustrationView * productIllustrationView;

/// 宝贝期望价格
@property(nonatomic, strong)JHRecycleExpectPriceView * expectPriceView;

@property(nonatomic, strong) NSOperationQueue * uploadQueue;

@end

@implementation JHRecycleInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItemsWithModelArr:nil];
        [self layoutItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray<JHRecycleUploadExampleModel *> *)modelArr{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItemsWithModelArr:modelArr];
        [self layoutItems];
    }
    return self;
}

- (void)setItemsWithModelArr:(nullable NSArray<JHRecycleUploadExampleModel *> *)modelArr{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.processBackView];
    [self.backScrollView addSubview:self.processView];
    [self.backScrollView addSubview:self.topTypeView];
    if (modelArr.count) {
        self.productView = [[JHRecycleProductPictureView alloc] initWithFrame:CGRectZero andExampleModelArr:modelArr];
        [self.backScrollView addSubview:self.productView];
    }else{
        [self.backScrollView addSubview:self.productView];
    }
    [self.backScrollView addSubview:self.productDetailView];
    [self.backScrollView addSubview:self.productIllustrationView];

    [self.backScrollView addSubview:self.expectPriceView];
}

- (void)layoutItems{
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.processBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(9);
        make.width.mas_equalTo(ScreenWidth);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(60);
    }];
    
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(9);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [self.topTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.processView.mas_bottom).offset(9);
        make.width.mas_equalTo(ScreenWidth);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(60);
    }];
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTypeView.mas_bottom).offset(9);
        make.left.right.equalTo(self.topTypeView);
    }];
    [self.productDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(9);
        make.left.right.equalTo(self.topTypeView);
    }];
    [self.productIllustrationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productDetailView.mas_bottom).offset(9);
        make.left.right.equalTo(self.topTypeView);
        make.height.mas_equalTo(171);
//        make.bottom.equalTo(@0).offset(-12);
    }];
    [self.expectPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productIllustrationView.mas_bottom).offset(9);
        make.left.right.equalTo(self.topTypeView);
        make.height.mas_equalTo(90);
        make.bottom.equalTo(@0).offset(-12);
    }];
}

#pragma mark -- <Actions>
- (void)refreshTopTypeViewWithName:(NSString *)name andImageName:(NSString *)imageName andmodle:(JHRecycleUploadExampleTotalModel *)model{
    if ([name containsString:@"卖"]) {
        self.topTypeView.nameLbl.text = [name substringFromIndex:1];
    }else{
        self.topTypeView.nameLbl.text = name;
    }
    
    [self.topTypeView.iconImageView jh_setImageWithUrl:imageName];
    self.productView.titleLbl.text = [NSString stringWithFormat:@"%@图片",model.firstCategoryName];
    self.productView.descLabel.text = model.pictureDesc;
//    self.productDetailView.titleLbl.text = [NSString stringWithFormat:@"%@其他细节",model.firstCategoryName];
    self.productDetailView.descLabel.text = model.videoDesc;
    self.productIllustrationView.titleLbl.text = [NSString stringWithFormat:@"%@描述",model.firstCategoryName];
    self.productIllustrationView.placeholderLbl.text = model.descTip;

}

- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel *)model andIndex:(NSInteger)index{
    [self.productView addProductPictureWithName:model andIndex:index];
}
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    [self.productDetailView addProductDetailPictureWithName:model];
}

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    [self.productDetailView addProductDetailPictureWithModelArr:modelArr];
}
#pragma mark -- <set and get>

- (UIView *)processBackView {
    if (!_processBackView) {
        _processBackView = [[UIView alloc] init];
        _processBackView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _processBackView;
}

- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        _backScrollView = view;
    }
    return _backScrollView;
}

- (JHRecyclePublishProcessView *)processView{
    if (!_processView) {
        _processView = [[JHRecyclePublishProcessView alloc] init];
    }
    return _processView;
}

- (JHRecycleProductTopTypeView *)topTypeView{
    if (!_topTypeView) {
        JHRecycleProductTopTypeView *view = [JHRecycleProductTopTypeView new];
        _topTypeView = view;
    }
    return _topTypeView;
}

- (JHRecycleProductPictureView *)productView{
    if (!_productView) {
        JHRecycleProductPictureView *view = [JHRecycleProductPictureView new];
        view.uploadQueue = self.uploadQueue;
        _productView = view;
    }
    return _productView;
}


- (JHRecycleProductDetailView *)productDetailView{
    if (!_productDetailView) {
        JHRecycleProductDetailView *view = [JHRecycleProductDetailView new];
        view.uploadQueue = self.uploadQueue;
        _productDetailView = view;
    }
    return _productDetailView;
}

- (JHRecycleProductIllustrationView *)productIllustrationView{
    if (!_productIllustrationView) {
        JHRecycleProductIllustrationView *view = [JHRecycleProductIllustrationView new];
        _productIllustrationView = view;
    }
    return _productIllustrationView;
}

- (JHRecycleExpectPriceView *)expectPriceView{
    if (!_expectPriceView) {
        JHRecycleExpectPriceView *view = [JHRecycleExpectPriceView new];
        _expectPriceView = view;
    }
    return _expectPriceView;
}

- (NSString *)productIllustration{
    return self.productIllustrationView.textView.text;
}
- (NSString *)expectPrice{
    return self.expectPriceView.placeholderLbl.text;
}

- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productPictureArr{
    return self.productView.productPictureArr;
}
- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return self.productDetailView.productDetailPictureArr;
}
- (void)setAddProductPictureBlock:(void (^)(NSInteger))addProductPictureBlock{
    self.productView.addProductPictureBlock = addProductPictureBlock;
}
- (void)setDelProductPictureBlock:(void (^)(NSInteger))delProductPictureBlock{
    self.productView.delProductPictureBlock = delProductPictureBlock;
}
- (void)setAddProductDetailBlock:(void (^)(NSInteger))addProductDetailBlock{
    self.productDetailView.addProductDetailBlock = addProductDetailBlock;
}

- (NSOperationQueue *)uploadQueue{
    if (_uploadQueue == nil) {
        _uploadQueue = [[NSOperationQueue alloc] init];
        _uploadQueue.maxConcurrentOperationCount = 1;
    }
    return _uploadQueue;
}

@end
