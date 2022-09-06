//
//  JHAnchorEditInfoController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorEditInfoController.h"
#import "JHLiveRoomInfoModel.h"
#import "JHUploadManager.h"
#import "UIButton+JHWebImage.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "YYKit/YYKit.h"
#import "JHAnchorLiveRoomUserAuthView.h"
#import <MBProgressHUD.h>
#define maxTextFieldCount  10
#define maxTextviewCount  50
#define maxLiveRoomTextviewCount  300

@interface JHAnchorEditInfoController () <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) NSString* selectedImgKey; //注意:只有从相册或相机选择才会赋值
@property (nonatomic, strong) UIButton* addImgBtn;
@property (nonatomic, strong) UITextField* nameTextField;
@property (nonatomic, strong) UITextView* introductionTextview;

@property (nonatomic, weak) UIScrollView *scrollView;

/// 0-头像    1-身份证人像  2-身份证国徽
@property (nonatomic, assign) NSInteger selectPhotoType;

///身份证人像
@property (nonatomic, weak) JHAnchorLiveRoomUserAuthView *authView1;
@property (nonatomic, copy) NSString *authUrl1;
@property (nonatomic, strong) UIImage *authImage1;

///身份证国徽
@property (nonatomic, weak) JHAnchorLiveRoomUserAuthView *authView2;
@property (nonatomic, copy) NSString *authUrl2;
@property (nonatomic, strong) UIImage *authImage2;

///禁止编辑
@property (nonatomic, assign) BOOL forbiddenEdit;


@end

@implementation JHAnchorEditInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawNavView];
    
    if(self.anchorRoomInfo.pageType != JHArchorSectionTypeLiveRoom && _anchorRoomInfo.broadId) {
        NSString *url = FILE_BASE_STRING(@"/app/opt/channel/dummy-anchor/detail");
        
        [HttpRequestTool postWithURL:url Parameters:@{@"broadId" : _anchorRoomInfo.broadId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            JHAnchorInfo *info= [JHAnchorInfo mj_objectWithKeyValues:respondObject.data];
            _anchorRoomInfo.idCardBackImg = info.idCardBackImg;
            _anchorRoomInfo.idCardFrontImg = info.idCardFrontImg;
            _anchorRoomInfo.authState = info.authState;
            _anchorRoomInfo.rejectReason = info.rejectReason;
            _forbiddenEdit = (info.authState == 0);
            [self addselfUI];
            
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            JHTOAST(respondObject.message);
        }];
    }
    else {
        ///服务端默认是-1
        self.anchorRoomInfo.authState = -1;
        [self addselfUI];
    }
    
}

- (void)addselfUI {
    
    [self drawContentView];
    
    if(self.anchorRoomInfo.pageType != JHArchorSectionTypeLiveRoom && _anchorRoomInfo.broadId && self.anchorRoomInfo.authState == 0)
    {
        self.jhRightButton.hidden = YES;
    }
    
    self.authUrl1 = @"";
    self.authUrl2 = @"";
    
    if(_anchorRoomInfo && _anchorRoomInfo.idCardFrontImg) {
        self.authUrl1 = _anchorRoomInfo.idCardFrontImg;
    }
    
    if(_anchorRoomInfo && _anchorRoomInfo.idCardBackImg) {
        self.authUrl2 = _anchorRoomInfo.idCardBackImg;
    }
    
}

- (void)drawNavView
{
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom) {
        self.jhTitleLabel.text=@"直播间介绍";
    }
    else {
        self.jhTitleLabel.text=@"主播介绍";
    }
    
    [self initRightButtonWithName:@"完成添加" action:@selector(rightActionButton:)];
    self.jhRightButton.titleLabel.font = JHFont(13);
    [self.jhRightButton setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    [self.jhRightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jhNavView).offset(-10);
        make.bottom.equalTo(self.jhNavView);
        make.size.mas_equalTo(CGSizeMake(70, UI.navBarHeight));
    }];
}

- (JHAnchorRoomInfo *)anchorRoomInfo
{
    if(!_anchorRoomInfo)
    {
        _anchorRoomInfo = [JHAnchorRoomInfo new];
    }
    return _anchorRoomInfo;
}

- (void)drawContentView
{
    CGFloat top = 0.0;
    CGFloat height = ScreenH;
    if(self.anchorRoomInfo.pageType != JHArchorSectionTypeLiveRoom && _anchorRoomInfo.broadId) {
        top = 45.0;
        
        height = 600;
        
        NSString *tip = @"主播信息审核中…";
        UIColor *bgColor = RGB(255, 247, 232);
        UIColor *textColor = RGB(255, 123, 0);
        if(self.anchorRoomInfo.authState == 1) {
            tip = @"审核通过：若重新上传身份证照片需重新审核";
        }
        else if(self.anchorRoomInfo.authState == 2) {
            tip = [NSString stringWithFormat:@"审核未通过：%@",_anchorRoomInfo.rejectReason];
            bgColor = RGB(255, 240, 237);
            textColor = RGB(240, 61, 55);
        }
        
        UIView *view = [UIView jh_viewWithColor:bgColor addToSuperview:self.view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.jhNavView.mas_bottom).offset(0);
            make.height.mas_equalTo(45);
        }];
        
        UILabel *label = [UILabel jh_labelWithText:tip font:12 textColor:textColor textAlignment:0 addToSuperView:view];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(12);
            make.centerY.equalTo(view);
        }];
    }
    
    _scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:NO bounces:YES pagingEnabled:NO addToSuperView:self.view];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(top);
    }] ;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIView *contentView = [UIView jh_viewWithColor:HEXCOLOR(0xF5F6FA) addToSuperview:_scrollView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(ScreenW, height));
    }];
    
    //头像
    UIView* avatarView = [self makeContentBackgroundView];
    [contentView addSubview:avatarView];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView).offset(12);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.height.mas_equalTo(69);
    }];
    UILabel* avatarLabel = [self makeCommonLabel];
    avatarLabel.text = @"主播头像";
    [avatarView addSubview:avatarLabel];
    [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView).offset(10);
        make.centerY.equalTo(avatarView).offset(0);
        make.height.mas_equalTo(18);
    }];
    [self.addImgBtn jhSetImageWithURL:[NSURL URLWithString:_anchorRoomInfo.avatar ? : @""] forState:UIControlStateNormal];
    [avatarView addSubview:self.addImgBtn];
    [self.addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(avatarView).offset(0);
        make.right.equalTo(avatarView).offset(-10);
        make.size.mas_equalTo(48);
    }];
    
    //名称
    UIView* nameView = [self makeContentBackgroundView];
    [contentView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarView.mas_bottom).offset(10);
        make.left.right.equalTo(avatarView).offset(0);
        make.height.mas_equalTo(48);
    }];
    UILabel* nameLabel = [self makeCommonLabel];
    nameLabel.text = @"主播名称";
    [nameView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView).offset(10);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(52, 18));
    }];
    self.nameTextField.text = _anchorRoomInfo.nick;
    self.nameTextField.enabled = !_forbiddenEdit;
    [nameView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(10);
        make.centerY.equalTo(nameView);
        make.right.equalTo(nameView).offset(-10);
        make.height.mas_equalTo(18);
    }];
    
    //介绍
    UIView* introductionView = [self makeContentBackgroundView];
    [contentView addSubview:introductionView];
    [introductionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameView.mas_bottom).offset(10);
        make.left.right.equalTo(avatarView).offset(0);
        make.height.mas_equalTo(138);
    }];
    UILabel* introductionLabel = [self makeCommonLabel];
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
        introductionLabel.text = @"直播间介绍";
    else
        introductionLabel.text = @"主播介绍";
    [introductionView addSubview:introductionLabel];
    [introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introductionView).offset(10);
        make.top.equalTo(introductionView).offset(9);
        make.height.mas_equalTo(18);
    }];
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
        self.introductionTextview.text = _anchorRoomInfo.roomDes;
    else
        self.introductionTextview.text = _anchorRoomInfo.des;
    [introductionView addSubview:self.introductionTextview];
    self.introductionTextview.editable = !_forbiddenEdit;
    [self.introductionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(introductionLabel.mas_bottom).offset(6);
        make.left.equalTo(introductionView).offset(8);
        make.right.equalTo(introductionView).offset(-10);
        make.bottom.equalTo(introductionView).offset(-9);
    }];
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
    {
        [avatarView setHidden:YES];
        [nameView setHidden:YES];
        [introductionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.jhNavView.mas_bottom).offset(12);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.height.mas_equalTo(138);
         }];
    }
    else {
        
        BOOL recommit = !(_anchorRoomInfo && _anchorRoomInfo.broadId && self.anchorRoomInfo.authState == 0);
        /// 身份证正面
        JHAnchorLiveRoomUserAuthView *view1 = [JHAnchorLiveRoomUserAuthView new];
        [contentView addSubview:view1];
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(introductionView.mas_bottom);
            make.height.mas_equalTo([JHAnchorLiveRoomUserAuthView viewHeight]);
        }];
        view1.type = 0;
        view1.reCommit = recommit;
        @weakify(self);
        view1.clickBlock = ^{
            @strongify(self);
            if(!self.forbiddenEdit) {
                self.selectPhotoType = 1;
                [self addImageAction];
            }
            
        };
        _authView1 = view1;
        
        /// 身份证反面
        JHAnchorLiveRoomUserAuthView *view2 = [JHAnchorLiveRoomUserAuthView new];
        [contentView addSubview:view2];
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(view1);
            make.top.equalTo(view1.mas_bottom);
        }];
        view2.type = 1;
        view2.reCommit = recommit;
        view2.clickBlock = ^{
            @strongify(self);
            if(!self.forbiddenEdit) {
                self.selectPhotoType = 2;
                [self addImageAction];
            }
        };
        _authView2 = view2;
        
        if(_anchorRoomInfo.idCardBackImg) {
            self.authUrl1 = _anchorRoomInfo.idCardFrontImg;
            self.authUrl2 = _anchorRoomInfo.idCardBackImg;
            view1.uploadImage = _anchorRoomInfo.idCardFrontImg;
            view2.uploadImage = _anchorRoomInfo.idCardBackImg;
        }
        
        UILabel *tipLabel = [UILabel jh_labelWithText:@"天天鉴宝不会通过任何渠道泄漏您的个人信息请放心上传" font:12 textColor:RGB153153153 textAlignment:1 addToSuperView:contentView];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom).offset(15);
            make.centerX.equalTo(contentView);
        }];
    }
}

- (UIButton *)addImgBtn
{
    if (!_addImgBtn) {
        _addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"anchorInfoAvatar"] forState:UIControlStateNormal];
        _addImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _addImgBtn.layer.cornerRadius = 24;
        _addImgBtn.layer.masksToBounds = YES;
        [_addImgBtn addTarget:self action:@selector(addAvatorImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgBtn;
}

- (UITextField *)nameTextField
{
    if(!_nameTextField)
    {
        _nameTextField = [UITextField new];
        _nameTextField.backgroundColor = HEXCOLOR(0xFFFFFF);
        _nameTextField.font = JHFont(13);
        _nameTextField.textColor = HEXCOLOR(0x333333);
        _nameTextField.placeholder = @"主播名称，10字以内";
        _nameTextField.delegate = self;
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTextField;
}

- (UITextView *)introductionTextview
{
    if(!_introductionTextview)
    {
        _introductionTextview = [[UITextView alloc] init];
        _introductionTextview.backgroundColor = HEXCOLOR(0xFFFFFF);
        _introductionTextview.font = JHFont(13);
        _introductionTextview.delegate = self;
        _introductionTextview.autocorrectionType = UITextAutocorrectionTypeYes;
        _introductionTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _introductionTextview.keyboardType = UIKeyboardTypeDefault;
        _introductionTextview.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
            placeHolderLabel.text = @"直播间介绍，300字以内";
        else
            placeHolderLabel.text = @"主播介绍，50字以内";
        placeHolderLabel.numberOfLines = 1;
        placeHolderLabel.textColor = HEXCOLOR(0x999999);
        [placeHolderLabel sizeToFit];
        placeHolderLabel.font = JHFont(13);
        [_introductionTextview addSubview:placeHolderLabel];
        [_introductionTextview setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _introductionTextview;
}

- (UIView *)makeContentBackgroundView
{
    UIView* contentBgView = [UIView new];
    contentBgView.backgroundColor = HEXCOLOR(0xFFFFFF);
    contentBgView.layer.cornerRadius = 8;
    contentBgView.layer.masksToBounds = YES;
    return contentBgView;
}

- (UILabel *)makeCommonLabel
{
    UILabel* commonLabel = [[UILabel alloc] init];
    commonLabel.font = JHFont(13);
    commonLabel.textColor = HEXCOLOR(0x333333);
    commonLabel.numberOfLines = 1;
    commonLabel.textAlignment = NSTextAlignmentLeft;
    return commonLabel;
}

- (void)setAvatarImageKey:(NSString*)imgKey image:(UIImage*)image
{
    self.selectedImgKey = imgKey;
    if(image)
        [_addImgBtn setImage:image forState:UIControlStateNormal];
}

#pragma mark - delegate
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > maxTextFieldCount)
    {
        textField.text = [textField.text substringToIndex:maxTextFieldCount];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    int maxNum = maxTextviewCount;
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
        maxNum = maxLiveRoomTextviewCount;
    if (textView.text.length > maxNum)
    {
        textView.text = [textView.text substringToIndex:maxNum];
    }
}

#pragma mark - //相册、相机调用方法
- (void)selectPictureFromCamera
{
    NSLog(@"点击了拍照");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = (self.selectPhotoType == 0);
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟无效,请真机测试");
    }
}

- (void)selectPictureFromAblum
{
    NSLog(@"点击了从手机选择");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = (self.selectPhotoType == 0);
    imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = nil;
    if(self.selectPhotoType == 0) {
        image = info[UIImagePickerControllerEditedImage];
        @weakify(self);
         [[JHUploadManager shareInstance] uploadSingleImage:image filePath:kJHAiyunRoomAnchorPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
             @strongify(self);
             ///已经上传完成
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (isFinished && [imgKey isNotBlank])
                 {
                     [self setAvatarImageKey:imgKey image:image];
                 }
                 else
                 {
                     [SVProgressHUD showInfoWithStatus:@"图片上传失败，请重试"];
                 }
             });
         }];
    }
    else {
        image = info[UIImagePickerControllerOriginalImage];
        if(self.selectPhotoType == 1) {
            self.authImage1 = image;
            self.authUrl1 = @"";
            self.authView1.uploadImage = image;
        }
        else if(self.selectPhotoType == 2) {
            self.authImage2 = image;
            self.authUrl2 = @"";
            self.authView2.uploadImage = image;
        }
        
    }
}

- (void)finishArchorInfo
{
    if(!(_addImgBtn.imageView.image))
    {
        [self.view makeToast:@"请选择图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if([self.nameTextField.text length] <= 0)
    {
        [self.view makeToast:@"请输入昵称" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if([self.introductionTextview.text length] <= 0)
    {
        [self.view makeToast:@"请输入主播介绍" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if(self.authUrl1.length <= 0 && !self.authImage1) {
        JHTOAST(@"请先上传身份证人像面国徽面在提交");
        return;
    }
    
    if(self.authUrl2.length <= 0 && !self.authImage2) {
        JHTOAST(@"请先上传身份证人像面国徽面在提交");
        return;
    }
    
    if(_anchorRoomInfo && (_anchorRoomInfo.authState == 1 || _anchorRoomInfo.authState == 2) && (!self.authImage1 && !self.authImage2)) {
        JHTOAST(@"请选择您重新上传的资质信息");
        return;
    }
    
    if(self.authUrl1.length > 0 && self.authUrl2.length > 0) {
        [self commitAnchorData];
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    if(self.authUrl1.length <= 0) {
        dispatch_group_enter(group);
        [self uploadPhotoImage:self.authImage1 type:1 block:^{
            dispatch_group_leave(group);
        }];
    }
    
    if(self.authUrl2.length <= 0) {
        dispatch_group_enter(group);
        [self uploadPhotoImage:self.authImage2 type:2 block:^{
            dispatch_group_leave(group);
        }];
    }

    @weakify(self);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self commitAnchorData];
    });
}

- (void)commitAnchorData {
    JHLiveRoomInfoModel* infoReq = [JHLiveRoomInfoModel new];
    JHLiveRoomArchorInfoAddReqModel* archorInfo = [JHLiveRoomArchorInfoAddReqModel new];
    archorInfo.channelLocalId = self.anchorRoomInfo.channelLocalId;
    archorInfo.broadId = self.anchorRoomInfo.broadId;
    if(self.selectedImgKey)
        archorInfo.avatar = self.selectedImgKey;
    else
        archorInfo.avatar = self.anchorRoomInfo.avatar;
    
    if(self.authUrl1.length > 0) {
        archorInfo.idCardFrontImg = self.authUrl1;
    }
    else {
        archorInfo.idCardFrontImg = self.anchorRoomInfo.idCardFrontImg;
    }
    
    if(self.authUrl2.length > 0) {
        archorInfo.idCardBackImg = self.authUrl2;
    }
    else {
        archorInfo.idCardBackImg = self.anchorRoomInfo.idCardBackImg;
    }
    archorInfo.nick = self.nameTextField.text;
    archorInfo.des = self.introductionTextview.text;
    JH_WEAK(self)
    [infoReq requestAddArchorInfo:archorInfo resp:^(NSString* msg, id data) {
        JH_STRONG(self)
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else
        {
            if (self.doneBlock) {
                self.doneBlock();
            }
            [UITipView showTipStr:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)uploadPhotoImage:(UIImage *)image type:(NSInteger)type block:(dispatch_block_t)block {
    @weakify(self);
     [[JHUploadManager shareInstance] uploadSingleImage:image filePath:kJHAiyunRoomAnchorPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
         @strongify(self);
         ///已经上传完成
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (isFinished && [imgKey isNotBlank])
             {
                 if(type == 1) {
                     self.authUrl1 = imgKey;
                 }
                 else if(type == 2) {
                     self.authUrl2 = imgKey;
                 }
                 if(block) {
                     block();
                 }
             }
             else
             {
                 if(type == 1) {
                     self.authUrl1 = @"";
                 }
                 else if(type == 2) {
                     self.authUrl2 = @"";
                 }
                 [SVProgressHUD showInfoWithStatus:@"图片上传失败，请重试"];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
         });
     }];
}

- (void)finishRoomInfo
{
    if([self.introductionTextview.text length] <= 0)
    {
        [self.view makeToast:@"请输入直播间介绍" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    static int allProgress = 0;
    JHLiveRoomInfoModel* infoReq = [JHLiveRoomInfoModel new];
    JH_WEAK(self)
    JHLiveRoomInfoAddReqModel* info = [JHLiveRoomInfoAddReqModel new];
    info.channelLocalId = self.anchorRoomInfo.channelLocalId;
    info.roomDes = self.introductionTextview.text;
    [infoReq requestAddLiveRoomInfo:info resp:^(NSString* msg, id data) {
        JH_STRONG(self)
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else
        {
            if (self.doneBlock) {
                self.doneBlock();
            }
            [UITipView showTipStr:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - event
-(void)rightActionButton:(UIButton *)sender
{
    if(self.anchorRoomInfo.pageType == JHArchorSectionTypeLiveRoom)
    {
        [self finishRoomInfo];
    }
    else
    {
        [self finishArchorInfo];
    }
}

- (void)addAvatorImageAction {
    if(!_forbiddenEdit) {
        self.selectPhotoType = 0;
        [self addImageAction];
    }
}

- (void)addImageAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self selectPictureFromAblum];
     }]];
    
     [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self selectPictureFromCamera];
     }]];
     
     [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     }]];
    
     [self presentViewController:alert animated:YES completion:nil];
}

@end
