//
//  JHStonePersonReSellPublishController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JHStonePersonReSellPublishController.h"
#import "JHStonePersonReSellPublishModel.h"
#import "JHAddResourceCollectionView.h"
#import "TZImagePickerController.h"
#import "JHAiyunOSSManager.h"
#import "JHPutShelveModel.h"
#import "CommAlertView.h"
#import "JHPublishSourceItemModel.h"
#import "JHPublishEditModel.h"
#import <IQKeyboardManager.h>
#import <AVKit/AVKit.h>

/// 个人转售回血上传资源路径
NSString *const aliUploadPath = @"client_publish/resale_on_shelf";

@interface JHStonePersonReSellPublishController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate>

/// 图片资源
@property (nonatomic, strong) JHAddResourceCollectionView *photosView;

/// 视频资源
@property (nonatomic, strong) JHAddResourceCollectionView *videosView;

@property (nonatomic, strong) NSMutableArray<JHPublishSourceItemModel *> *allPhotos;
@property (nonatomic, strong) NSMutableArray<JHPublishSourceItemModel *> *allVideos;
/// 转码输出url
@property (nonatomic, strong) NSMutableArray *allVideoPaths;

/// 页面和上报数据模型
@property (nonatomic, strong) JHStonePersonReSellPublishModel *paramModel;

@end

@implementation JHStonePersonReSellPublishController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /// 键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    /// 键盘
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布转售商品";
    
    self.allVideos = [NSMutableArray array];
    self.allPhotos = [NSMutableArray array];
    self.allVideoPaths = [NSMutableArray array];
    
    ///编辑
    if(self.stoneResaleId && self.stoneResaleId.length){
        self.paramModel.stoneResaleId = self.stoneResaleId;
        [self updateUIMethod];
    }
    else{///发布
        self.paramModel.sourceOrderId = self.sourceOrderId;
        self.paramModel.sourceOrderCode = self.sourceOrderCode;
        self.paramModel.sourceTypeFlag = self.sourceTypeFlag;
    }
    
    [self addSelfSubViews];
}

-(void)addSelfSubViews {
    
    /// 底部scrollview
    UIScrollView *scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:YES bounces:YES pagingEnabled:NO addToSuperView:self.view];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    UIView *contentView = [UIView jh_viewWithColor:RGB(247, 247, 247) addToSuperview:scrollView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.size.mas_equalTo(CGSizeMake(ScreenW, 770));
    }];
    
    UIView *topView = nil;
    {
        /// 标题内容部分
        UIView *titleBgView = [self creatWhiteViewAddToSupView:contentView];
        [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(-15);
            make.height.mas_equalTo(98);
            make.top.equalTo(contentView).offset(10);
        }];
        topView = titleBgView;
        
        UITextField *titleTf = [self creatTextFieldWithTitle:@"标题" placeHolder:@"原石的场口、重量等" addToSupView:titleBgView maxCount:40];
        [titleTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleBgView).offset(87.f);
            make.top.equalTo(titleBgView);
            make.bottom.equalTo(titleBgView.mas_centerY);
            make.right.equalTo(titleBgView).offset(-10);
        }];
        RACChannelTo(self.paramModel, title) = RACChannelTo(titleTf, text);
        
        UITextField *descTf = [self creatTextFieldWithTitle:@"描述" placeHolder:@"原石的场口、重量等" addToSupView:titleBgView  maxCount:200];
        [descTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleTf);
            make.top.equalTo(titleBgView.mas_centerY);
            make.bottom.equalTo(titleBgView);
        }];
        RACChannelTo(self.paramModel, memo) = RACChannelTo(descTf, text);
        
        [[UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(titleBgView);
            make.height.mas_equalTo(1);
            make.left.equalTo(descTf);
        }];
    }
    
    {
        /// 重量数量部分
        UIView *titleBgView = [self creatWhiteViewAddToSupView:contentView];
        [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(-15);
            make.height.mas_equalTo(98);
            make.top.equalTo(topView.mas_bottom).offset(10);
        }];
        topView = titleBgView;
        
        UITextField *titleTf = [self creatTextFieldWithTitle:@"重量（kg）" placeHolder:@"输入数字" addToSupView:titleBgView  maxCount:6];
        titleTf.keyboardType = UIKeyboardTypeDecimalPad;
        [titleTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleBgView).offset(87.f);
            make.top.equalTo(titleBgView);
            make.bottom.equalTo(titleBgView.mas_centerY);
            make.right.equalTo(titleBgView).offset(-10);
        }];
        RACChannelTo(self.paramModel, weight) = RACChannelTo(titleTf, text);
        
        UITextField *descTf = [self creatTextFieldWithTitle:@"数量" placeHolder:@"输入数字" addToSupView:titleBgView  maxCount:6];
        descTf.keyboardType = UIKeyboardTypeNumberPad;
        [descTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(titleTf);
            make.top.equalTo(titleBgView.mas_centerY);
            make.bottom.equalTo(titleBgView);
        }];
        RACChannelTo(self.paramModel, count) = RACChannelTo(descTf, text);
        
        [[UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.right.equalTo(titleBgView);
            make.height.mas_equalTo(1);
            make.left.equalTo(descTf);
        }];
    }
    
    {
        /// 图片部分
        UIView *whiteView = [self creatWhiteViewAddToSupView:contentView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(-15);
            make.height.mas_equalTo(123);
            make.top.equalTo(topView.mas_bottom).offset(10);
        }];
        topView = whiteView;
        
        UILabel *label = [UILabel new];
        [whiteView addSubview:label];
        label.attributedText = [self getAttribusWithString:@"*图片（限制6张）"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(whiteView).offset(10);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 6.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.photosView = [[JHAddResourceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.photosView.forbidLongPress = YES;
        self.photosView.addImage = @"img_add_picture";
        @weakify(self);
        self.photosView.addPicAction = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self addAction:0];
        };
        self.photosView.didSelectedCell = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self previewPicture:indexPath];
        };
        self.photosView.deleteBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self showDeleteSheet:indexPath type:0];
        };
        [whiteView addSubview:self.photosView];
        self.photosView.itemSizeWidth = 75;
        [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(whiteView);
            make.bottom.equalTo(whiteView).offset(-15);
            make.height.mas_equalTo(75);
        }];
    }
    
    {
            /// 视频部分
        UIView *whiteView = [self creatWhiteViewAddToSupView:contentView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(-15);
            make.height.mas_equalTo(123);
            make.top.equalTo(topView.mas_bottom).offset(10);
        }];
        topView = whiteView;
            
        UILabel *label = [UILabel new];
        [whiteView addSubview:label];
        label.attributedText = [self getAttribusWithVideoString:@"视频（拍个小视频，不要违反哦）"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(whiteView).offset(10);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing = 6.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.videosView = [[JHAddResourceCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        @weakify(self);
        self.videosView.addImage = @"img_add_video";
        self.videosView.forbidLongPress = YES;
        self.videosView.addPicAction = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self addAction:1];
        };
        self.videosView.didSelectedCell = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self playVideo:indexPath];
        };
        self.videosView.deleteBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self showDeleteSheet:indexPath type:1];
        };
        
        [whiteView addSubview:self.videosView];
        self.videosView.itemSizeWidth = 75;
        [self.videosView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(whiteView);
            make.bottom.equalTo(whiteView).offset(-15);
            make.height.mas_equalTo(75);
        }];
    }
    
    {
        /// 售价部分
        UIView *whiteView = [self creatWhiteViewAddToSupView:contentView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.right.equalTo(contentView).offset(-15);
            make.height.mas_equalTo(48);
            make.top.equalTo(topView.mas_bottom).offset(10);
        }];
        topView = whiteView;
        
        UITextField *tf = [self creatTextFieldWithTitle:@"售价" placeHolder:@"输入数字" addToSupView:whiteView  maxCount:8];
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(whiteView).offset(62.f);
            make.top.bottom.equalTo(whiteView);
            make.right.equalTo(whiteView).offset(-10);
        }];
        RACChannelTo(self.paramModel, salePrice) = RACChannelTo(tf, text);
    }
    
    UIButton *publishButton = [UIButton jh_buttonWithTitle:self.stoneResaleId ? @"确定" : @"发布" fontSize:18 textColor:RGB515151 target:self action:@selector(publishAction) addToSuperView:contentView];
    [publishButton jh_cornerRadius:22];
    publishButton.backgroundColor = RGB(254, 225, 0);
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(20);
        make.left.equalTo(contentView).offset(60);
        make.right.equalTo(contentView).offset(-60);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark -------- 发布开始 start --------
/// 必传字段验证 （1）
- (void)publishAction {
    
    [self.view endEditing:YES];
    
    if (self.paramModel.title && self.paramModel.title.length <= 0) {
        [self.view makeToast:@"请输入标题" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    if (self.paramModel.memo && self.paramModel.memo.length <= 0) {
           [self.view makeToast:@"请输入描述" duration:1 position:CSToastPositionCenter];
           return;
       }
    
    if (self.allPhotos && self.allPhotos.count <= 0) {
        [self.view makeToast:@"请上传图片" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    if (self.paramModel.salePrice && self.paramModel.salePrice.floatValue <= 0) {
        [self.view makeToast:@"请输入售价" duration:1 position:CSToastPositionCenter];
        return;
    }
    
    [self upLoadVideoAndCover];
}

/// 上传图片（2）
- (void)uploadImage {
    NSMutableArray *array = [NSMutableArray array];
    for (JHPublishSourceItemModel *model in self.allPhotos) {
        if(!model.isNetwork){
            [array addObject:model.image];
        }
    }
    if(array.count <= 0){
        for (JHPublishSourceItemModel *model in self.allPhotos) {
            JHStonePersonReSellPublishMediaModel *obj = [JHStonePersonReSellPublishMediaModel new];
            obj.url = model.sourceUrl;
            obj.coverUrl = model.coverUrl;
            obj.type = 1;
            [self.paramModel.urlList addObject:obj];
        }
        [self uploadDataMethod];
        return;
    }
    
    [SVProgressHUD show];
    
    [[JHAiyunOSSManager shareInstance] uopladImage:array returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        
        dispatch_async(dispatch_get_main_queue(),  ^{
            [SVProgressHUD dismiss];
            if (isFinished && imgKeys.count) {

                int i = 0;
                for (JHPublishSourceItemModel *model in self.allPhotos) {
                    
                    JHStonePersonReSellPublishMediaModel *obj = [JHStonePersonReSellPublishMediaModel new];
                    obj.type = 1;
                    if(model.isNetwork){
                        obj.url = model.sourceUrl;
                        obj.coverUrl = model.coverUrl;
                    }
                    else{
                        obj.url = SAFE_OBJECTATINDEX(imgKeys, i);
                        obj.coverUrl = SAFE_OBJECTATINDEX(imgKeys, i);
                        i++;
                    }
                    [self.paramModel.urlList addObject:obj];
                    
                }
                [self uploadDataMethod];
            } else {
                [SVProgressHUD showErrorWithStatus:@"连接超时，请检查网络"];
                
            }
        });
    }];
}

/// 上传视频（3）
- (void)upLoadVideoAndCover {
    if(self.allVideos.count)
    {
        JHPublishSourceItemModel *model = self.allVideos[0];
        if(model.isNetwork){
            JHStonePersonReSellPublishMediaModel *obj = [JHStonePersonReSellPublishMediaModel new];
            obj.url = model.sourceUrl;
            obj.coverUrl = model.coverUrl;
            obj.type = 2;
            [self.paramModel.urlList addObject:obj];
            [self uploadImage];
            return;
            
        }
        
        [SVProgressHUD show];
        [[JHAiyunOSSManager shareInstance] uploadVideoByPath:self.allVideoPaths[0] returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isFinished) {
                    JHPublishSourceItemModel *model = self.allVideos[0];
                    [[JHAiyunOSSManager shareInstance] uopladImage:@[model.image] returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                        [SVProgressHUD dismiss];
                        if (isFinished) {
                            dispatch_async(dispatch_get_main_queue(),  ^{
                                JHStonePersonReSellPublishMediaModel *obj = [JHStonePersonReSellPublishMediaModel new];
                                obj.url = videoKey;
                                obj.coverUrl = SAFE_OBJECTATINDEX(imgKeys, 0);
                                obj.type = 2;
                                [self.paramModel.urlList addObject:obj];
                                [self uploadImage];
                                
                            });
                        }else {
                            [SVProgressHUD showErrorWithStatus:@"连接超时，请检查网络"];
                        }
                    }];
                    
                } else {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"连接超时，请检查网络"];
                }
            });
        }];
    }
    else{
        [self uploadImage];
    }
}

/// 所有字段（4）
- (void)uploadDataMethod {
    
    NSString *urlStr = FILE_BASE_STRING(@"/app/stone/resale/save");
    [HttpRequestTool postWithURL:urlStr Parameters:self.paramModel.mj_keyValues requestSerializerType:RequestSerializerTypeJson timeoutInterval:30 successBlock:^(RequestModel *respondObject) {
        
        if(respondObject.code == 1000){
            if(!self.stoneResaleId) {
                /// 转售按钮状态改变
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
            }
            if(self.editSuccessBlock) {
                self.editSuccessBlock();
            }
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"发布成功" andDesc:@"15天内未售出将自动下架，若继续出售可手动上架" cancleBtnTitle:@"确认" sureBtnTitle:@"查看详情"];
            [self.view addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:NO];
                [JHRouterManager pushPersonReSellDetailWithStoneResaleId:respondObject.data];
            };
            
            alert.cancleHandle = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            };
           
        }else{
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    [self.paramModel.urlList removeAllObjects];
}

/// 编辑数据 更新显示
- (void)updateUIMethod {
    
    [JHPublishEditModel getPublishModelWithStoneId:self.stoneResaleId completeBlock:^(JHPublishEditModel * _Nonnull model) {
        self.paramModel.title = model.goodsTitle;
        self.paramModel.memo = model.goodsDesc;
        self.paramModel.weight = model.weight;
        self.paramModel.count = model.goodsCount;
        self.paramModel.salePrice = model.salePrice;
        self.paramModel.sourceTypeFlag = model.sourceType;
        self.paramModel.sourceOrderCode = model.sourceOrderCode;
        self.paramModel.sourceOrderId = model.sourceOrderId;
        for (JHPublishEditSourceModel *obj in model.imgList) {
            JHPublishSourceItemModel *m = [JHPublishSourceItemModel new];
            m.sourceUrl = obj.url;
            m.coverUrl = obj.coverUrl;
            m.image = obj.coverUrl;
            m.isVideo = NO;
            m.isNetwork = YES;
            [self.allPhotos addObject:m];
        }
        
        for (JHPublishEditSourceModel *obj in model.videoList) {
            JHPublishSourceItemModel *m = [JHPublishSourceItemModel new];
            m.sourceUrl = obj.url;
            m.coverUrl = obj.coverUrl;
            m.image = obj.coverUrl;
            m.isVideo = YES;
            m.isNetwork = YES;
            [self.allVideos addObject:m];
        }
        [self selfReloadCollection];
    }];
}

/// 图片视频资源 reload
- (void)selfReloadCollection {
    
        self.photosView.array = (NSMutableArray <JHPhotoItemModel *> *)self.allPhotos;
        self.photosView.isShowAddCell = (self.allPhotos.count < 6);
        [self.photosView reloadData];
    
        self.videosView.array = (NSMutableArray <JHPhotoItemModel *> *)self.allVideos;
        self.videosView.isShowAddCell = (self.allVideos.count < 1);
        [self.videosView reloadData];
}

#pragma mark -------- 发布 end --------

#pragma mark -------- 资源选择 --------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    @weakify(self);
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 0) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset, NSError *error) {
            @strongify(self);
            JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
            model.image = image;
            model.isVideo = NO;
            model.asset = asset;
            [self.allPhotos addObject:model];
            [self selfReloadCollection];
        }];
    }else if (picker.view.tag == 1) {
        
        
        [SVProgressHUD show];
        
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl completion:^(PHAsset *asset, NSError *error) {
                @strongify(self);
                if (!error) {
                    [self exportVideoWithAsset:asset picker:picker cover:nil];
                }
                [SVProgressHUD dismiss];
            }];
        }
    }
}

- (JHStonePersonReSellPublishModel *)paramModel {
    if(!_paramModel){
        _paramModel = [JHStonePersonReSellPublishModel new];
    }
    return _paramModel;
}

/// 富文本属性串*
- (NSMutableAttributedString *)getAttribusWithString:(NSString *)sender {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:sender attributes: @{NSFontAttributeName:JHMediumFont(13),NSForegroundColorAttributeName:RGB153153153}];

    [attString addAttributes:@{NSForegroundColorAttributeName: RGB(255, 66, 0)} range:NSMakeRange(0, 1)];

    [attString addAttributes:@{NSForegroundColorAttributeName:RGB515151} range:NSMakeRange(1, 2)];
    
    return attString;
}
/// 富文本属性串不带*
- (NSMutableAttributedString *)getAttribusWithVideoString:(NSString *)sender {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:sender attributes: @{NSFontAttributeName:JHMediumFont(13),NSForegroundColorAttributeName:RGB153153153}];
    [attString addAttributes:@{NSForegroundColorAttributeName:RGB515151} range:NSMakeRange(0, 2)];
    
    return attString;
}

/// 便利构造器（白色圆角view）
- (UIView *)creatWhiteViewAddToSupView:(UIView *)senderView {
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:senderView];
    [whiteView jh_cornerRadius:8];
    return whiteView;
}

/// 便利构造器（带标题的 tf)
- (UITextField *)creatTextFieldWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder addToSupView:(UIView *)senderView maxCount:(NSInteger)maxCount {
    
    UITextField *tf = [UITextField jh_textFieldWithFont:13 textAlignment:0 textColor:RGB515151 placeholderText:placeHolder placeholderColor:RGB153153153 addToSupView:senderView];
    
    UILabel *label = [UILabel jh_labelWithBoldFont:13 textColor:RGB515151 addToSuperView:senderView];
    label.text = title;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(senderView).offset(10);
        make.centerY.equalTo(tf);
    }];
    
    [tf.rac_newTextChannel subscribeNext:^(NSString * _Nullable x) {
        if(x.length > maxCount)
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"不能超过%@个字符",@(maxCount)]];
            tf.text = [x substringToIndex:maxCount];
        }
    }];
    return tf;
}


#pragma mark -------- 资源选择（以下为原有的逻辑代码） --------
/// Description
/// @param type 0 图片 1视频
- (void)addAction:(NSInteger)type {
    [self.view endEditing:YES];
    NSString *title = @"";
    if (type == 0) {
        title = @"选择图片";
    }else if (type == 1){
        title = @"选择视频";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerViewWithType:type];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
          if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
              picker.navigationController.navigationBar.translucent = NO;
              picker.delegate = self;
              picker.allowsEditing = NO;
              picker.sourceType = sourceType;
              
              picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
              
              picker.view.tag = 0;
              if (type == 1) {
                  picker.mediaTypes = @[(NSString *)kUTTypeMovie];
                  picker.view.tag = 1;
                  picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
              }
              [self presentViewController:picker animated:YES completion:nil];
          }else {
              NSLog(@"模拟器");
          }
      }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showImagePickerViewWithType:(NSInteger)type {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(6 - self.allPhotos.count) delegate:self];
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    if (type == 1) {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
        
    }else if (type == 0) {
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
    } else {
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = YES;
    }
    //视频时长不超过5分钟
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.videoMaximumDuration = 7.5 * 60;
    imagePickerVc.autoDismiss = NO;
    @weakify(self);
    @weakify(imagePickerVc);
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        @strongify(imagePickerVc);
        [imagePickerVc dismissViewControllerAnimated:YES completion:nil];
    };
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        @strongify(imagePickerVc);
        if (photos) {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
                model.image = photos[idx];
                model.isVideo = NO;
                model.asset = assets[idx];
                [self.allPhotos addObject:model];
            }];
            [self selfReloadCollection];
        }
        [imagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        @strongify(self);
        @strongify(imagePickerVc);
        [self exportVideoWithAsset:asset picker:imagePickerVc cover:coverImage];
        
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showDeleteSheet:(NSIndexPath *)indexPath type:(NSInteger)type {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (type == 0) {
            [self.allPhotos removeObjectAtIndex:indexPath.row];
            [self selfReloadCollection];
        }else if (type == 1) {
            [self.allVideos removeObjectAtIndex:indexPath.row];
            [self.allVideoPaths removeObjectAtIndex:indexPath.row];
            [self selfReloadCollection];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1000);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return videoImage;
    
    
}
- (void)exportVideoWithAsset:(PHAsset *)asset picker:(UINavigationController *)weakImagePickerVc cover:(UIImage *)coverImage {
    [SVProgressHUD showWithStatus:@"正在导出视频"];
    @weakify(self);
    @weakify(weakImagePickerVc);
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        @strongify(self);
        @strongify(weakImagePickerVc);
        NSLog(@"%@",outputPath);
        [SVProgressHUD dismiss];
            
        UIImage *image = coverImage;
        if (!image) {
            image = [self firstFrameWithVideoURL:[NSURL fileURLWithPath:outputPath] size:CGSizeZero];
        }
        JHPublishSourceItemModel *model = [JHPublishSourceItemModel new];
        model.image = image;
        model.isVideo = YES;
        model.asset = asset;
        [self.allVideos addObject:model];
        [self.allVideoPaths addObject:outputPath];
        [self selfReloadCollection];
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSString *errorMessage, NSError *error) {
          dispatch_async(dispatch_get_main_queue(),  ^{
              @strongify(weakImagePickerVc);
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
          });
    }];
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
             
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

             }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoLibiry];
                });
            }
        }];
    } else {
        [self takePhotoLibiry];
    }
}

- (void)takePhotoLibiry {
    [[TZImageManager manager] requestAuthorizationWithCompletion:^{
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
           if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusNotDetermined)) {
                       
                       NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
                       // 无权限 做一个友好的提示
                       NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
                       if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
                       
                       NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Allow %@ to access your album in \"Settings -> Privacy -> Photos\""],appName];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:message preferredStyle:UIAlertControllerStyleAlert];
                      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
                           
                      [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                          
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

                           }]];
                      [self presentViewController:alert animated:YES completion:nil];
           }
    }];
}

- (void)playVideo:(NSIndexPath *)indexPath {
    
    JHPublishSourceItemModel *model = SAFE_OBJECTATINDEX(self.allVideos, 0);
    if(model.isNetwork){
        NSURL *url = [NSURL URLWithString:model.sourceUrl];
        AVPlayerViewController *ctrl = [AVPlayerViewController new];
        ctrl.player= [[AVPlayer alloc]initWithURL:url];
        [self presentViewController:ctrl animated:YES completion:nil];
        return;
    }
    TZVideoPlayerController *videoPlayerVc = [[TZVideoPlayerController alloc] init];
    videoPlayerVc.model = [TZAssetModel modelWithAsset:[self.allVideos objectAtIndex:indexPath.row].asset type:TZAssetModelMediaTypeVideo];
    [self.navigationController pushViewController:videoPlayerVc animated:YES];
}

- (void)previewPicture:(NSIndexPath *)indexPath {

    NSMutableArray *photoList = [NSMutableArray new];
    for (JHPublishSourceItemModel *model in self.allPhotos) {
        GKPhoto *photo = [GKPhoto new];
        if(model.isNetwork){
            photo.url = [NSURL URLWithString:model.image];
        }
        else{
            photo.image = model.image;
        }
        
        [photoList addObject:photo];
    }
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:(NSInteger)indexPath.item];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self];
}

@end
