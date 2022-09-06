//
//  JHSendOrderView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/23.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHSendOrderView.h"
#import "NTESMessageModel.h"
#import "UIView+NTES.h"
#import "JHPickerView.h"
#import "LBXScanViewController.h"
#import "LBXZBarWrapper.h"
#import "JHQRViewController.h"
#import "JHForbidAccountViewController.h"
#import "NOSUpImageTool.h"
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "JHAntiFraud.h"

@interface JHSendOrderView () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, STPickerSingleDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UIButton *addImage;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) UIView *showImageView;
@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendWishBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UITextField *cardId;
@property (weak, nonatomic) IBOutlet UISwitch *isGiftSwitch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *sendLaughOederBtn;

@property (strong, nonatomic) JHPickerView *picker;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSMutableArray *pickerSecondArray;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *tagBackView;
@property (strong, nonatomic) NSMutableArray *btnTagArray;
@property (nonatomic, assign) int selectedTagIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagHeight;


@end


@implementation JHSendOrderView
- (void)awakeFromNib {
    [super awakeFromNib];
    _priceText.delegate = self;
    _isGiftSwitch.on = NO;
    _isGiftSwitch.onTintColor = kGlobalThemeColor;
    _isGiftSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);

    _selectedTagIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forbidSuccess:) name:ForbidSuccessNotifaction object:nil];
}

- (void)selectedStatus:(BOOL)selected withBtn:(UIButton *)btn {
    btn.selected = selected;
    if (selected) {
        btn.layer.borderColor = kGlobalThemeColor.CGColor;
        btn.backgroundColor = kGlobalThemeColor;
    }else {
        btn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
        btn.backgroundColor = [UIColor whiteColor];
    }
}

- (void)clickTag:(UIButton *)btn {
    if (btn.tag != self.selectedTagIndex && self.selectedTagIndex>=0 && self.selectedTagIndex<self.btnTagArray.count) {
        UIButton *but = self.btnTagArray[self.selectedTagIndex];
        [self selectedStatus:NO withBtn:but];
    }
    
    if (btn.selected) {
        self.selectedTagIndex = -1;
    }else {
        self.selectedTagIndex = (int)btn.tag;
    }
    [self selectedStatus:!btn.selected withBtn:btn];

}

- (void)setTagBtnWithArray:(NSArray *)array {
    self.tagArray = array;
    self.btnTagArray = [NSMutableArray array];
    int count = 3;
    CGFloat ox = 0;
    CGFloat oy = 0;
    CGFloat ww = (245.-30.-20.)/count;
    for (int i = 0; i<array.count; i++) {
        OrderTypeModel *model = array[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        if (i%count == 0) {
                  ox = 0;
              }else {
                  ox = ox+10+ww;
              }
              
        oy = (int)(i/count)*(26+10);
        btn.frame = CGRectMake(ox, oy, ww, 26);
        btn.tag = i;
      
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
        [self.btnTagArray addObject:btn];
        [self.tagBackView addSubview:btn];
    }
    
    if (self.btnTagArray.count) {
        oy = oy+26;
    }
    self.tagHeight.constant = oy;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
        _picker.arrayData = self.pickerArray;
    }
    return _picker;
}

- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [NSMutableArray array];
        for (NSDictionary *dic in [UserInfoRequestManager sharedInstance].temporaryMuteTimes) {
            [_pickerArray addObject:dic[@"label"]];
        }
    }
    return _pickerArray;
}
- (NSMutableArray *)pickerSecondArray {
    if (!_pickerSecondArray) {
        _pickerSecondArray = [NSMutableArray array];
        for (NSDictionary *dic in [UserInfoRequestManager sharedInstance].temporaryMuteTimes) {
            [_pickerSecondArray addObject:dic[@"seconds"]];
        }
    }
    return _pickerSecondArray;
}

+ (JHSendOrderView *)sendOrderViewFirst {
    
    return  (JHSendOrderView *)[[NSBundle mainBundle] loadNibNamed:@"JHSendOrderView" owner:nil options:nil].firstObject;
}

+ (JHSendOrderView *)sendOrderViewSecond {
    
    return  (JHSendOrderView *)[[NSBundle mainBundle] loadNibNamed:@"JHSendOrderView" owner:nil options:nil].lastObject;
}

- (void)setModel:(NTESMessageModel *)model {
    _model = model;
    [_avatarImage jhSetImageWithURL:[NSURL URLWithString:model.avatar] placeholder:kDefaultAvatarImage];
    _nickLabel.text = model.nick;
    self.muteBtn.selected = NO;
    self.blackBtn.selected = NO;

    [self setMuteWithAccid:model.message.from];
    if (model.isAppraise) {
        self.sendOrderBtn.hidden = YES;
    }
}
- (IBAction)sendWishAction:(UIButton *)sender{
    //发送心愿单
        if (self.model.message.from) {
            if (self.sendWish) {
//                self.sendWish(self.model.message.from);
                self.sendWish(self.model.customerId);

            }
            [self removeFromSuperview];
        }
 

}
- (IBAction)sendOrderAction:(UIButton *)sender {
    
    _sendOrderSecond = [JHSendOrderView sendOrderViewSecond];
    _sendOrderSecond.frame = self.viewController.view.bounds;
    _sendOrderSecond.clickImage = self.clickImage;
    if (self.model) {
        _sendOrderSecond.model = self.model;
    }
    _sendOrderSecond.cardId.enabled = NO;
    _sendOrderSecond.anchorId = self.anchorId;
    _sendOrderSecond.customerId = self.customerId;
    _sendOrderSecond.biddingId = self.biddingId;
    
    _sendOrderSecond.isAssistant = self.isAssistant;
    _sendOrderSecond.scanBtn.hidden = !self.isAssistant;
    _sendOrderSecond.tagArray = self.tagArray;
    
    [self.superview addSubview:self.sendOrderSecond];
    [_sendOrderSecond setTagBtnWithArray:self.tagArray];
    
    [self removeFromSuperview];
    
}

- (IBAction)selectedImage:(id)sender {
    if (self.clickImage) {
        self.clickImage(self);
    }
    
    return;
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
//    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [sheet showInView:self.viewController.view];
    
}


- (IBAction)sendOrderRequestAction:(id)sender {
    
    [self.priceText resignFirstResponder];
    if (!self.imageURL) {
        [self makeToast:@"请上传图片"];
        return;
    }
    if (!self.priceText.text || self.priceText.text.length<=0) {
        [self makeToast:@"请填写价格"];
        return;
    }
    
    MJWeakSelf
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定发送订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestData];
    }]];
    [self.viewController presentViewController:alertVc animated:YES completion:nil];
    
    
}

- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}
//封号
- (IBAction)blackAction:(UIButton *)sender {
    if (!sender.selected) {
        [self requestCloseAcount];

    }
    
}

- (IBAction)muteAction:(UIButton *)sender {
    if (sender.selected) {
        [self requestSetMute:@0];
    }else {
        [self.picker show];
    }
    return;
    NSString *string = self.muteBtn.selected?@"是否解除禁言该用户":@"是否禁言该用户";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MJWeakSelf
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":self.model.message.from, @"muteDuration":self.muteBtn.selected?@(0):@(300)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            weakSelf.muteBtn.selected = !weakSelf.muteBtn.selected;
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
        
    }]];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];

}

- (void)setMuteWithAccid:(NSString *)accid {
    
    if (!accid){
        return;
    }
    
    NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
    requst.roomId = self.roomId;
    requst.userIds = @[accid];
    MJWeakSelf
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        
        if (members.count) {
        
            NIMChatroomMember *mem = members.firstObject;
            weakSelf.muteBtn.selected = mem.isTempMuted;
//            weakSelf.blackBtn.selected = mem.isInBlackList;
            NSLog(@"accid %@  === %@ %zd",accid, mem.userId, (NSInteger)mem.isTempMuted);


        }else {
            NSLog(@"accid %@  =========",accid);

            weakSelf.muteBtn.selected = NO;

//            weakSelf.muteBtn.hidden = YES;
//            weakSelf.blackBtn.hidden = YES;
        }
        
    }];
}
//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.navigationController.navigationBar.translucent = NO;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
        
    }else if (buttonIndex == 1){
        NSLog(@"点击了拍照");
        [[NIMAVChatSDK sharedSDK].netCallManager setCameraDisable:YES];
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.navigationController.navigationBar.translucent = NO;
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self.viewController dismissViewControllerAnimated:NO completion:nil];
            [self.viewController presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    NSData *picData = UIImageJPEGRepresentation(image, 0.1);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (UIView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _showImageView.backgroundColor = [UIColor blackColor];
        UIImageView *image = [[UIImageView alloc] initWithFrame:_showImageView.bounds];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        self.imageView = image;
        [_showImageView addSubview:image];
        CGFloat ww = (ScreenW-100)/2.;
        NSArray *titles = @[@"icon_pic_cancel", @"icon_pic_ok"];
        for (int i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ww*i+50, ScreenH-90, ww, 70);
            [btn setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(actionSelecte:) forControlEvents:UIControlEventTouchUpInside];
            [_showImageView addSubview:btn];
            
        }
        
    }
    
    return _showImageView;
}

- (void)actionSelecte:(UIButton *)btn{
    if (btn.tag == 0) {
        [self.bgImageView setImage:[UIImage imageNamed:@"bg_add_pic"]];
        self.imageView.image = nil;
        
    } else {
        [self.bgImageView setImage:self.imageView.image];
        [self scanCardIdWithImage:self.imageView.image];
        [self uploadImage:self.imageView.image];
    }
    [self.showImageView removeFromSuperview];
    
}


#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(NO)];
    
    return YES;
}

//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }
    
    //第一个参数，被替换字符串的range
    //第二个参数，即将键入或者粘贴的string
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];
    
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

#pragma mark -
-(void)uploadImage:(UIImage *)image{
    
    NOSFormData * data = [[NOSFormData alloc]init];
    data.fileImage = image;
    if (self.isAnction) {
        data.fileDir = @"auction_img";

    }else {
        data.fileDir = @"goods";

    }
    
    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        self.imageURL = respondObject.data;
        
        [SVProgressHUD dismiss];
        
        if (self.auctionUploadFinish) {
            self.auctionUploadFinish(respondObject.data);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
    [SVProgressHUD show];
}

- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"anchorId"] = self.anchorId;
    dic[@"goodsImg"] = self.imageURL;
    dic[@"orderPrice"] = self.priceText.text;
    if (self.cardId.text.length>0){
        dic[@"barCode"] = self.cardId.text;
    }
    if (self.cardId.text.length) {
        dic[@"inputManual"] = self.cardId.enabled?@(1):@(2);//手输入1 识别的2
    }else {
        dic[@"inputManual"] = @(0);
    }
    if (self.biddingId) {
        dic[@"viewerId"] = self.customerId;

    }else {
        dic[@"viewerId"] = self.model.customerId?:self.model.customerId;
    }
    dic[@"orderCategory"] = @"normal";

    if (self.tagArray) {
        if (self.selectedTagIndex>=0 && self.selectedTagIndex<self.tagArray.count) {
            OrderTypeModel *model = self.tagArray[self.selectedTagIndex];
            dic[@"orderCategory"] = model.Id;
        }
    }
    
    if (_isLaughOrder) {
        dic[@"orderType"] = @(2);
        dic[@"orderPrice"] = @"0";
        dic[@"goodsImg"] = @"img";

    }
    
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
        if (self.biddingId) {
            [self requestBiddingAndOrder:respondObject.data[@"orderId"]];
        }else {
            [self makeToast:@"发送成功"];
            [self hiddenAlert];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [self makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
    }];
}

- (void)requestBiddingAndOrder:(NSString *)orderId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"biddingId"] = self.biddingId;
    dic[@"orderId"] = orderId;

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/bidding/biddingAndOrder/auth") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [self makeToast:@"发送成功"];
        [self hiddenAlert];
        
    } failureBlock:^(RequestModel *respondObject) {

        [self makeToast:respondObject.message];
    }];

}

- (void)setShowStyle {
    if (!self.model.customerId) {
        self.sendOrderBtn.hidden = YES;
        self.muteBtn.hidden = YES;
        self.sendWishBtn.hidden = YES;
        self.blackBtn.hidden = YES;
        goto update;

        return;
    }
    if ([self.model.customerId isEqualToString:self.anchorId]) {
        self.sendOrderBtn.hidden = YES;
        self.muteBtn.hidden = YES;
        self.sendWishBtn.hidden = YES;
        self.blackBtn.hidden = YES;
        goto update;

        return;
    }
    

    
    if ([self.model.customerId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        self.sendOrderBtn.hidden = YES;
        self.muteBtn.hidden = YES;
        self.sendWishBtn.hidden = YES;
        self.blackBtn.hidden = YES;

        goto update;
        return;

    }
    
    self.sendOrderBtn.hidden = NO;
    self.muteBtn.hidden = NO;
    self.sendWishBtn.hidden = NO;
    
    if (self.model.isAppraise) {
        self.sendOrderBtn.hidden = YES;
        self.sendWishBtn.hidden = YES;
        self.blackBtn.hidden = YES;//NO;
        [self.muteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(69.5);
            make.right.mas_equalTo(-69.5);
            make.top.mas_equalTo(108.5);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }
    else
    {
        self.blackBtn.hidden = NO;
        [self.muteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18.5);
            make.top.mas_equalTo(108.5);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }
    goto update;

    
update:

    self.sendLaughOederBtn.hidden = self.sendOrderBtn.hidden;
    self.lineView.hidden = self.blackBtn.hidden;
    if (_sendLaughOederBtn.hidden) {
        self.backViewHeight.constant = 180;
    }else {
        self.backViewHeight.constant = 300;

    }


}

#pragma mark -
- (void)showImageViewAction:(UIImage *)image {
    [self.superview addSubview:self.showImageView];
    self.imageView.image = image;
}

- (void)showAlert {
    [self setShowStyle];

    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - 49;
        
    }else {
        rect.origin.y = ScreenH - rect.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    
    _isLaughOrder = NO;

}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    MJWeakSelf
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.frame = rect;
    } completion:^(BOOL finished) {
        //        [weakSelf removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.backView) {
        CGPoint point = [touches.anyObject locationInView:self];
        if (CGRectContainsPoint(self.backView.frame, point)) {
            return;
        }
    }
    
    [self.viewController touchesBegan:touches withEvent:event];
    
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    
    NSInteger index = pickerSingle.selectedIndex;
    [self requestSetMute:self.pickerSecondArray[index]];
    
}

- (void)requestSetMute:(NSNumber *)sesond {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":self.model.message.from, @"muteDuration":sesond} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if ([sesond integerValue]>0) {
            [SVProgressHUD showSuccessWithStatus:@"禁言成功"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"解除禁言成功"];

        }
        self.muteBtn.selected = !self.muteBtn.selected;
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (void)requestCloseAcount{
    
    if (self.blackBtn.selected) {
        NSInteger ban = !self.blackBtn.selected;
        NSString *string = ban?@"冻结":@"解冻";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否将该用户%@",string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/ban") Parameters:@{@"banCustomerId":self.model.customerId, @"banFlag":@(ban)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",string]];
                self.blackBtn.selected = !self.blackBtn.selected;
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD showErrorWithStatus:respondObject.message];
            }];
            
        }]];
        
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }else {
        
        JHForbidAccountViewController *vc = [[JHForbidAccountViewController alloc] init];
        vc.customerId = self.model.customerId;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    
    

}

- (void)requestSetBlack{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否将该用户拉黑" message:@"拉黑后将不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/blacklist") Parameters:@{@"viewerAccId":self.model.message.from} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showSuccessWithStatus:@"拉黑成功"];
            self.blackBtn.selected = !self.muteBtn.selected;
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];    }]];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
    

}


- (void)scanCardIdWithImage:(UIImage *)image {
    __weak __typeof(self) weakSelf = self;
    self.cardId.text = @"";
    [LBXZBarWrapper recognizeImage:image block:^(NSArray<LBXZbarResult *> *result) {
        
        if (result.count<1){
//            weakSelf.cardId.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"识别宝卡号失败 可以尝试重新拍照"];
        }else
        {
            weakSelf.cardId.enabled = NO;
            LBXZbarResult *firstObj = result[0];
//            LBXScanResult *scanResult = [[LBXScanResult alloc]init];
//            scanResult.strScanned = firstObj.strScanned;
//            scanResult.imgScanned = firstObj.imgScanned;
//            scanResult.strBarCodeType = [LBXZBarWrapper convertFormat2String:firstObj.format];
            weakSelf.cardId.text = firstObj.strScanned;
            
        }
        
        
        
    }];
}

- (IBAction)sendLaughOrder:(id)sender {
    _sendOrderSecond = nil;
    _isLaughOrder = YES;
    [self requestData];
}

- (IBAction)scanCardAction:(id)sender {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
       vc.titleString = @"扫描宝卡";
       JH_WEAK(self)
       vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController * _Nonnull obj) {
           JH_STRONG(self)
           self.cardId.text = scanString;
           [obj.navigationController popViewControllerAnimated:YES];
       };
       [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)forbidSuccess:(NSNotification *)noti {
    self.blackBtn.selected = YES;
}
@end
