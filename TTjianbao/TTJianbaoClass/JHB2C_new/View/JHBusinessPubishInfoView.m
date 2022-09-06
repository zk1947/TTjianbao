//
//  JHBusinessPubishInfoView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPubishInfoView.h"
#import "JHBusinessPublishPictureView.h"
#import "JHBusinessPublishVideoView.h"

#import "JHRecycleProductTopTypeView.h"
#import "JHRecycleProductDetailView.h"
#import "JHBusinessPublishNameView.h"
#import "JHC2CProductUploadDetailPictureView.h"
#import "JHBusinessPublishGoodsPropertyView.h"
#import "JHBusinessPublishGoodsDsecView.h"
#import "JHBusinessPublishGoodsDetailView.h"
#import "JHBusinessPublishTypeSelectView.h"

#import "JHBusinessGoodsPropertyController.h"
#import "JHBusinessPublishPickerView.h"
#import "JHBusinessPublishAuctionTypeView.h"
@interface JHBusinessPubishInfoView()
<UIScrollViewDelegate>

/// 滚动试图
@property(nonatomic, strong) UIScrollView * backScrollView;

/// 描述
@property(nonatomic, strong) JHBusinessPublishNameView * textInfoView;

/// 商品图片
@property(nonatomic, strong) JHBusinessPublishPictureView * productDetailView;

/// 商品视频
@property(nonatomic, strong) JHBusinessPublishVideoView * productVideoView;

/// 分类 、属性
@property(nonatomic, strong) JHBusinessPublishGoodsPropertyView * productCategoryProperty;

/// 详细规格选填
@property(nonatomic, strong) JHBusinessPublishGoodsDsecView * detailInfoView;


/// 图片详细
@property(nonatomic, strong) JHBusinessPublishGoodsDetailView *pictureDetail;

@property(nonatomic, strong) JHBusinessPublishTypeSelectView *publishTypeView;

@property(nonatomic, strong) JHBusinessPublishAuctionTypeView * publishTypeView_auction;//竞拍

@property(nonatomic, strong) NSOperationQueue * uploadQueue;

@property(nonatomic, strong) NSArray<BackAttrRelationResponse *> * selArr;

@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel *> * examArr;

@property(nonatomic, copy) NSString * selectCateId;
@property(nonatomic, assign) JHB2CPublishGoodsType publishtype;


@end

@implementation JHBusinessPubishInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andExampleModelArr:(NSArray<JHRecycleUploadExampleModel *> *)modelArr andSeleModelArr:(nonnull NSArray<BackAttrRelationResponse *> *)seleModelArr andPubModel:(nonnull JHBusinesspublishModel *)pubmodel andPublishType:(JHB2CPublishGoodsType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.publishModle = pubmodel;
        self.publishtype = type;
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

    
    [self.backScrollView addSubview:self.textInfoView];
    [self.backScrollView addSubview:self.productDetailView];
    [self.backScrollView addSubview:self.productVideoView];
    [self.backScrollView addSubview:self.productCategoryProperty];
    [self.backScrollView addSubview:self.detailInfoView];
    [self.backScrollView addSubview:self.pictureDetail];
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        [self.backScrollView addSubview:self.publishTypeView];
    }else if(self.publishtype == JHB2CPublishGoodsType_Auction){
        [self.backScrollView addSubview:self.publishTypeView_auction];
    }
    
}

- (void)layoutItems{
    [self.backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.textInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(126);
        make.width.mas_equalTo(kScreenWidth);
    }];

    [self.productDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textInfoView.mas_bottom).offset(9);
        make.left.right.equalTo(@0);
    }];
    
    [self.productVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productDetailView.mas_bottom).offset(9);
        make.left.right.equalTo(@0);
    }];
    
    [self.productCategoryProperty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productVideoView.mas_bottom).offset(9);
        make.left.right.equalTo(@0);
//        make.height.mas_equalTo(98);
    }];
    
    
    [self.detailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productCategoryProperty.mas_bottom).offset(10);
        make.left.right.equalTo(@0);
        if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
            make.height.mas_equalTo(304);
        }else{
            make.height.mas_equalTo(371);
        }
        
    }];
    [self.pictureDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailInfoView.mas_bottom).offset(9);
        make.left.right.equalTo(@0);
//        make.bottom.equalTo(@0).offset(-12);
    }];

    
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        [self.publishTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pictureDetail.mas_bottom).offset(9);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(48);
            make.bottom.equalTo(@0).offset(-12);
        }];
    }else if(self.publishtype == JHB2CPublishGoodsType_Auction){
        [self.publishTypeView_auction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pictureDetail.mas_bottom).offset(9);
            make.left.right.equalTo(@0);
//            make.height.mas_equalTo(148);
            make.bottom.equalTo(@0).offset(-12);
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.textInfoView.textView.isFirstResponder) {
        [self.textInfoView.textView resignFirstResponder];
    }
}

#pragma mark -- <Actions>
//添加图片
- (void)addProductDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    [self.productDetailView addProductDetailPictureWithName:model];
}

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    [self.productDetailView addProductDetailPictureWithModelArr:modelArr];
}
//添加图片描述
- (void)addProductDetailPictureWithName2:(JHRecyclePhotoInfoModel *)model{
    [self.pictureDetail addProductDetailPictureWithName2:model];
}

- (void)addProductDetailPictureWithModelArr2:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    [self.pictureDetail addProductDetailPictureWithModelArr2:modelArr];
}
//添加视频
- (void)addProductVideoDetailPictureWithName:(JHRecyclePhotoInfoModel *)model{
    [self.productVideoView addProductVideoDetailPictureWithName:model];
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

- (JHBusinessPublishPictureView *)productDetailView{
    if (!_productDetailView) {
        JHBusinessPublishPictureView *view = [[JHBusinessPublishPictureView alloc] initWithFrame:CGRectZero maxCount: 8 - self.examArr.count];
        view.uploadQueue = self.uploadQueue;
        _productDetailView = view;
        _productDetailView.publishModle = self.publishModle;
    }
    return _productDetailView;
}

- (JHBusinessPublishVideoView *)productVideoView{
    if (!_productVideoView) {
        JHBusinessPublishVideoView *view = [[JHBusinessPublishVideoView alloc] initWithFrame:CGRectZero maxCount: 1 - self.examArr.count];
        view.uploadQueue = self.uploadQueue;
        _productVideoView = view;
        _productVideoView.publishModle = self.publishModle;
    }
    return _productVideoView;
}
- (JHBusinessPublishGoodsPropertyView *) productCategoryProperty{
    if (!_productCategoryProperty) {
        JHBusinessPublishGoodsPropertyView *view = [[JHBusinessPublishGoodsPropertyView alloc] initWithFrame:CGRectZero withModelArr:self.selArr];
        @weakify(self);
        view.btnClickedBlock2 = ^{
            @strongify(self)
            if (self.normalModel.backCateList.count == 0) {
                JHTOAST(@"暂无商品分类数据");
                return;
            }
            
            JHBusinessPublishPickerView *countPicker = [[JHBusinessPublishPickerView alloc] init];
            countPicker.selectedIndex_0 = self.publishModle.firstCategoryselect;
            countPicker.selectedIndex_1 = self.publishModle.secondCategoryselect;
            countPicker.selectedIndex_2 = self.publishModle.thirdCategoryselect;
            countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
            countPicker.normalModel = self.normalModel;
            [countPicker show];
    
            
            [countPicker.pickerView selectRow:self.publishModle.firstCategoryselect inComponent:0 animated:NO];
            [countPicker.pickerView selectRow:self.publishModle.secondCategoryselect inComponent:1 animated:NO];
            [countPicker.pickerView selectRow:self.publishModle.thirdCategoryselect inComponent:2 animated:NO];
            countPicker.sureClickBlock2 = ^(NSString * _Nonnull showStr, NSString * _Nonnull cateId, NSString * _Nonnull cateId1, NSString * _Nonnull cateId2, NSInteger selectedIndex_0, NSInteger selectedIndex_1, NSInteger selectedIndex_2) {
                [self.productCategoryProperty resetGoodsCate:showStr];
                if (![self.publishModle.thirdCategoryId isEqualToString:cateId2] ) {
                    [self.productCategoryProperty reloadNullProperty];
                    [self.attributeArray removeAllObjects];
                }

                self.selectCateId = cateId2;
                self.publishModle.firstCategoryId = cateId;
                self.publishModle.secondCategoryId = cateId1;
                self.publishModle.thirdCategoryId = cateId2;
                self.publishModle.firstCategoryselect = selectedIndex_0;
                self.publishModle.secondCategoryselect = selectedIndex_1;
                self.publishModle.thirdCategoryselect = selectedIndex_2;
                
            };
        };
        view.btnClickedBlock = ^{
            @strongify(self);
            if (self.selectCateId.length == 0) {
                JHTOAST(@"请选择分类");
                return;
            }
            JHBusinessGoodsPropertyController * vc = [[JHBusinessGoodsPropertyController alloc] initWithArrayModel:self.attributeArray];
            vc.selectCateId = self.selectCateId;
            
            vc.sureClickBlock = ^(NSMutableArray * _Nonnull arrayModel) {
                self.attributeArray = arrayModel;
                [self.productCategoryProperty reloadWithArray:arrayModel];
            };
            [JHRootController.navigationController pushViewController:vc animated:YES];
        };
        _productCategoryProperty = view;
        _productCategoryProperty.publishModle = self.publishModle;
    }
    return _productCategoryProperty;
}
- (JHBusinessPublishNameView *)textInfoView{
    if (!_textInfoView) {
        JHBusinessPublishNameView *view = [JHBusinessPublishNameView new];
        _textInfoView = view;
        _textInfoView.publishModle = self.publishModle;
    }
    return _textInfoView;
}

- (JHBusinessPublishGoodsDsecView *)detailInfoView{
    if (!_detailInfoView) {
        JHBusinessPublishGoodsDsecView *view = [[JHBusinessPublishGoodsDsecView alloc] initWithType:self.publishtype];
        _detailInfoView = view;
        _detailInfoView.publishModle = self.publishModle;
    }
    return _detailInfoView;
}
- (JHBusinessPublishGoodsDetailView *)pictureDetail{
    if (!_pictureDetail) {
        JHBusinessPublishGoodsDetailView *view = [[JHBusinessPublishGoodsDetailView alloc] initWithFrame:CGRectZero maxCount: 8 - self.examArr.count];
        view.uploadQueue = self.uploadQueue;
        _pictureDetail = view;
        _pictureDetail.publishModle = self.publishModle;
    }
    return _pictureDetail;
}
- (JHBusinessPublishTypeSelectView *)publishTypeView{
    if (!_publishTypeView) {
        _publishTypeView = [[JHBusinessPublishTypeSelectView alloc] initWithFrame:CGRectZero];
        _publishTypeView.publishModle = self.publishModle;
    }
    return _publishTypeView;
}

- (JHBusinessPublishAuctionTypeView *)publishTypeView_auction{
    if (!_publishTypeView_auction) {
        _publishTypeView_auction = [[JHBusinessPublishAuctionTypeView alloc] initWithFrame:CGRectZero];
        _publishTypeView_auction.publishModle = self.publishModle;
        
    }
    return _publishTypeView_auction;
}

- (NSString *)productIllustration{
    return self.textInfoView.textView.text;
}

- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productDetailPictureArr{
    return self.pictureDetail.productDetailPictureArr;
}
- (NSMutableArray<JHRecyclePhotoInfoModel *> *)productPictureArr{
    return self.productDetailView.productDetailPictureArr;
}
- (JHRecyclePhotoInfoModel *)selectVideoModel{
    return [self.productVideoView.productDetailPictureArr firstObject];
}

- (void)setAddProductDetailBlock:(void (^)(NSInteger))addProductDetailBlock{
    self.productDetailView.addProductDetailBlock = addProductDetailBlock;
}
- (void)setAddProductDetailBlock2:(void (^)(NSInteger))addProductDetailBlock{
    self.pictureDetail.addProductDetailBlock2 = addProductDetailBlock;
}
//视频
- (void)setAddProductDetailBlock3:(void (^)(NSInteger))addProductDetailBlock{
    self.productVideoView.addProductDetailBlock = addProductDetailBlock;
}

- (NSOperationQueue *)uploadQueue{
    if (_uploadQueue == nil) {
        _uploadQueue = [[NSOperationQueue alloc] init];
        _uploadQueue.maxConcurrentOperationCount = 1;
    }
    return _uploadQueue;
}

- (void) setNormalModel:(JHBusinessPubishNomalModel *)normalModel{
    _normalModel = normalModel;
    _publishTypeView_auction.normalModel = normalModel;
}
- (UILabel *)titleLbl{
    return nil;
}
//网络数据回显
- (void)showNetData:(JHBusinesspublishModel *)model{
    self.publishModle = model;
//:(JHIssueGoodsEditImageItemModel *)model andIndex:(NSInteger)index{
    self.selectCateId = self.publishModle.thirdCategoryId;
    if (self.publishModle.productName.length>0) {
        _textInfoView.textView.text = self.publishModle.productName;
        _textInfoView.placeholderLbl.hidden = YES;
    }
    [self.productDetailView setNetDataWithArray:self.publishModle.mainImages];
    [self.productVideoView setNetDataWithArray:self.publishModle.videoDetail];
    if (self.publishModle.thirdCategoryName.length>0) {
        [self.productCategoryProperty resetGoodsCate:[NSString stringWithFormat:@"%@-%@-%@",self.publishModle.firstCategoryName,self.publishModle.secondCategoryName,self.publishModle.thirdCategoryName]];
    }
    for (JHBusinessGoodsAttributeModel *model in self.publishModle.attrs) {
        model.showValue = model.attrValue;
    }
    self.attributeArray = self.publishModle.attrs;
    [self.productCategoryProperty reloadWithArray:self.publishModle.attrs];
    [self.detailInfoView setNetModelData];
    [self.pictureDetail setNetDataWithArray:self.publishModle.detailImages];
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        [self.publishTypeView resetNetData];
    }else if(self.publishtype == JHB2CPublishGoodsType_Auction){

        self.publishTypeView_auction.normalModel = self.normalModel;
        [self.publishTypeView_auction resetNetDataWithType:self.publishModle.productStatus];
    }
}
@end
