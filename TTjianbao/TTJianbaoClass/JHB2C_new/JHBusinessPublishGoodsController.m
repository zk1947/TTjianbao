//
//  JHBusinessPublishGoodsController.m
//  TTjianbao
//
//  Created by liuhai on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishGoodsController.h"
#import "JHBusinessPubishInfoView.h"

#import "BaseNavViewController.h"
#import <IQKeyboardManager.h>
#import "JHRecycleUploadProductBottomView.h"


#import "JHRecycleUploadProductBusiness.h"
#import "JHC2CInputPriceController.h"


#import "JHRecyclePhotoInfoModel.h"
#import "TZImagePickerController.h"
#import "JHRecycleTemplateCameraViewController.h"
#import "JHRecycleCameraViewController.h"
#import "SVProgressHUD.h"
#import "JHWebViewController.h"
#import "CommAlertView.h"
#import "JHRealNameAuthenticationViewController.h"
#import "JHC2CProductUploadBusiness.h"
#import "JHGoodManagerListViewController.h"
#import "JHC2CProductUploadJianDingButton.h"
#import "JHC2CSelectClassViewController.h"
#import "JHAppraisePayView.h"
#import "JHGoodManagerFilterBusiness.h"
#import "JHGoodManagerFilterModel.h"
#import "JHBusinessPubishNomalModel.h"
#import "JHBusinessGoodsUploadBusiness.h"
#import "JHBusinessGoodsAttributeModel.h"

typedef NS_ENUM(NSUInteger, JHB2CImagePickerType) {
    JHB2CImagePickerType_Product = 0,///商品图片
    JHB2CImagePickerType_Detail,///商品详情图片
    JHB2CImagePickerType_Video,///视频
};

@interface JHBusinessPublishGoodsController ()
/// 底部悬浮视图
//@property(nonatomic, strong) JHC2CUploadProductBottomView * bottomView;
@property(nonatomic, strong) JHRecycleSureButton * bottomView;
/// 填写信息view
@property(nonatomic, strong) JHBusinessPubishInfoView * infoView;

@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * exampleModelArr;

/// 当前进入多媒体类型
@property(nonatomic, assign) JHB2CImagePickerType  pickerType;

/// 是否进入相册选择中
@property(nonatomic, assign) BOOL  inInSeletePhoto;

/// 宝贝信息点击按钮index
@property(nonatomic, assign) NSInteger  currentIndex;

@property(nonatomic, strong) NSArray<JHRecycleTemplateImageModel *> * seleTemplateModelArr;
@property(nonatomic, strong) JHC2CUploadProductDetailModel * dataModel;


/// 上传信息模型
@property(nonatomic, strong) JHC2CUploadProductModel * uploadModel;
@property(nonatomic, strong) JHBusinesspublishModel * publishModle;
/// 是否成功设置价格 拍卖或一口价
@property(nonatomic, assign) BOOL  hasSetPrice;


/// 是否完成图片上传
@property(nonatomic, assign) BOOL  hasFinishUpload;


/// 出价控制器
@property(nonatomic, strong) JHC2CInputPriceController * inputPriceVC;


/// 上传信息模型
@property(nonatomic, strong) JHC2CPublishSuccessBackModel * uploadSuccessModel;

@property(nonatomic, strong) JHBusinessPubishNomalModel *backModel;

@property(nonatomic, assign) JHB2CPublishGoodsType publishtype;

@property (nonatomic,copy) NSString * productId;
@property (nonatomic,assign) BOOL isEdit;
@end

@implementation JHBusinessPublishGoodsController
- (instancetype)initWithPublishType:(JHB2CPublishGoodsType)type{
    self = [super init];
    if (self) {
        self.publishtype = type;
        self.isEdit = NO;
    }
    return self;
}
- (instancetype)initWithPublishProductId:(NSString *)productId{
    self = [super init];
    if (self) {
        self.productId = productId;
        self.isEdit = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布商品";
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(addPictureWithNotifiction:) name:@"NSNotifacation_JHPictureBrowserCropViewController_Asset" object:nil];
    if (self.isEdit) {
//        [self requestProductInfo];
    }else{
        [self setItems];
        [self layoutItems];
    }
    [self shuxingjiekou];
}

- (void)addPictureWithNotifiction:(NSNotification*)notification{
    PHAsset *asset = notification.userInfo[@"Asset"];
    JHRecyclePhotoInfoModel *photoModel = [JHRecyclePhotoInfoModel new];
    photoModel.mediaType = asset.mediaType;
    photoModel.asset = asset;
//    [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
    [self.infoView addProductDetailPictureWithModelArr:@[photoModel]];

}

- (void)requestProductInfo{
    @weakify(self);
    [JHBusinessGoodsUploadBusiness requestB2CBackProductWithModel:self.productId Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
        @strongify(self);
        self.publishModle = [JHBusinesspublishModel mj_objectWithKeyValues:respondObject.data];
        self.publishtype = (self.publishModle.productType == 0)? JHB2CPublishGoodsType_BuyNow:JHB2CPublishGoodsType_Auction;
        
        [self setItems];
        [self layoutItems];
        self.infoView.normalModel = self.backModel;
        [self.infoView showNetData:self.publishModle];
    }];
    
}
-(void)shuxingjiekou{
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/getPublishInfo") Parameters:@{@"businessLineType":@"MALL"} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        self.backModel = [JHBusinessPubishNomalModel  mj_objectWithKeyValues:respondObject.data];
        if (_infoView) {
            _infoView.normalModel = self.backModel;
        }
        if (self.isEdit) {
            [self requestProductInfo];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
}

- (void)backActionButton:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.inInSeletePhoto = NO;
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:YES];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = YES;
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:NO];
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = NO;
    }
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter  removeObserver:self];
}
#pragma mark -- <Actions>
- (void)addProductPictureWithIndex:(NSInteger)index{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHB2CImagePickerType_Product;
    self.currentIndex = index;
    NSArray<JHRecycleTemplateImageModel*> *temArr = self.seleTemplateModelArr;
    if (temArr == nil) {
        temArr = [self.exampleModelArr jh_map:^id _Nonnull(JHRecycleUploadExampleModel * _Nonnull obj, NSUInteger idx) {
            JHRecycleTemplateImageModel *model = [JHRecycleTemplateImageModel new];
            model.titleText = obj.exampleDesc;
            if (index == idx) {model.isSelected = YES;}
            return model;
        }];
    }else{
        [temArr enumerateObjectsUsingBlock:^(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelected = index == idx;
        }];
    }
    JHRecycleTemplateCameraViewController *vc = [[JHRecycleTemplateCameraViewController alloc] init];
    vc.singleModelArr = self.exampleModelArr;
    vc.templateList = temArr;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
    
}

- (void)addProductDetailPictureWithMaxCount:(NSInteger)count{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHB2CImagePickerType_Product;
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.allowCrop = YES;
    vc.showTitle = @"商品图片";
    vc.examImageUrl = @"abc";
    vc.allowTakePhone = YES;
    vc.allowRecordVideo = NO;
    vc.maximum = 1;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)addProductDetailPictureWithMaxCount2:(NSInteger)count{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHB2CImagePickerType_Detail;
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.allowTakePhone = YES;
    vc.allowRecordVideo = NO;
    vc.examImageUrl = @"abc";
    vc.showTitle = @"商品图片";
    vc.maximum = count;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
}
- (void)addProductDetailPictureWithMaxCount3:(NSInteger)count{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHB2CImagePickerType_Video;
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.allowTakePhone = NO;
    vc.allowRecordVideo = YES;
    vc.examImageUrl = @"abc";
    vc.showTitle = @"商品视频";
    vc.maximum = count;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)delProductPictureWithIndex:(NSInteger)index{
    if (self.seleTemplateModelArr.count > index) {
        JHRecycleTemplateImageModel *model = self.seleTemplateModelArr[index];
        model.asset = nil;
        model.thumbnailImage = nil;
        model.localIdentifier = nil;
        model.asset = nil;
    }
}

- (void)refreshWithTemplateImageModelArr:(NSArray<JHRecycleTemplateImageModel *> *)modelArr{
    if(self.pickerType == JHB2CImagePickerType_Product){
        self.seleTemplateModelArr = modelArr;
//        [modelArr enumerateObjectsUsingBlock:^(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.asset) {
//                [self.infoView addProductPictureWithName:[JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj] andIndex:idx];
//            }
//        }];
        NSArray<JHRecyclePhotoInfoModel*>* photoModelArr = [modelArr jh_map:^id _Nonnull(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx) {
            if (obj.asset) {
                return [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
            }
            return nil;
        }];
        [self.infoView addProductDetailPictureWithModelArr:photoModelArr];
    }else if(self.pickerType == JHB2CImagePickerType_Detail){
        NSArray<JHRecyclePhotoInfoModel*>* photoModelArr = [modelArr jh_map:^id _Nonnull(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx) {
            if (obj.asset) {
                return [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
            }
            return nil;
        }];
        [self.infoView addProductDetailPictureWithModelArr2:photoModelArr];
    }
    else if(self.pickerType == JHB2CImagePickerType_Video){
        NSArray<JHRecyclePhotoInfoModel*>* photoModelArr = [modelArr jh_map:^id _Nonnull(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx) {
            if (obj.asset) {
                return [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
            }
            return nil;
        }];
        [self.infoView addProductVideoDetailPictureWithName:[photoModelArr firstObject]];
    }
}

- (void)jianDingActionWithSender:(UIButton*)sender{
//    NSString *title = @"发布商品";
//    if (sender.selected) {
//        float fee = self.dataModel.appraisalCategoryAttrDTO.appraisalFee.floatValue;
//        if (self.dataModel.orderDiscountListResp.myCouponVoList.count>0) {
//            OrdermyCouponVoInfoResp * dic = [self.dataModel.orderDiscountListResp.myCouponVoList firstObject];
//            fee = fee - [dic.price floatValue];
//        }
//        title = [NSString stringWithFormat:@"发布商品并支付%.2f元(鉴定费)", fee];
//    }
//    [self.bottomView.publishBtn setTitle:title forState:UIControlStateNormal];

}


- (void)jumpRulerVc{
//    JHWebViewController *webView = [[JHWebViewController alloc] init];
//    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/releaseRules.html");
//    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
//
}

- (BOOL)checkAliyunosImageUrl{
    __block BOOL finish = YES;
    [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.aliossUrl){
            finish = NO;
        }
    }];
    
    [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.aliossUrl){
            finish = NO;
        }
    }];
    return finish;
}


/// 发布按钮
- (void)publishBtnAction{

    
    if(self.publishModle.productName.length == 0){
        [SVProgressHUD showInfoWithStatus:@"商品名称不可为空"];
        return;
    }
    if(self.publishModle.thirdCategoryId.length == 0){
        [SVProgressHUD showInfoWithStatus:@"商品分类不可为空"];
        return;
    }
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        if (self.publishModle.price.length == 0 || [self.publishModle.price floatValue] == 0) {
            [SVProgressHUD showInfoWithStatus:@"售价需大于0"];
            return;
        }
        if(self.publishModle.stock == 0){
            [SVProgressHUD showInfoWithStatus:@"可售库存不能为空"];
            return;
        }
    }else{
        
        if (self.publishModle.startPrice.length == 0 || [self.publishModle.startPrice floatValue] == 0) {
            [SVProgressHUD showInfoWithStatus:@"起拍价需大于0"];
            return;
        }
        if(self.publishModle.bidIncrement.length == 0  || [self.publishModle.bidIncrement floatValue] == 0){
            [SVProgressHUD showInfoWithStatus:@"加价幅度需大于0"];
            return;
        }
        if (self.publishModle.productStatus == 0) { //立即上架
            if (self.publishModle.auctionLastTime.length == 0 || [self.publishModle.auctionLastTime isEqualToString:@"0"]) {
                [SVProgressHUD showInfoWithStatus:@"持续时间不可为空"];
                return;
            }
        }
        if (self.publishModle.productStatus == 3) { //指定时间
            if (self.publishModle.auctionStartTime.length == 0 || [self.publishModle.auctionStartTime isEqualToString:@"0"]) {
                [SVProgressHUD showInfoWithStatus:@"开始时间不可为空"];
                return;
            }
            if (self.publishModle.auctionLastTime.length == 0 || [self.publishModle.auctionLastTime isEqualToString:@"0"]) {
                [SVProgressHUD showInfoWithStatus:@"持续时间不可为空"];
                return;
            }
        }
        
    }
    
   
    
    if (self.isEdit) {
        self.publishModle.productId = self.productId;
        NSMutableArray *imageDetailUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
        [self.publishModle.detailImages enumerateObjectsUsingBlock:^(JHIssueGoodsEditImageItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageDetailUrlArr addObject:obj.path];
        }];
        [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageDetailUrlArr addObject:obj.aliossUrl];
        }];
        
        NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productPictureArr.count];
        [self.publishModle.mainImages enumerateObjectsUsingBlock:^(JHIssueGoodsEditImageItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageUrlArr addObject:obj.path];
        }];
        [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageUrlArr addObject:obj.aliossUrl];
        }];
        
        if(imageUrlArr.count == 0){
            [SVProgressHUD showInfoWithStatus:@"商品主图不可为空"];
            return;
        }
        if(imageDetailUrlArr.count == 0){
            [SVProgressHUD showInfoWithStatus:@"商品详情图不可为空"];
            return;
        }
        
        NSMutableArray * attarray = [NSMutableArray array];
        for (JHBusinessGoodsAttributeModel*temp in self.infoView.attributeArray) {
            if (temp.showValue.length>0) {
                JHBusinessGoodsAttributeModel *dic = [[JHBusinessGoodsAttributeModel alloc] init];
                dic.attrId = temp.attrId;
                dic.attrValue = temp.showValue;
                [attarray addObject:dic];
            }
        }
        if (attarray.count>0) {
            self.publishModle.attrs = attarray;
        }
        
        self.publishModle.mainImageUrl = [imageUrlArr componentsJoinedByString:@","];
        self.publishModle.detailImageUrl = [imageDetailUrlArr componentsJoinedByString:@","];
        if (self.publishModle.videoDetail) {
            self.publishModle.videoUrl = self.publishModle.videoDetail.path;
        }
        if (self.infoView.selectVideoModel) {
            self.publishModle.videoUrl = self.infoView.selectVideoModel.aliossUrl;
        }
        [SVProgressHUD show];
        [JHBusinessGoodsUploadBusiness requestB2CEditProductWithModel:self.publishModle completion:^(NSError * _Nullable error, JHC2CPublishSuccessBackModel * _Nullable model) {
            [SVProgressHUD dismiss];
            if(error){
                [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
            } else {
                JHTOAST(@"发布成功");
                if (self.successBlock) {
                    self.successBlock(self.publishModle.productStatus);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        NSMutableArray *imageDetailUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
        [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSNumber* type = obj.mediaType == PHAssetMediaTypeImage ? @0 : @1;
    //        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
    //        parDic[@"type"] = type;
    //        parDic[@"url"] = obj.aliossUrl;
            [imageDetailUrlArr addObject:obj.aliossUrl];
        }];
        
        NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productPictureArr.count];
        [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
    //        JHRecycleUploadExampleModel *model = self.exampleModelArr[idx];
    //        parDic[@"location"] = model.exampleDesc;
    //        parDic[@"url"] = obj.aliossUrl;
            [imageUrlArr addObject:obj.aliossUrl];
        }];
        if(imageUrlArr.count == 0){
            [SVProgressHUD showInfoWithStatus:@"商品主图不可为空"];
            return;
        }
        if(imageDetailUrlArr.count == 0){
            [SVProgressHUD showInfoWithStatus:@"商品详情图不可为空"];
            return;
        }
        
        NSMutableArray * attarray = [NSMutableArray array];
        for (JHBusinessGoodsAttributeModel*temp in self.infoView.attributeArray) {
            if (temp.showValue.length>0) {
                JHBusinessGoodsAttributeModel *dic = [[JHBusinessGoodsAttributeModel alloc] init];
                dic.attrId = temp.attrId;
                dic.attrValue = temp.showValue;
                [attarray addObject:dic];
            }
        }
        if (attarray.count>0) {
            self.publishModle.attrs = attarray;
        }
        self.publishModle.mainImageUrl = [imageUrlArr componentsJoinedByString:@","];
        self.publishModle.detailImageUrl = [imageDetailUrlArr componentsJoinedByString:@","];
        if (self.infoView.selectVideoModel) {
            self.publishModle.videoUrl = self.infoView.selectVideoModel.aliossUrl;
        }
        if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
            self.publishModle.productType = 0;
        }else if(self.publishtype == JHB2CPublishGoodsType_Auction){
            self.publishModle.productType = 1;
        }
        [SVProgressHUD show];
        [JHBusinessGoodsUploadBusiness requestB2CUploadProductWithModel:self.publishModle completion:^(NSError * _Nullable error, JHC2CPublishSuccessBackModel * _Nullable model) {
            [SVProgressHUD dismiss];
            if(error){
                [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
            }else{
                //返回发布成功模型
                JHTOAST(@"发布成功");
                [self jumpUploadSuccessVC];
            }
        }];
    }
}


/// 发布成功跳转成功页面
- (void)jumpUploadSuccessVC{
    
    JHGoodManagerListViewController *vc = [[JHGoodManagerListViewController alloc] init];
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        vc.productType = JHGoodManagerListRequestProductType_OnePrice;
    }else{
        vc.productType = JHGoodManagerListRequestProductType_Auction;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
    for ( UIViewController *vc in arr) {
        if ([vc isKindOfClass:[JHBusinessPublishGoodsController class]]) {
            [arr removeObject:vc];
            self.navigationController.viewControllers = arr;
            return;
        }
    }
}

#pragma mark -- <Private menth>

- (void)setItems{
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.infoView];
}

- (void)layoutItems{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-25);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

#pragma mark -- <get and set>

- (JHRecycleSureButton *)bottomView{
    if (!_bottomView) {
        _bottomView = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
        [_bottomView setTitle:@"确认发布" forState:UIControlStateNormal];
        [_bottomView addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        _bottomView.publishBtn.enabled = NO;
    }
    return _bottomView;
}

- (JHBusinessPubishInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[JHBusinessPubishInfoView alloc] initWithFrame:CGRectZero andExampleModelArr:self.exampleModelArr andSeleModelArr:self.dataModel.backAttrRelationResponses andPubModel:self.publishModle  andPublishType:self.publishtype];
//        _infoView.publishModle = self.publishModle;
        @weakify(self);
        [_infoView setAddProductPictureBlock:^(NSInteger index) {
            @strongify(self);
            [self addProductPictureWithIndex:index];
        }];
        [_infoView setAddProductDetailBlock:^(NSInteger maxCount) {
            @strongify(self);
            [self addProductDetailPictureWithMaxCount:maxCount];
        }];
        [_infoView setAddProductDetailBlock2:^(NSInteger maxCount) {
            @strongify(self);
            [self addProductDetailPictureWithMaxCount2:maxCount];
        }];
        [_infoView setAddProductDetailBlock3:^(NSInteger maxCount) {
            @strongify(self);
            [self addProductDetailPictureWithMaxCount3:maxCount];
        }];
        [_infoView setDelProductPictureBlock:^(NSInteger index) {
            @strongify(self);
            [self delProductPictureWithIndex:index];
        }];

    }
    return _infoView;
}

#pragma mark - 计算劵后价格
- (double)dealTicketAfterPrice{
    double result = -1;
    if (self.dataModel.orderDiscountListResp.myCouponVoList.count>0) {
        //鉴定费 - 红包
        double price1 = [self.dataModel.appraisalCategoryAttrDTO.appraisalFee doubleValue];
        
        OrdermyCouponVoInfoResp *youHuiDic = self.dataModel.orderDiscountListResp.myCouponVoList.firstObject;
        double price2 = [youHuiDic.price doubleValue];
        
        result = price1 - price2;
    }
    return result;
}

- (JHC2CUploadProductModel *)uploadModel{
    if (!_uploadModel) {
        _uploadModel = [JHC2CUploadProductModel new];
    }
    return _uploadModel;
}
- (JHBusinesspublishModel *)publishModle{
    if (!_publishModle) {
        _publishModle = [JHBusinesspublishModel new];
    }
    return _publishModle;
}

@end
