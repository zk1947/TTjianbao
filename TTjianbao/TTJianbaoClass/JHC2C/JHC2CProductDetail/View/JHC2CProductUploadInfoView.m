//
//  JHC2CProductUploadInfoView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadInfoView.h"
#import "JHRecycleProductTopTypeView.h"
#import "JHRecycleProductDetailView.h"
#import "JHC2CProductUploadTextInfoView.h"
#import "JHC2CProductUploadDetailPictureView.h"

@interface JHC2CProductUploadInfoView()<UIScrollViewDelegate>

/// 滚动试图
@property(nonatomic, strong) UIScrollView * backScrollView;

/// 描述
@property(nonatomic, strong) JHC2CProductUploadTextInfoView * textInfoView;

/// 宝贝图片


/// 宝贝细节
@property(nonatomic, strong) JHC2CProductUploadDetailPictureView * productDetailView;




@property(nonatomic, strong) NSOperationQueue * uploadQueue;

@property(nonatomic, strong) NSArray<BackAttrRelationResponse *> * selArr;

@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel *> * examArr;

@end

@implementation JHC2CProductUploadInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray<JHRecycleUploadExampleModel *> *)modelArr andSeleModelArr:(nonnull NSArray<BackAttrRelationResponse *> *)seleModelArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.selArr = seleModelArr;
        self.examArr = modelArr;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xF5F5F5);
    [self addSubview:self.backScrollView];
    if (self.examArr.count) {
        self.productView = [[JHC2CProductUploadNesPictureView alloc] initWithFrame:CGRectZero andExampleModelArr:self.examArr];
        [self.backScrollView addSubview:self.productView];
    }else{
        [self.backScrollView addSubview:self.productView];
    }
    [self.backScrollView addSubview:self.productDetailView];
    [self.backScrollView addSubview:self.textInfoView];
    [self.backScrollView addSubview:self.detailInfoView];
}

- (void)layoutItems{
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.textInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.width.mas_equalTo(kScreenWidth);
    }];
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textInfoView.mas_bottom);
        make.left.right.equalTo(@0);
    }];
    [self.productDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(9);
        make.left.right.equalTo(@0);
    }];
    [self.detailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productDetailView.mas_bottom).offset(10);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0).offset(-12);
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.textInfoView.textView.isFirstResponder) {
        [self.textInfoView.textView resignFirstResponder];
    }
}

#pragma mark -- <Actions>

- (void)addProductPictureWithName:(JHRecyclePhotoInfoModel *)model andIndex:(NSInteger)index{
    [self.productView addProductPictureWithName:model andIndex:index];
}
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    [self.productDetailView addProductDetailPictureWithName:model];
}

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    [self.productDetailView addProductDetailPictureWithModelArr:modelArr];
}

- (void)showNetImage:(JHIssueGoodsEditImageItemModel *)model andIndex:(NSInteger)index{
    [self.productView addNetProductPictureWithName:model andIndex:index];
}

- (void)addNetProductDetailPictureWithModelArr:(NSArray *)modelArr{
    [self.productDetailView addNetProductDetailPictureWithModelArr:modelArr];
}

#pragma mark -- <set and get>

- (UIScrollView *)backScrollView{
    if (!_backScrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = HEXCOLOR(0xF5F5F5);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.delegate = self;
        _backScrollView = view;
    }
    return _backScrollView;
}

- (JHC2CProductUploadNesPictureView *)productView{
    if (!_productView) {
        JHC2CProductUploadNesPictureView *view = [JHC2CProductUploadNesPictureView new];
        view.uploadQueue = self.uploadQueue;
        _productView = view;
    }
    return _productView;
}


- (JHC2CProductUploadDetailPictureView *)productDetailView{
    if (!_productDetailView) {
        JHC2CProductUploadDetailPictureView *view = [[JHC2CProductUploadDetailPictureView alloc] initWithFrame:CGRectZero maxCount: 9 - self.examArr.count];
        view.uploadQueue = self.uploadQueue;
        _productDetailView = view;
    }
    return _productDetailView;
}

- (JHC2CProductUploadTextInfoView *)textInfoView{
    if (!_textInfoView) {
        JHC2CProductUploadTextInfoView *view = [JHC2CProductUploadTextInfoView new];
        _textInfoView = view;
    }
    return _textInfoView;
}

- (JHC2CProductUploadDetailInfoView *)detailInfoView{
    if (!_detailInfoView) {
        JHC2CProductUploadDetailInfoView *view = [[JHC2CProductUploadDetailInfoView alloc] initWithFrame:CGRectZero withModelArr:self.selArr];
        _detailInfoView = view;
    }
    return _detailInfoView;
}

- (NSString *)productIllustration{
    return self.textInfoView.textView.text;
}

- (void)setProductIllustration:(NSString * _Nonnull)productIllustration{
    self.textInfoView.textView.text = productIllustration;
    self.textInfoView.placeholderLbl.hidden = productIllustration.length > 0 ? YES:NO;
}

- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productPictureArr{
    return self.productView.productPictureArr;
}
- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return self.productDetailView.productDetailPictureArr;
}
- (NSMutableDictionary *)attDic{
    return self.detailInfoView.attDic;
}

- (void)setAttDic:(NSMutableDictionary *)attDic{
    self.detailInfoView.attDic = attDic;
}

- (void)setNetAttDic:(NSDictionary *)netAttDic{
    self.detailInfoView.netAttDic = netAttDic;
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

- (void)setTapPriceBlock:(void (^)(NSString * _Nonnull))tapPriceBlock{
    self.detailInfoView.tapPriceBlock = tapPriceBlock;
}
- (NSOperationQueue *)uploadQueue{
    if (_uploadQueue == nil) {
        _uploadQueue = [[NSOperationQueue alloc] init];
        _uploadQueue.maxConcurrentOperationCount = 1;
    }
    return _uploadQueue;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.detailInfoView.price = price;
}

- (void)setPriceType:(NSInteger)priceType{
    _priceType = priceType;
    self.detailInfoView.priceType = priceType;
}
- (void)setPostPrice:(NSString *)postPrice{
    _postPrice = postPrice;
    self.detailInfoView.postPrice = postPrice;
}
- (JHC2CProductUploadJianDingButton *)jianDingBtn{
    return self.detailInfoView.jianDingBtn;
}

- (UILabel *)titleLbl{
    return self.textInfoView.titleLbl;
}
@end

