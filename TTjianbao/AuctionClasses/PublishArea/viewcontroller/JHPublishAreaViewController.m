//
//  JHPublishAreaViewController.m
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "UIView+UIHelp.h"
#import "JHPublishAreaViewController.h"
#import "TZImagePickerController.h"
#import "JHPhotoCollectionView.h"
#import "JHCateViewController.h"
#import "JHPhotoCollectionViewCell.h"
#import "JHShowOpenPushAlertView.h"
#import "JHLikeImageView.h"
#import "JHAiyunOSSManager.h"
#import "JHTopicSelectListController.h"
#import "CTopicModel.h"
#import "GrowingManager.h"
#import "TTjianbaoHeader.h"
#import "UITextField+PlaceHolderColor.h"
#import "JHUploadManager.h"

#import "JHPublishBottomView.h"
#import <IQKeyboardManager.h>
@interface JHPublishAreaViewController ()<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate> {
    CGFloat maxCount;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) JHPublishBottomView *publishBottomView;

@property (weak, nonatomic) IBOutlet UIButton *waringBt;

//图片
@property (weak, nonatomic) IBOutlet JHPhotoCollectionView *photosView;
@property (weak, nonatomic) IBOutlet UIView *tiptoastView;

///标题
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UILabel *titleCountLabel;

///描述
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *descPlaceHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *descCountLabel;

//话题
@property (weak, nonatomic) IBOutlet UIButton *topicBtn;

///品类
@property (weak, nonatomic) IBOutlet UIButton *cateBtn;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;

@property (nonatomic, strong) NSDictionary *selectedCate;

///保存需要上传的帖子的参数
@property (nonatomic, strong) NSMutableDictionary *uploadDataDictioary;

/// 已经选择的图片
@property (nonatomic, strong) NSMutableArray <JHPhotoItemModel*>*allPhotos;
 
/// 已经上传到阿里云的图片key
@property (nonatomic, strong) NSMutableArray *imgeURLs;

/// 已经选择视频的路径
@property (nonatomic, strong) NSString *videoPath;

/// 已经上传到阿里云的视频key
@property (nonatomic, strong) NSString *videoBucketKey;

@end

@implementation JHPublishAreaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkInfo];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    maxCount = 1000;
    
    [self makeUI];
    
    [self updateUIConditionally];
    [JHAiyunOSSManager shareInstance];
}

- (void)makeUI {
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self initToolsBar];
    
    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"login_close"] withHImage:[UIImage imageNamed:@"login_close"]  withFrame:CGRectMake(0,0,44,44)];
    [self.navbar.comBtn addTarget :self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navbar addrightBtn:@"发布" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-83,0,63,26)];
    self.navbar.rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.navbar.rightBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.navbar.rightBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateDisabled];
    self.navbar.rightBtn.layer.cornerRadius = 13;
    self.navbar.rightBtn.layer.masksToBounds = YES;
    [self.navbar.rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_publish_gray"] forState:UIControlStateNormal];
    [self.navbar.rightBtn setBackgroundImage:[UIImage imageNamed:@"bg_publish_yellow"] forState:UIControlStateSelected];
    [self.navbar.rightBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel jh_labelWithBoldText:@"发帖" font:17 textColor:UIColor.blackColor textAlignment:1 addToSuperView:self.navbar];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navbar.rightBtn);
        make.centerX.equalTo(self.navbar);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(JHNaviBarHeight, 0, 0, 0));
    }];
    
    NSString *message = self.isOpenAppraise ? @"请至少上传3张图片或1个视频" : @"分享清晰视频或图片，获得更多点赞";
                
    [_waringBt setTitle:message forState:UIControlStateNormal];
    
    @weakify(self);
    self.photosView.addPicAction = ^(NSIndexPath *indexPath) {
        @strongify(self);
        [self.view endEditing:YES];
        [self addPhotos:nil];
    };
    self.photosView.didSelectedCell = ^(NSIndexPath *indexPath) {
        @strongify(self);
        [self.view endEditing:YES];
        [self showDeleteSheet:indexPath];
    };
    
    //设置标题
    [self.titleText placeHolderColor:HEXCOLOR(0x999999)];
    self.titleText.tintColor = kGlobalThemeColor;
    
    //设置描述
    self.textView.delegate = self;
    self.textView.tintColor = kGlobalThemeColor;
    
    //品类、话题按钮 图文间距调整
    [_cateBtn setImageInsetStyle:MRImageInsetStyleLeft spacing:10.0];
    [_topicBtn setImageInsetStyle:MRImageInsetStyleLeft spacing:10.0];
    
    
    [self.topicBtn setImage:[UIImage imageNamed:@"publish_topic_selected"] forState:UIControlStateSelected];
    [self.topicBtn setTitleColor:RGB(64, 143, 254) forState:UIControlStateSelected];
    
    [self.topicBtn setImage:[UIImage imageNamed:@"publish_topic_normal"] forState:UIControlStateNormal];
    [self.topicBtn setTitleColor:RGB515151 forState:UIControlStateNormal];
    
    JHPublishBottomView *publishBottomView = [JHPublishBottomView new];
    [self.scrollView addSubview:publishBottomView];
    [publishBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsMake(426, 0, 0, 0));
        make.width.mas_equalTo(ScreenW);
    }];
    _publishBottomView = publishBottomView;
    [self bindMethod];
}

-(void)bindMethod {
    
    @weakify(self);
    [RACObserve(self.publishBottomView, canPublish) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self checkInfo];
        NSLog(@"😁😁😁😁😁😁😁😁😁😁%@",self.publishBottomView.model.mj_keyValues);
    }];
}

#pragma mark- textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location >= maxCount)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.descCountLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)textView.text.length, (long)maxCount];

    self.descCountLabel.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.descCountLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= 0) {
        self.descPlaceHolderLabel.hidden = NO;
        self.descCountLabel.text = [NSString stringWithFormat:@"0/%ld", (long)maxCount];
        
    }else if (textView.text.length <= maxCount){
        self.descPlaceHolderLabel.hidden = YES;
        self.descCountLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)textView.text.length, (long)maxCount];
    }else {
        self.descPlaceHolderLabel.hidden = YES;
        textView.text = [textView.text substringWithRange:NSMakeRange(0, maxCount)];
        self.descCountLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)textView.text.length, (long)maxCount];
    }
    [self checkInfo];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //标题
    if (textField == self.titleText) {
        [textField resignFirstResponder];
        return NO;
    } else {
    //价格
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //标题
    if (textField == self.titleText) {
        [self checkInfo];
        self.titleCountLabel.hidden = YES;
    } else {
    //价格
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //标题
    if (textField == self.titleText) {
        self.titleCountLabel.text = [NSString stringWithFormat:@"%d/20", (int)textField.text.length];
        self.titleCountLabel.hidden = NO;
    } else {
    //价格
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //标题
    if (textField == self.titleText) {
        if (range.location >= 20) {
            [self.view makeToast:@"标题最多输入20个字哦" duration:1. position:CSToastPositionCenter];
            return NO;
        } else {
            return YES;
        }
        
    } else {
    //价格
        if ([result length] == 0) {
            return YES;
        }else {
            NSString *regex = @"^0*";
            NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isZeroStart = [prd evaluateWithObject:result];
            if (isZeroStart) {
                return NO;
            } else {
                if (result.length > 9) {
                    [self.view makeToast:@"您输入的金额太大啦" duration:1. position:CSToastPositionCenter];
                    return NO;
                } else {
                    return YES;
                }
            }
        }
        
    }
    
}

- (IBAction)titleFiledDidChanged:(id)sender {
    NSLog(@"%@", self.titleText.text);
    int length = (int)self.titleText.text.length;
    if (length>20) {
        self.titleText.text = [self.titleText.text substringWithRange:NSMakeRange(0, 20)];
        [self.view makeToast:@"标题最多输入20个字哦" duration:1. position:CSToastPositionCenter];
    }
    self.titleCountLabel.text = [NSString stringWithFormat:@"%d/20", length];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString: @"JHPhotoCollectionViewCell"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString: @"UIButton"]) {
        return NO;
    }
    return YES;
}

#pragma mark- action
- (void)back{
    [self.view endEditing:YES];
    
    if (self.allPhotos.count || self.titleText.text.length>0 || self.textView.text.length>0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消发布？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)submitAction:(UIButton *)btn {
    [self.view endEditing:YES];
    
    if ([UserInfoRequestManager sharedInstance].levelModel.forbid_speak == 0) {
        //您的账号因违规被禁言
        [self.view makeToast:@"您的账号因违规被禁言" duration:3.0 position:CSToastPositionCenter];
        return;
    }

    NSString *message = nil;
    if (!self.videoPath) {
        if(self.isOpenAppraise){
            if(self.allPhotos.count< 3) {
                message = @"鉴定贴需选择视频或至少3张图片";
            }
        }
        else{
            if (self.allPhotos.count < 1) {
                message = @"请选择晒宝的视频或图片";
            }
        }
    }
    
    if (message.length == 0) {
        if (self.titleText.text.length==0 && self.textView.text.length==0) {
            message = @"标题不可为空";
        }
    }
    
    if (message.length == 0) {
        if (self.kindLabel.text.length == 0) {
            message = @"请选择发布内容的品类";
        }
    }
    
    if (!self.publishBottomView.canPublish && self.publishBottomView.model.item_type != 0){
    
        message = (self.publishBottomView.model.item_type == 8 ? @"请完善投票信息" : @"请完善猜价信息");
    }
    
    if (message.length) {
        [self.view makeToast:message duration:1 position:CSToastPositionCenter];
        return;
    }
    
    [self uploadMedia];
    
    //埋点：发布帖子
    [GrowingManager homePublishArticle:[self growingParams]];
}

- (NSDictionary *)growingParams {
    JHUserTypeRole userType = [UserInfoRequestManager sharedInstance].user.type;
    NSInteger resourceType = [self.videoPath isNotBlank] ? 2 : 1;
    
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSDictionary *params = @{@"userId" : userId ? userId : @"",
                             @"time" : @([[YDHelper get13TimeStamp] longLongValue]),
                             @"from" : [_from isNotBlank] ? _from : JHFromUndefined,
                             @"publish_type" : _isOpenAppraise ? @(2) : @(1),
                             @"publish_type_str" : _isOpenAppraise ? @"求鉴定" : @"晒宝",
                             @"user_type" : @(userType),
                             @"resource_type" : @(resourceType),
                             @"topic_name" : _topicTitle ? _topicTitle : @"",
                             @"channel_id" : _selectedCate[@"channel_id"],
                             @"channel_name" : _kindLabel.text
    };
    return params;
}

- (NSString *)noteMessage{
    NSString *message = @"分享清晰视频或图片，获得更多点赞";
    if(self.isOpenAppraise){
        message = @"请至少上传3张图片或1个视频";
    }
    return message;
}

- (IBAction)topicBtnClicked:(id)sender {
    NSLog(@"选择话题");
    @weakify(self);
    [JHTopicSelectListController showFromVC:self defaultData:nil doneBlock:^(CTopicData * _Nullable data) {
        @strongify(self);
        [self updateTopicData:data];
    }];
}

- (IBAction)selecteKindAction:(id)sender {
    [self.view endEditing:YES];
    JHCateViewController *vc = [[JHCateViewController alloc] init];
    MJWeakSelf
    vc.seletedFinish = ^(NSString * _Nonnull channelID, NSString * _Nonnull cateID, NSString * _Nonnull subCateID,NSString *_Nonnull selString) {
        weakSelf.selectedCate = @{@"channel_id":channelID?@([channelID integerValue]):@"",
                                  @"cate_id":cateID?@([cateID integerValue]):@"",
                                  @"sub_cate_id":subCateID?@([subCateID integerValue]):@""};
        weakSelf.kindLabel.text = selString;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)helpAction:(id)sender {
    [self.view endEditing:YES];
    JHShowOpenPushAlertView *alert = [JHShowOpenPushAlertView shareInstance] ;
    alert.frame = self.view.bounds;
    [self.view addSubview:alert];
    [alert showAlertTitle:@"什么是求鉴定" content:@"天天鉴宝提供免费的鉴定服务，清晰拍摄并发布宝贝，将有专业鉴定师为您免费鉴定" btnTitle:@"我知道了" action:^(id sender) {
        
    }];
}

- (BOOL)checkInfo {
    BOOL isCan = NO;
    if (self.videoPath) {
        isCan = YES;
    } else {
        
        if(self.isOpenAppraise){
            isCan = self.allPhotos.count >= 3 ? YES : NO;
        }
        else{
            isCan = self.allPhotos.count >=1 ? YES : NO;
        }
    }
    
    if (isCan) {
        isCan = [self.titleText hasText] || [self.textView hasText];
    }
    
    if (isCan) {
        isCan = self.kindLabel.text.length > 0 ? YES: NO;
    }
    
    isCan = (isCan && (self.publishBottomView.canPublish || self.publishBottomView.model.item_type == 0));
    
    if (isCan) {
        self.navbar.rightBtn.selected = YES;
    }else {
        self.navbar.rightBtn.selected = NO;
    }
    return isCan;
}

- (BOOL)showFirstToast {
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:@"showFirstToastTip"];
    if (!b) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showFirstToastTip"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !b;
}

- (BOOL)showFirstTuo {
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:@"showFirstDrag"];
    if (!b) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showFirstDrag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !b;
}

- (NSDictionary *)parameters {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.videoPath) {
        dic[@"resource_type"] = @(2);
        dic[@"video_url"] = self.videoBucketKey;
    } else {
        dic[@"resource_type"] = @(1);
    }
    dic[@"images"] = self.imgeURLs;
    NSMutableDictionary *cover = [NSMutableDictionary dictionary];
    cover[@"url"] = self.imgeURLs.firstObject;
    UIImage *image = self.allPhotos.firstObject.image;
    
    cover[@"width"] = @(image.size.width);
    cover[@"height"] = @(image.size.height);
    dic[@"cover_info"] = cover;
    
    dic[@"content"] = self.textView.text;
    dic[@"title"] = self.titleText.text;
    
    [dic addEntriesFromDictionary:self.selectedCate];
    
    dic[@"is_need_appraise"] = @(self.isOpenAppraise?1:0);
    
    //dic[@"is_product"] = @(0);
    
    if ([_topicTitle isNotBlank]) {
        dic[@"topic"] = self.topicTitle;
    }
    
    JHPublishBottomModel *model = self.publishBottomView.model;
    [dic setValue:@(model.item_type) forKey:@"item_type"];
    if(model.item_type == 8){
        [dic setValue:model.vote.mj_keyValues forKey:@"vote"];
    }
    if(model.item_type == 10){
        [dic setValue:[model.guess getParams] forKey:@"guess"];
    }
    
    return dic.copy;
}

#pragma mark- initUI
- (void)updateUIConditionally {
    //求鉴定
    if (self.isOpenAppraise) {
        _topicTitle = @"求鉴定";
        self.descPlaceHolderLabel.text = @"为了得到准确、详尽的鉴定服务，请多多描述您的宝贝吧";
    } else {//晒宝贝
        self.descPlaceHolderLabel.text = @"说点什么…";
        if ([UserInfoRequestManager sharedInstance].user.type == 4 || [UserInfoRequestManager sharedInstance].user.type == 6) {
            
        }
    }

    //设置话题
    if ([_topicTitle isNotBlank]) {
        CTopicData *data = [[CTopicData alloc] init];
        data.title = _topicTitle;
        [self updateTopicData:data];
    }
    
    //图品提示
    self.tiptoastView.hidden = YES;
    if (self.isOpenAppraise && [self showFirstToast]) {
        [self.tiptoastView.superview bringSubviewToFront:self.tiptoastView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tiptoastView.hidden = NO;
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tiptoastView.hidden = YES;
        });
    }
}

- (void)updateTopicData:(nullable CTopicData *)data {
    if (data) {
        
        [self.topicBtn setTitle:data.title forState:UIControlStateNormal];
        self.topicBtn.selected = YES;
        //埋点
        [Growing track:@"topicselectsucess"];
        
    } else {
        [self.topicBtn setTitle:@"选择话题" forState:UIControlStateNormal];
        self.topicBtn.selected = NO;
    }
    self.topicTitle = (data != nil ? data.title : @"");
}

#pragma mark --------------- 图片选择 + 上传 ---------------
- (void)makePhotoView {
    if (self.allPhotos.count>=2 && [self showFirstTuo]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            JHLikeImageView *image = [[JHLikeImageView alloc] initDragWithFrame:CGRectZero];
            [self.view addSubview:image];
            [image beginAnimationDuring:6];
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.equalTo(self.photosView);
                make.width.equalTo(@((ScreenW-30)/2.));
            }];
            
        });
    }
    self.photosView.array = self.allPhotos;
    [self.photosView reloadData];
    
    if (self.videoPath) {
        self.photosView.isShowAddCell = NO;
    } else {
        self.photosView.isShowAddCell = self.allPhotos.count >= 6 ? NO : YES;
        
        //滚动到最后一个item
        NSInteger index = self.allPhotos.count >= 6 ? 5 : self.allPhotos.count;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.photosView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
    //修改完图片数据之后再检查发布按钮是否可用
    [self checkInfo];
}

#pragma mark imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(PHAsset *asset, NSError *error){
        //已在主线程
        if (!error) {
            JHPhotoItemModel *model = [JHPhotoItemModel new];
            model.image = image;
            model.isVideo = NO;
            model.asset = asset;
            [self.allPhotos addObject:model];
            [self makePhotoView];
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)uploadMedia{
    JHUploadManager *manager = [JHUploadManager shareInstance];
    JHArticleItemModel *model = [[JHArticleItemModel alloc] init];
    model.uploadStatus = JHArticleUploadStatusWaitUpload;
    model.uploadParameters = [self parameters];  ///需要上传的参数
    model.isOn = YES;
    if (self.videoPath) {///视频
        model.uploadMediaType = JHArticleMediaTypeVideo;
        model.videoPath = self.videoPath;
        model.uploadImageData = [[NSMutableArray alloc] initWithArray:@[[self.allPhotos firstObject].image] copyItems:YES];
    }
    else if (self.allPhotos.count) {///图片
        model.uploadMediaType = JHArticleMediaTypeImages;
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:self.allPhotos.count];
        [self.allPhotos enumerateObjectsUsingBlock:^(JHPhotoItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArray addObject:obj.image];
        }];
        //将图片数据存储在数组中
//        [model.uploadImageData addObjectsFromArray:imageArray];
        model.uploadImageData = [[NSMutableArray alloc] initWithArray:imageArray copyItems:YES];
    }
    else {
        [self.view makeToast:@"请选择图片或视频" duration:1 position:CSToastPositionCenter];
           return;
    }
    
    ///将需要上传的帖子参数存储在单例中
    [manager.articleArray addObject:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         ///选中首页的关注界面
        [JHRootController setTabBarSelectedIndex:0];
#warning -- 将需上传的数据传到网络请求的位置 >>>>
        [[NSNotificationCenter defaultCenter] postNotificationName:sendUploadDatasIdentifer object:model];
        [self dismissViewControllerAnimated:YES completion:^{
            [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
        }];
    });
}

- (void)addPhotos:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerView];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.navigationController.navigationBar.translucent = NO;
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            NSLog(@"模拟器");
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showImagePickerView {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6-self.allPhotos.count delegate:self];
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    if (self.videoPath) {
        imagePickerVc.currSelectedMediaType = TZAssetModelMediaTypeVideo;
    } else if (self.allPhotos.count){
        imagePickerVc.currSelectedMediaType = TZAssetModelMediaTypePhoto;
    } else {
        imagePickerVc.currSelectedMediaType = TZAssetModelMediaTypeUnKnow;
    }
    //视频时长不超过5分钟
    imagePickerVc.videoMaximumDuration = 5 * 60;
    imagePickerVc.videoMinimumDuration = 3;
    imagePickerVc.autoDismiss = NO;
    MJWeakSelf
    __weak TZImagePickerController* weakImagePickerVc = imagePickerVc;
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    };
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos) {
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHPhotoItemModel *model = [JHPhotoItemModel new];
                model.image = photos[idx];
                model.isVideo = NO;
                model.asset = assets[idx];
                [self.allPhotos addObject:model];
            }];
            self.videoPath = nil;
            [weakSelf makePhotoView];
        }
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        [SVProgressHUD showWithStatus:@"正在导出视频"];
        [[TZImageManager manager]getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
            NSLog(@"%@",outputPath);
            [SVProgressHUD dismiss];
            unsigned long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:outputPath error:nil].fileSize;
            if (fileSize > 50 * 1024 * 1024) {
                [self.view makeToast:@"视频大小不得超过50M" duration:1 position:CSToastPositionCenter];
            } else {
                [self.allPhotos removeAllObjects];
                JHPhotoItemModel *model = [JHPhotoItemModel new];
                model.image = coverImage;
                model.isVideo = YES;
                model.asset = asset;
                [self.allPhotos addObject:model];
                self.videoPath = outputPath;
                [weakSelf makePhotoView];
            }
            [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *errorMessage, NSError *error) {
            [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD dismiss];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
        }];
    };
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showDeleteSheet:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.videoPath) {
            TZImagePickerController *videoPicker = [[TZImagePickerController alloc]initWithVideoAsset:[self.allPhotos firstObject].asset];
            [self presentViewController:videoPicker animated:YES completion:nil];

        } else {
            NSMutableArray *imgAsset = [NSMutableArray arrayWithCapacity:self.allPhotos.count];
            [self.allPhotos enumerateObjectsUsingBlock:^(JHPhotoItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [imgAsset addObject:obj.asset];
            }];
            TZImagePickerController *perviewNav = [[TZImagePickerController alloc]initWithSelectedAssets:imgAsset selectedPhotos:imgAsset  index:indexPath.row];
            [self presentViewController:perviewNav animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.videoPath) {
            self.videoPath = nil;
        }
        [self.allPhotos removeObjectAtIndex:indexPath.row];
        [self makePhotoView];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark --------------- get ---------------
- (NSMutableDictionary *)uploadDataDictioary {
    if (!_uploadDataDictioary) {
        _uploadDataDictioary = [NSMutableDictionary dictionary];
    }
    return _uploadDataDictioary;
}

- (NSMutableArray *)allPhotos {
    if (!_allPhotos) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}


#pragma mark ---- 投票猜价(上面是删减，下面是新功能) ----
@end
