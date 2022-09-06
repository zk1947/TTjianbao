//
//  JHC2CUploadProductController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadProductController.h"
#import "BaseNavViewController.h"
#import <IQKeyboardManager.h>
#import "JHRecycleUploadProductBottomView.h"
#import "JHC2CProductUploadInfoView.h"
#import "JHC2CUploadProductBottomView.h"

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
#import "JHC2CUploadProductSuccessController.h"
#import "JHC2CProductUploadJianDingButton.h"
#import "JHC2CSelectClassViewController.h"
#import "JHAppraisePayView.h"
#import "JHAppAlertViewManger.h"
#import "JHC2CRulerAlertView.h"


typedef NS_ENUM(NSUInteger, JHC2CImagePickerType) {
    JHC2CImagePickerType_Product = 0,///商品图片
    JHC2CImagePickerType_Detail,///商品详情图片
};

@interface JHC2CUploadProductController ()

/// 底部悬浮视图
@property(nonatomic, strong) JHC2CUploadProductBottomView * bottomView;

/// 填写信息view
@property(nonatomic, strong) JHC2CProductUploadInfoView * infoView;

@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * exampleModelArr;

/// 当前进入多媒体类型
@property(nonatomic, assign) JHC2CImagePickerType  pickerType;

/// 是否进入相册选择中
@property(nonatomic, assign) BOOL  inInSeletePhoto;

/// 宝贝信息点击按钮index
@property(nonatomic, assign) NSInteger  currentIndex;

@property(nonatomic, strong) NSArray<JHRecycleTemplateImageModel *> * seleTemplateModelArr;
@property(nonatomic, strong) JHC2CUploadProductDetailModel * dataModel;


/// 上传信息模型
@property(nonatomic, strong) JHC2CUploadProductModel * uploadModel;

/// 是否成功设置价格 拍卖或一口价
@property(nonatomic, assign) BOOL  hasSetPrice;


/// 是否完成图片上传
@property(nonatomic, assign) BOOL  hasFinishUpload;


/// 出价控制器
@property(nonatomic, strong) JHC2CInputPriceController * inputPriceVC;


/// 上传信息模型
@property(nonatomic, strong) JHC2CPublishSuccessBackModel * uploadSuccessModel;

@property (nonatomic, strong) CommAlertView *sendAlert;

@property (nonatomic, strong) CommAlertView *editAlert;

@end

@implementation JHC2CUploadProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写宝贝信息";
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(publishBtnAction) name:@"JHC2CRealNameSuccess" object:nil];
    [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
    [JHC2CProductUploadBusiness requestC2CUploadProductDetailBackCateId:self.thirdCategoryId completion:^(NSError * _Nullable error, JHC2CUploadProductDetailModel * _Nullable model) {
        self.dataModel = model;
        self.exampleModelArr = [model.backProductPicConfResponses jh_map:^id _Nonnull(BackProductPicConfResponse * _Nonnull obj, NSUInteger idx) {
            JHRecycleUploadImageInfoModel *image = [JHRecycleUploadImageInfoModel new];
            image.small = obj.imageUrl;
            image.origin = obj.imageUrl;
            image.medium = obj.imageUrl;
            image.big = obj.imageUrl;
            JHRecycleUploadExampleModel *exaModel = [JHRecycleUploadExampleModel new];
            exaModel.categoryId = obj.cateId;
            exaModel.exampleDesc  = obj.sampleName;
            exaModel.exampleId  = obj.sampleId;
            exaModel.imgType = obj.imgType.integerValue;
            exaModel.baseImage = image;
            return exaModel;
        }];
        [self setItems];
        [self layoutItems];
        
        //编辑进入则回显编辑数据，否则回显本地数据
        if (_editModel) {
            [self showNetData];
        }else{
            //判断本地数据与后端格式是否一致，一致则回显本地数据，否则清空本地数据
            [self showLocalData];
        }
        
        //弹框
        BOOL hasShow = [NSUserDefaults.standardUserDefaults boolForKey:@"JHC2C_upload_AlertShow"];
        if (!hasShow) {
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"JHC2C_upload_AlertShow"];
            [NSUserDefaults.standardUserDefaults synchronize];
            JHC2CRulerAlertView *view =  [JHC2CRulerAlertView new];
            [self.view addSubview:view];
        }

    }];
    [self addStatistic];
}

- (void)backActionButton:(UIButton *)sender{
    if (!self.hasFinishUpload && [self checkIsEdit]) {
        if (_editModel) {
            [self.editAlert show];
        }else{
            [self.sendAlert show];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkIsEdit{
    if(self.infoView.productIllustration.length>0){//描述
        return YES;
    }else if(self.infoView.productPictureArr.count == self.exampleModelArr.count && self.exampleModelArr.count > 0){//图片
        return YES;
    }else if(self.infoView.productDetailPictureArr.count>0){//细节图片
        return YES;
    }
    else if(self.uploadModel.auctionDic != nil || self.uploadModel.priceDic != nil){//价格
        return YES;
    }
    NSArray *attArr = [self.infoView.attDic allKeys];
    for (NSString *key in attArr) {
        if (![self.infoView.attDic[key] isEqualToString:@""]) {//规格
            return YES;
        }
    }
    return NO;
}

- (CommAlertView *)sendAlert{
    if (!_sendAlert) {
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:@"是否保存当前编辑的信息？"];
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"提示" andMutableDesc:messageAtt cancleBtnTitle:@"不保存" sureBtnTitle:@"保存" andIsLines:NO];
//        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"提示" andDesc:@"是否保存当前编辑的信息？" cancleBtnTitle:@"不保存" sureBtnTitle:@"保存"];
        @weakify(self);
        //不保存
        alert.cancleHandle = ^{
            @strongify(self);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendData"];
            [self.navigationController popViewControllerAnimated:YES];
        };
        //保存
        alert.handle = ^{
            @strongify(self);
            [self saveDataToLocal];
            [self.navigationController popViewControllerAnimated:YES];
        };
        _sendAlert = alert;
    }
    return _sendAlert;
}

- (CommAlertView *)editAlert{
    if (!_editAlert) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"宝贝尚未完成编辑，是否继续操作？" cancleBtnTitle:@"退出" sureBtnTitle:@"继续编辑"];
        @weakify(self);
        //不保存
        alert.cancleHandle = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        //保存
//        alert.handle = ^{
//            @strongify(self);
//        };
        _editAlert = alert;
    }
    return _editAlert;
}

///数据存本地
- (void)saveDataToLocal{
    NSMutableDictionary *localDic = [NSMutableDictionary dictionary];
    //存分类级别
    NSDictionary *levelDic = @{
        @"firstCategoryId":self.firstCategoryId,
        @"firstCategoryName":self.firstCategoryName,
        @"secondCategoryId":self.secondCategoryId,
        @"secondCategoryName":self.secondCategoryName,
        @"thirdCategoryId":self.thirdCategoryId,
        @"thirdCategoryName":self.thirdCategoryName
    };
    [localDic setObject:levelDic forKey:@"section0"];
    //存描述
    [localDic setObject:self.infoView.productIllustration forKey:@"section1"];
    //存图片
    NSMutableArray *imgArr = [NSMutableArray array];
    for (JHRecyclePhotoInfoModel *model in self.infoView.productPictureArr) {
        [imgArr addObject: model.asset.localIdentifier];
    }
    NSMutableArray *imgDetailArr = [NSMutableArray array];
    for (JHRecyclePhotoInfoModel *model in self.infoView.productDetailPictureArr) {
        [imgDetailArr addObject: model.asset.localIdentifier];
    }
    [localDic setObject:imgArr forKey:@"section2"];
    [localDic setObject:imgDetailArr forKey:@"section3"];
    //存规格属性
    [localDic setObject:self.infoView.attDic forKey:@"section4"];
    //存价格
    NSDictionary *auctionDic = self.uploadModel.auctionDic ? self.uploadModel.auctionDic:@{};
    NSDictionary *priceDic = self.uploadModel.priceDic ? self.uploadModel.priceDic:@{};
    NSDictionary *allPriceDic = @{
        @"productType":@(self.uploadModel.productType),
        @"auctionDic":auctionDic,
        @"priceDic":priceDic
    };
    [localDic setObject:allPriceDic forKey:@"section5"];
    //存是否鉴定
    [localDic setObject:@(self.infoView.jianDingBtn.selected) forKey:@"section6"];
    [[NSUserDefaults standardUserDefaults]setObject:localDic forKey:@"sendData"];
}

///本地数据回显
- (void)showLocalData{
    NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendData"];
    if (localDic) {
        //刷新描述
        self.infoView.productIllustration = localDic[@"section1"];
        //刷新主图片
        NSArray *imgArr = localDic[@"section2"];
        //判断图片数
        NSInteger imgCount = self.dataModel.backProductPicConfResponses.count > imgArr.count ? imgArr.count:self.dataModel.backProductPicConfResponses.count;
        for (NSInteger index = 0; index < imgCount; index++) {
            [self getModelWithId:imgArr[index] resultHandler:^(JHRecycleTemplateImageModel * _Nullable model) {
                [self.infoView addProductPictureWithName:[JHRecyclePhotoInfoModel photoInfoModelWithTempModel:model] andIndex:index];
            }];
        }
        //刷新细节图片
        NSArray *detailImgArr = localDic[@"section3"];
        NSMutableArray *detailResultArr = [NSMutableArray array];
        for (NSInteger index = 0; index < detailImgArr.count; index++) {
            [self getModelWithId:detailImgArr[index] resultHandler:^(JHRecycleTemplateImageModel * _Nullable model) {
                [detailResultArr addObject:[JHRecyclePhotoInfoModel photoInfoModelWithTempModel:model]];
            }];
        }
        [self.infoView addProductDetailPictureWithModelArr:detailResultArr];
        //刷新属性
        self.infoView.attDic = localDic[@"section4"];
        //刷新价格
        NSDictionary *priceDic = localDic[@"section5"];
        if ([priceDic[@"productType"] integerValue] == 0) {
            NSNumber *num1 = priceDic[@"priceDic"][@"price"];
            if (num1) {
                NSNumber *num3 = priceDic[@"priceDic"][@"freight"];
                self.infoView.postPrice = num3.integerValue == 0 ? @"" : [self changeNumToStr:num3];
                self.infoView.price = [self changeNumToStr:num1];
            }
        }else{
            NSNumber *num1 = priceDic[@"auctionDic"][@"startPrice"];
            if (num1) {
                self.infoView.postPrice = @"";
                self.infoView.price = [self changeNumToStr:num1];
            }
        }
        //数据保存
        [self savePriceData:priceDic];
        //刷新是否鉴定
        if ([localDic[@"section6"] integerValue] == 1) {
            self.infoView.jianDingBtn.selected = YES;
            [self changeSendBtnText:YES];
        }
    }
}

///网络数据回显
- (void)showNetData{
    //刷新描述
    self.infoView.productIllustration = self.editModel.productDesc;
    //刷新主图片
    for (NSInteger index = 0; index < self.editModel.mainImageUrl.count; index++) {
        JHIssueGoodsEditImageItemModel *model = self.editModel.mainImageUrl[index];
        [self.infoView showNetImage:model andIndex:index];
    }
    //刷新细节图片
    [self.infoView addNetProductDetailPictureWithModelArr:self.editModel.detailImages];
    //刷新属性
    if (self.editModel.attrs.count>0) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        for (NSDictionary *dic in self.editModel.attrs) {
            NSString *key = [NSString stringWithFormat:@"%@",dic[@"attrId"]];
            [resultDic setValue:dic[@"attrValue"] forKey:key];
        }
        self.infoView.netAttDic = resultDic;
        self.infoView.detailInfoView.attDic = resultDic;
        
//        self.infoView.netAttDic = self.editModel.attrs[0];
//        NSDictionary *dic = self.editModel.attrs[0];
//        NSString *key = [NSString stringWithFormat:@"%@",dic[@"attrId"]];
//        self.infoView.attDic = [@{key:dic[@"attrValue"]} mutableCopy];
    }
    //刷新价格
    if (self.editModel.productType == 0) {
        //一口价
        NSNumber *num1 = self.editModel.price[@"price"];
        if (num1) {
            NSNumber *num3 = self.editModel.price[@"freight"];
            self.infoView.postPrice = num3.integerValue == 0 ? @"" : [self changeNumToStr:num3];
            self.infoView.price = [self changeNumToStr:num1];
        }
    }else{
        //拍卖
        NSNumber *num1 = self.editModel.auction[@"startPrice"];
        if (num1) {
            self.infoView.postPrice = @"";
            self.infoView.price = [self changeNumToStr:num1];
        }
    }
    [self saveNetPriceData:self.editModel];
    
    //刷新是否鉴定
//    if ([localDic[@"section6"] integerValue] == 1) {
//        self.infoView.jianDingBtn.selected = YES;
//        [self changeSendBtnText:YES];
//    }
}

- (NSString *)changeNumToStr:(NSNumber *)num{
    //将分转为元为单位
    NSString *numStr = nil;
    numStr = [NSString stringWithFormat:@"%ld",num.integerValue/100];
    if (num.integerValue%100 == 0) {//120
        return numStr;
    }
    if (num.integerValue%10 == 0) {
        numStr = [NSString stringWithFormat:@"%@.%ld",numStr,num.integerValue/10%10];
        return numStr;
    }
    numStr = [NSString stringWithFormat:@"%@.%ld",numStr,num.integerValue%100];
    return numStr;
}

- (void)savePriceData:(NSDictionary *)priceDic{
    self.uploadModel.productType = [priceDic[@"productType"] integerValue];
    if ([priceDic[@"productType"] integerValue] == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        dic[@"price"] = priceDic[@"priceDic"][@"price"];
        dic[@"originPrice"] = priceDic[@"priceDic"][@"originPrice"];
        dic[@"freight"] = priceDic[@"priceDic"][@"freight"];
        NSNumber *num3 = priceDic[@"priceDic"][@"needFreight"];
        dic[@"needFreight"] = num3.integerValue == 1 ? @1 : @0;
        self.uploadModel.priceDic = dic;
        self.uploadModel.auctionDic = nil;
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        dic[@"startPrice"] = priceDic[@"auctionDic"][@"startPrice"];
        dic[@"bidIncrement"] = priceDic[@"auctionDic"][@"bidIncrement"];
        NSNumber *baoZhengJin = @0;
        NSNumber *price3 = priceDic[@"auctionDic"][@"earnestMoney"];
        if (price3.integerValue>0) {
            baoZhengJin = priceDic[@"auctionDic"][@"earnestMoney"];
            dic[@"earnestMoney"] = baoZhengJin;
        }
        dic[@"auctionStartTime"] = priceDic[@"auctionDic"][@"auctionStartTime"];;
        dic[@"auctionEndTime"] = priceDic[@"auctionDic"][@"auctionEndTime"];;
        self.uploadModel.auctionDic = dic;
        self.uploadModel.priceDic = nil;
    }
}

- (void)saveNetPriceData:(JHIssueGoodsEditModel *)model{
    self.uploadModel.productType = model.productType;
    if (model.productType == 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        dic[@"price"] = model.price[@"price"];
        dic[@"originPrice"] = model.price[@"originPrice"];
        dic[@"freight"] = model.price[@"freight"];
        NSNumber *num3 = model.price[@"needFreight"];
        dic[@"needFreight"] = num3.integerValue == 1 ? @1 : @0;
        self.uploadModel.priceDic = dic;
        self.uploadModel.auctionDic = nil;
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        dic[@"startPrice"] =   model.auction[@"startPrice"];
        dic[@"bidIncrement"] = model.auction[@"bidIncrement"];
        NSNumber *baoZhengJin = @0;
        NSNumber *price3 = model.auction[@"earnestMoney"];
        if (price3.integerValue>0) {
            baoZhengJin = model.auction[@"earnestMoney"];
            dic[@"earnestMoney"] = baoZhengJin;
        }
        dic[@"auctionStartTime"] = model.auction[@"auctionStartTime"];
        dic[@"auctionEndTime"] = model.auction[@"auctionEndTime"];
        self.uploadModel.auctionDic = dic;
        self.uploadModel.priceDic = nil;
    }
}

///根据localIdentifier获取相册数据信息
- (void)getModelWithId:(NSString *)localIdentifier resultHandler:(void (^)(JHRecycleTemplateImageModel * _Nullable model))resultHandler{
    PHFetchResult * result =  [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    if (result.lastObject == nil) {
        return;
    }
    PHAsset *asset = result.lastObject;
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            JHRecycleTemplateImageModel *model = [JHRecycleTemplateImageModel new];
            model.thumbnailImage = result;
            model.titleText = @"";
            model.asset = asset;
            model.localIdentifier = localIdentifier;
            model.isSelected = NO;
            resultHandler(model);
        });
    }];
}

/// 二次确认返回弹窗
- (void)showAlert{
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:@"宝贝尚未完成上传，是否继续上传。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSArray<UIViewController*> *arr =  self.navigationController.viewControllers;
//        NSMutableArray *newVCArr = [NSMutableArray arrayWithCapacity:0];
//        [arr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (![obj isKindOfClass:JHC2CSelectClassViewController.class]) {
//                [newVCArr addObject:obj];
//            }
//        }];
//        self.navigationController.viewControllers = newVCArr;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:nil];
    [alertV addAction:deleteAction];
    [alertV addAction:cancelAction];
    [JHRootController.currentViewController presentViewController:alertV animated:YES completion:nil];

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
    self.pickerType = JHC2CImagePickerType_Product;
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
    vc.fromType = TemplateCameraFromTypeC2C;
    vc.firstCategoryName = self.firstCategoryName;
    vc.singleModelArr = self.exampleModelArr;
    vc.templateList = temArr;
    vc.firstCategoryName = self.firstCategoryName;
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
    self.pickerType = JHC2CImagePickerType_Detail;
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.examImageUrl = @"abc";
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
    if(self.pickerType == JHC2CImagePickerType_Product){
        self.seleTemplateModelArr = modelArr;
        [modelArr enumerateObjectsUsingBlock:^(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.asset) {
                [self.infoView addProductPictureWithName:[JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj] andIndex:idx];
            }
        }];
    }else{
        NSArray<JHRecyclePhotoInfoModel*>* photoModelArr = [modelArr jh_map:^id _Nonnull(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx) {
            if (obj.asset) {
                return [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
            }
            return nil;
        }];
        [self.infoView addProductDetailPictureWithModelArr:photoModelArr];
    }
}

- (void)jianDingActionWithSender:(UIButton*)sender{
    [self changeSendBtnText:sender.selected];
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

- (void)changeSendBtnText:(BOOL)isAuth{
    NSString *title = @"发布商品";
    if (isAuth) {
        float fee = self.dataModel.appraisalCategoryAttrDTO.appraisalFee.floatValue;
        if (self.dataModel.orderDiscountListResp.myCouponVoList.count>0) {
            OrdermyCouponVoInfoResp * dic = [self.dataModel.orderDiscountListResp.myCouponVoList firstObject];
            fee = fee - [dic.price floatValue];
        }
        title = [NSString stringWithFormat:@"发布商品并支付%.2f元(鉴定费)", fee];
    }
    [self.bottomView.publishBtn setTitle:title forState:UIControlStateNormal];
}

- (void)jumpRulerVc{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/releaseRules.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
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
    if(self.exampleModelArr.count == 0){
        [SVProgressHUD showInfoWithStatus:@"获取发布数据失败"];
        return;
    }
    if(!self.infoView.productIllustration.length){
        [SVProgressHUD showInfoWithStatus:@"还未填写描述信息"];
        return;
    }
    
    if(self.infoView.productPictureArr.count != self.exampleModelArr.count &&!_editModel){
        [SVProgressHUD showInfoWithStatus:@"还未填选择必传图片信息"];
        return;
    }
     
//    if (!_editModel && self.infoView.productDetailPictureArr.count == 0) {
//        [SVProgressHUD showInfoWithStatus:@"还未填选择细节图片信息"];
//        return;
//    }
    
    if(self.uploadModel.auctionDic == nil && self.uploadModel.priceDic == nil){
        [SVProgressHUD showInfoWithStatus:@"还未填写价格信息"];
        return;
    }
    
    //是否开启实名验证
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.isFaceAuth.intValue == 0) {
        [self showRealNameAlertView];
        return;
    }
    [SVProgressHUD show];
    if (![self checkAliyunosImageUrl]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self publishBtnAction];
        });
        return;
    }
    self.uploadModel.productDesc = self.infoView.productIllustration;
    self.uploadModel.attrsDic = self.infoView.attDic;
    self.uploadModel.firstCategoryId = self.firstCategoryId;
    self.uploadModel.secondCategoryId = self.secondCategoryId;
    self.uploadModel.thirdCategoryId = self.thirdCategoryId;
    self.uploadModel.identify = self.infoView.jianDingBtn.isSelected ? 1 : 0;
    
    if (_editModel && self.infoView.productDetailPictureArr.count == 0) {
        NSMutableArray *imageDetailUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
        [_editModel.detailImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JHIssueGoodsEditImageItemModel *model = obj;
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
            parDic[@"type"] = @(model.type);
            parDic[@"url"] = model.path;
            [imageDetailUrlArr addObject:parDic];
        }];
        self.uploadModel.detailImagesArr = imageDetailUrlArr;
    }else{
        NSMutableArray *imageDetailUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
        [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber* type = obj.mediaType == PHAssetMediaTypeImage ? @0 : @1;
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
            parDic[@"type"] = type;
            parDic[@"url"] = obj.aliossUrl;
            [imageDetailUrlArr addObject:parDic];
        }];
        self.uploadModel.detailImagesArr = imageDetailUrlArr;
    }
    
    
    if (_editModel && self.infoView.productPictureArr.count == 0) {
        NSMutableArray *imageUrlArr = [NSMutableArray array];
        [_editModel.mainImageUrl enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JHIssueGoodsEditImageItemModel *model = obj;
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
            parDic[@"location"] = model.location;
            parDic[@"url"] = model.path;
            [imageUrlArr addObject:parDic];
            self.uploadModel.mainImageUrlArr = imageUrlArr;
        }];
    }else{
        NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productPictureArr.count];
        [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
            JHRecycleUploadExampleModel *model = self.exampleModelArr[idx];
            parDic[@"location"] = model.exampleDesc;
            parDic[@"url"] = obj.aliossUrl;
            [imageUrlArr addObject:parDic];
        }];
        self.uploadModel.mainImageUrlArr = imageUrlArr;
    }
    
    if (_editModel) {
        self.uploadModel.productId = _editModel.productId;
    }

    //埋点
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"product_details_cnt"] = [NSNumber numberWithInteger:self.uploadModel.detailImagesArr.count];
    parDic[@"page_position"] = @"集市填写商品信息页";
    NSString *jianDing = self.infoView.jianDingBtn.selected?  @"发布商品并支付x元" : @"发布商品";
    parDic[@"operation_type"] = jianDing;
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickReleaseProduct" params:parDic type:JHStatisticsTypeSensors];

    [JHC2CProductUploadBusiness requestC2CUploadProductWithModel:self.uploadModel completion:^(NSError * _Nullable error, JHC2CPublishSuccessBackModel * _Nullable model) {
        [SVProgressHUD dismiss];
        if(error){
//            [SVProgressHUD showInfoWithStatus:error.userInfo[NSLocalizedDescriptionKey]];
            [self.view makeToast:error.userInfo[NSLocalizedDescriptionKey] duration:1.0 position:CSToastPositionCenter];
        }else{
            //清空本地存储的数据
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendData"];
            //返回发布成功模型
            self.hasFinishUpload = YES;
            self.uploadSuccessModel = model;
            if (self.infoView.jianDingBtn.isSelected) {
                [self showPayView];
            }else{
                [self jumpUploadSuccessVC];
            }
            
        }
    }];
}


/// 发布成功跳转成功页面
- (void)jumpUploadSuccessVC{
    JHC2CUploadProductSuccessController *vc = [JHC2CUploadProductSuccessController new];
    vc.model = self.uploadSuccessModel;
    vc.canAuth = self.dataModel.appraisalCategoryAttrDTO.hasOpen;
    vc.productType = [NSString stringWithFormat:@"%ld",self.uploadModel.productType];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showPayView{
    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init];
    payView.orderId = self.uploadSuccessModel.order.orderId;
    [JHKeyWindow addSubview:payView];
    [payView showAlert];
    
    @weakify(self);
    payView.paySuccessBlock = ^{
        @strongify(self);
        self.uploadSuccessModel.order.orderStatus = @"success";
        [self jumpUploadSuccessVC];
    };
    [payView setHiddenBlock:^{
        @strongify(self);
        [self jumpUploadSuccessVC];
    }];
}




- (void)showRealNameAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"实名认证" andDesc:@"为了提现账号安全，请先进行实名认证" cancleBtnTitle:@"去认证"];
    [alert dealTitleToCenter];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        JHRealNameAuthenticationViewController *vc = [[JHRealNameAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}



#pragma mark -- <Private menth>
- (void)showPriecVC:(NSString*)price{
    if (!self.inputPriceVC) {
        self.inputPriceVC = [JHC2CInputPriceController new];
        if (_editModel) {
            self.inputPriceVC.isEdit = YES;
        }
        @weakify(self);
        [self.inputPriceVC setFinish:^(BOOL isYiKouJia, NSString * _Nonnull price1, NSString * _Nonnull price2, NSString * _Nonnull price3, BOOL post, NSString * _Nonnull beginTime, NSString * _Nonnull endTime) {
            @strongify(self);
            self.hasSetPrice = YES;
            self.infoView.priceType = isYiKouJia ? 0 : 1;
            self.uploadModel.productType = isYiKouJia ? 0 : 1;
            if (isYiKouJia) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                dic[@"price"] = [self stringPriceChangetoNSNumber: price1];
                if (price2.length) {
                    dic[@"originPrice"] = [self stringPriceChangetoNSNumber: price2];
                }
                dic[@"freight"] = [self stringPriceChangetoNSNumber: price3];
                dic[@"needFreight"] = post ? @0 : @1;
                self.uploadModel.priceDic = dic;
                self.uploadModel.auctionDic = nil;
                self.infoView.postPrice = [self stringPriceChangetoNSNumber: price3].integerValue == 0 ? @"" : price3 ;
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
                dic[@"startPrice"] = [self stringPriceChangetoNSNumber: price1];
                dic[@"bidIncrement"] = [self stringPriceChangetoNSNumber: price2];
                NSNumber *baoZhengJin = @0;
                if (price3.length) {
                    baoZhengJin = [self stringPriceChangetoNSNumber: price3];
                    dic[@"earnestMoney"] = baoZhengJin;
                }
                dic[@"auctionStartTime"] = beginTime;
                dic[@"auctionEndTime"] = endTime;
                self.uploadModel.auctionDic = dic;
                self.uploadModel.priceDic = nil;
                self.infoView.postPrice = @"";
            }

            self.infoView.price = price1;

        }];
    }
    
    [self presentViewController:self.inputPriceVC animated:NO completion:^{
        //刷新价格
        if (_editModel) {
            [self.inputPriceVC reloadNetUIData:_editModel];
        }else{
            NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendData"];
            if (localDic) {
                NSDictionary *priceDic = localDic[@"section5"];
                [self.inputPriceVC reloadUIData:priceDic];
            }
        }
    }];
}


/// 字符串元  变更为 nsnumber 分
/// @param price
- (NSNumber*)stringPriceChangetoNSNumber:(NSString*)price{
    CGFloat yuan = price.floatValue * 100.f;
    NSInteger fen = (NSInteger)yuan;
    return [NSNumber numberWithInteger:fen];
}

- (void)setItems{
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.infoView];
}

- (void)layoutItems{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 95);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

#pragma mark -- <get and set>

- (JHC2CUploadProductBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [JHC2CUploadProductBottomView new];
        [_bottomView.publishBtn addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        _bottomView.publishBtn.enabled = NO;
        @weakify(self);
        [_bottomView setJumpRulerBlock:^{
            @strongify(self);
            [self jumpRulerVc];
        }];
        
    }
    return _bottomView;
}

- (JHC2CProductUploadInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[JHC2CProductUploadInfoView alloc] initWithFrame:CGRectZero andExampleModelArr:self.exampleModelArr andSeleModelArr:self.dataModel.backAttrRelationResponses];
        @weakify(self);
        [_infoView setAddProductPictureBlock:^(NSInteger index) {
            @strongify(self);
            [self addProductPictureWithIndex:index];
        }];
        [_infoView setAddProductDetailBlock:^(NSInteger maxCount) {
            @strongify(self);
            [self addProductDetailPictureWithMaxCount:maxCount];
        }];
        [_infoView setDelProductPictureBlock:^(NSInteger index) {
            @strongify(self);
            [self delProductPictureWithIndex:index];
        }];
        [_infoView setTapPriceBlock:^(NSString * _Nonnull currentPrice) {
            @strongify(self);
            [self  showPriecVC:currentPrice];
        }];
        _infoView.titleLbl.text = [NSString stringWithFormat:@"%@-%@",self.firstCategoryName, self.thirdCategoryName];
//        NSInteger fee = self.dataModel.appraisalCategoryAttrDTO.appraisalFee.integerValue;
//        NSString *yuan = [NSString stringWithFormat:@"%ld", fee/100];
        [_infoView.jianDingBtn refrshPrice:self.dataModel.appraisalCategoryAttrDTO.appraisalFee];
//        NSDictionary *youHuiDic = self.dataModel.orderDiscountListResp.myCouponVoList.firstObject;
        double price = [self dealTicketAfterPrice];
        [_infoView.jianDingBtn refrshSave:price];//youHuiDic[@"jiage"]
        _infoView.jianDingBtn.hidden = !self.dataModel.appraisalCategoryAttrDTO.hasOpen;
        [_infoView.jianDingBtn addTarget:self action:@selector(jianDingActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)addStatistic{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *name = @"集市填写商品信息页";
    parDic[@"page_name"] = name;
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:parDic type:JHStatisticsTypeSensors];
}


@end
