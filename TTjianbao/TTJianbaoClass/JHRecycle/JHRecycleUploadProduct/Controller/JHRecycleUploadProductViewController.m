//
//  JHRecycleUploadProductViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadProductViewController.h"
#import "JHRecycleUploadProductBottomView.h"
#import "JHRecycleInfoView.h"
#import "BaseNavViewController.h"
#import <IQKeyboardManager.h>
#import "JHRecyclePhotoInfoModel.h"
#import "JHRecycleUploadFinishViewController.h"
#import "JHRecycleUploadProductBusiness.h"
#import "TZImagePickerController.h"
#import "JHRecycleTemplateCameraViewController.h"
#import "JHRecycleCameraViewController.h"
#import "SVProgressHUD.h"
#import "JHWebViewController.h"


typedef NS_ENUM(NSUInteger, JHRecycleImagePickerType) {
    JHRecycleImagePickerType_Product = 0,///商品图片
    JHRecycleImagePickerType_Detail,///商品详情图片
};

@interface JHRecycleUploadProductViewController ()

/// 顶部提醒文字label
@property(nonatomic, strong) UILabel * topNoticeLbl;

/// 底部悬浮视图
@property(nonatomic, strong) JHRecycleUploadProductBottomView * bottomView;

/// 填写信息view
@property(nonatomic, strong) JHRecycleInfoView * infoView;

/// 宝贝信息点击按钮index
@property(nonatomic, assign) NSInteger  currentIndex;

/// 当前进入多媒体类型
@property(nonatomic, assign) JHRecycleImagePickerType  pickerType;

/// 是否进入相册选择中
@property(nonatomic, assign) BOOL  inInSeletePhoto;

@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * exampleModelArr;


@property(nonatomic, strong) NSArray<JHRecycleTemplateImageModel *> * seleTemplateModelArr;

@property(nonatomic, copy) NSString * firstCategoryName;
@end

@implementation JHRecycleUploadProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshButtonStatus) name:JHNotificationRecycleUploadImageInfoChanged object:nil];
    @weakify(self);
    [JHRecycleUploadProductBusiness requestRecycleUploadQueryExampleCategoryId:self.categoryId.integerValue Completion:^(NSError * _Nullable error, JHRecycleUploadExampleTotalModel * _Nullable model) {
        @strongify(self);
        self.exampleModelArr = model.singleImgSimples;
        self.firstCategoryName = model.firstCategoryName;
        self.title = [NSString stringWithFormat:@"卖%@",model.firstCategoryName];
        NSString * tempstr = @"";
        if ([self.typeName containsString:@"卖"]) {
            tempstr = [self.typeName substringFromIndex:1];
        }else{
            tempstr = self.typeName;
        }
        [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"回收填写商品信息页",@"source_module":tempstr}];
        [self setItems];
        [self layoutItems];
        [self.infoView refreshTopTypeViewWithName:self.typeName andImageName:self.typeImageName andmodle:model];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.inInSeletePhoto = NO;
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:YES];
    IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
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
    [NSNotificationCenter.defaultCenter removeObserver:self name:JHNotificationRecycleUploadImageInfoChanged object:nil];
}


- (void)setItems{
    [self.view addSubview:self.topNoticeLbl];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.infoView];
}

- (void)layoutItems{
    [self.topNoticeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@30);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 95);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.topNoticeLbl.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

#pragma mark -- <Action>
- (void)addProductPictureWithIndex:(NSInteger)index{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHRecycleImagePickerType_Product;
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
    vc.examImageUrl = self.typeImageName;
    vc.firstCategoryName = self.firstCategoryName;
    vc.categoryId = self.categoryId;
    vc.templateList = temArr;
    vc.currentIndex = index;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
    
    //打点统计
    JHRecycleUploadExampleModel *model = self.exampleModelArr[index];
    [self addStatisticForProductPhotoWithTemID:model.exampleId];
}

- (void)addProductDetailPictureWithMaxCount:(NSInteger)count{
    if (self.inInSeletePhoto) {return;}
    self.inInSeletePhoto = YES;
    self.pickerType = JHRecycleImagePickerType_Detail;
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.examImageUrl = self.typeImageName;
    vc.maximum = count;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [self.navigationController pushViewController:vc animated:true];
    //打点统计
    [self addStatisticForDetailPhoto];
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
    if(self.pickerType == JHRecycleImagePickerType_Product){
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


- (void)jumpRulerVc{
    //https://h5-testb.ttjianbao.com/jianhuo/app/agreement/releaseRules.html
    H5_BASE_HTTP_STRING(@"");
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/releaseRules.html");
//    @"https://h5-testb.ttjianbao.com/jianhuo/app/agreement/releaseRules.html";
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}


- (void)checkDataAndPublish{
    self.bottomView.publishBtn.enabled = NO;
    if ([self checkAliyunosImageUrl]) {
        [SVProgressHUD dismiss];
        [self finishAliossAndUploadServer];
    }else{
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self checkDataAndPublish];
        });
    }

}


- (void)publishBtnAction{
    [self addStatisticForPublishDetailCount:self.infoView.productDetailPictureArr.count];
    [self checkDataAndPublish];
    
}

- (void)finishAliossAndUploadServer{
    [SVProgressHUD show];
    NSMutableArray *imageDetailUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productDetailPictureArr.count];
    [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber* type = obj.mediaType == PHAssetMediaTypeImage ? @0 : @1;
        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
        parDic[@"detailType"] = type;
        parDic[@"detailUrl"] = obj.aliossUrl;
        [imageDetailUrlArr addObject:parDic];
    }];
    
    NSMutableArray *imageUrlArr = [NSMutableArray arrayWithCapacity:self.infoView.productPictureArr.count];
    [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:2];
        parDic[@"imgType"] = [NSNumber numberWithInteger:idx+1];
        parDic[@"imgUrl"] = obj.aliossUrl;
        [imageUrlArr addObject:parDic];
    }];

    [JHRecycleUploadProductBusiness requestRecycleProductPublishProductCategoryId:self.categoryId.integerValue
                                                                   andProductDesc:self.infoView.productIllustration
                                                                    andBusinessId:self.businessId
                                                                   andexpectPrice:self.infoView.expectPrice
                                                                andProductImgUrls:imageUrlArr
                                                             andProductDetailUrls:imageDetailUrlArr
                                                                    andCompletion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHRecycleUploadFinishViewController  *vc = [JHRecycleUploadFinishViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            self.bottomView.publishBtn.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }
    }];
}

- (BOOL)checkAliyunosImageUrl{
    __block BOOL finish = YES;
    __block NSInteger finishCount = 0;
    [self.infoView.productDetailPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.aliossUrl){
            finish = NO;
        }else{
            finishCount += 1;
        }
    }];
    
    [self.infoView.productPictureArr enumerateObjectsUsingBlock:^(JHRecyclePhotoInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.aliossUrl){
            finish = NO;
        }else{
            finishCount += 1;
        }
    }];
    if (!finish) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传图片中%ld/%ld", finishCount, self.infoView.productDetailPictureArr.count + self.infoView.productPictureArr.count]];
    }
    return finish;
}


- (BOOL)checkDataChange{
    return (self.infoView.productIllustration.length||
            self.infoView.productPictureArr.count||
            self.infoView.productDetailPictureArr.count);
}

- (void)refreshButtonStatus{
    if (self.infoView.productPictureArr.count == self.exampleModelArr.count && self.infoView.productIllustration.length) {
        self.bottomView.publishBtn.enabled = YES;
    }else{
        self.bottomView.publishBtn.enabled = NO;
    }
}

- (void)backActionButton:(UIButton *)sender{
    if ([self checkDataChange]) {
        [self showAlert];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 二次确认返回弹窗
- (void)showAlert{
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:@"宝贝尚未完成上传，是否继续上传。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续上传" style:UIAlertActionStyleDefault handler:nil];
    [alertV addAction:deleteAction];
    [alertV addAction:cancelAction];
    [JHRootController.currentViewController presentViewController:alertV animated:YES completion:nil];

}


#pragma mark -- <set and get>

- (UIView *)topNoticeLbl{
    if (!_topNoticeLbl) {
        UILabel *lbl = [UILabel new];
        lbl.backgroundColor = HEXCOLOR(0xFFFAF2);
        lbl.font = JHFont(12);
        lbl.textColor = HEXCOLOR(0xFF6A00);
        lbl.text = @"本人承诺所发布的钱币来源合法";
        lbl.textAlignment = NSTextAlignmentCenter;
        _topNoticeLbl = lbl;
    }
    return _topNoticeLbl;
}

- (JHRecycleUploadProductBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [JHRecycleUploadProductBottomView new];
        [_bottomView.publishBtn addTarget:self action:@selector(publishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.publishBtn.enabled = NO;
        @weakify(self);
        [_bottomView setJumpRulerBlock:^{
            @strongify(self);
            [self jumpRulerVc];
        }];
    }
    return _bottomView;
}

- (JHRecycleInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[JHRecycleInfoView alloc] initWithFrame:CGRectZero andExampleModelArr:self.exampleModelArr];
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
    }
    return _infoView;
}


#pragma mark -- <打点统计>
//打点统计
- (void)addStatisticForProductPhotoWithTemID:(NSString*)temId{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleWriteInfo";
    parDic[@"template_id"] = temId;
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickImageTemplate" params:parDic type:JHStatisticsTypeSensors];
}

- (void)addStatisticForDetailPhoto{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleWriteInfo";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickAddPicturesVideos" params:parDic type:JHStatisticsTypeSensors];
}

- (void)addStatisticForPublishDetailCount:(NSInteger)count{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"recycleWriteInfo";
    if (self.infoView.expectPrice.length>0) {
        parDic[@"expected_price"] = [NSNumber numberWithFloat:[self.infoView.expectPrice floatValue]];
    }else{
        parDic[@"expected_price"] = @"无";
    }
    parDic[@"product_details_cnt"] = [NSNumber numberWithInteger:count];
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickReleaseProduct" params:parDic type:JHStatisticsTypeSensors];
}

@end
