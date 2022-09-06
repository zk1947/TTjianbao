//
//  JHSendCommentViewController.m
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHSendCommentViewController.h"
#import "JHCommentStartView.h"
#import "JHCommentTagView.h"
#import "JHPhotoItemView.h"
#import "TZImagePickerController.h"
#import "JHCommentSuccessViewController.h"
#import "JHAudienceCommentMode.h"
#import "NOSUpImageTool.h"
#import "CoponPackageMode.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"

@interface JHSendCommentViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate> {
    CGFloat maxCount;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeHeight;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet JHCommentStartView *goodsStarView;

@property (weak, nonatomic) IBOutlet JHCommentTagView *tagView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;

@property (weak, nonatomic) IBOutlet JHCommentStartView *starView1;
@property (weak, nonatomic) IBOutlet JHCommentStartView *starView2;
@property (weak, nonatomic) IBOutlet JHCommentStartView *starView3;
@property (weak, nonatomic) IBOutlet UIButton *addPicBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeight;

@property (weak, nonatomic) IBOutlet UIView *photosView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addBtnToLeftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipToTop;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *allPhotos;
@property (nonatomic, strong) NSMutableArray *imgeURLs;
@property (nonatomic, strong) NSMutableArray *libPhotos;
@property (nonatomic, strong) NSMutableArray *camaraPhotos;

@property (nonatomic, strong) JHAudienceCommentMode *model;
@property (nonatomic, strong) CoponPackageMode *coponModel;


@end

@implementation JHSendCommentViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    maxCount = 200;
//    [self  initToolsBar];
    self.title = JHLocalizedString(@"goodsComment"); //背景色有差异
//    [self.navbar setTitle:JHLocalizedString(@"goodsComment")];
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self makeUI];
    [self requestRed];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.view addGestureRecognizer:tap];
}


- (void)makeUI {
    MJWeakSelf
    [self.goodsImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(self.imageUrl)] placeholder:kDefaultCoverImage];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.toTopHeight.constant = UI.statusAndNavBarHeight;
    self.goodsStarView.levelLabel.hidden = NO;
    self.goodsStarView.leftSpace = 0;
    self.goodsStarView.selectedComplete = ^(id sender) {
        weakSelf.tagView.starCount = weakSelf.goodsStarView.selectedCount;
         [weakSelf hiddenKeyBoard];
    };
    
    self.starView1.titleLabel.text = JHLocalizedString(@"goodsSatisfaction");
    self.starView2.titleLabel.text = JHLocalizedString(@"deliverSpeed");
    self.starView3.titleLabel.text = JHLocalizedString(@"appraiseService");
    self.textView.delegate = self;
    self.textView.editable = !_isShow;
    self.tagView.finish = ^(CGFloat height) {
        weakSelf.tagViewHeight.constant = height;
    };
    
    self.tagView.clickTagFinish = ^(id sender) {
        [weakSelf hiddenKeyBoard];
    };
    if (_isShow) {
        [self requestDetail];
        self.scrollView.hidden = YES;
        self.noticeHeight.constant = 0;
        self.tipLabel1.text = @"";
        self.tipLabel2.text = @"";
        self.addPicBtn.hidden = YES;
        self.placeHolderLabel.hidden = YES;
        self.tipToTop.constant = 0;
    }else {
        [self initRightButtonWithName:JHLocalizedString(@"commit") action:@selector(submitAction:)];
        [self.jhRightButton setTitleColor:HEXCOLOR(0xff4200) forState:UIControlStateNormal];
        [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.right.equalTo(self.jhNavView).offset(-10);
        }];
//        [self.navbar addrightBtn:JHLocalizedString(@"commit") withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-60,0,60,44)];
//        [self.navbar.rightBtn setTitleColor:HEXCOLOR(0xff4200) forState:UIControlStateNormal];
//        [self.navbar.rightBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self requestTags];
        
    }
    self.starView1.isShow = self.isShow;
    self.starView2.isShow = self.isShow;
    self.starView3.isShow = self.isShow;
    self.goodsStarView.isShow = self.isShow;

    //都不显示红包提示了
    self.tipLabel1.text = @"";
    self.tipLabel2.text = @"";
    self.tipToTop.constant = 0;
    self.noticeHeight.constant = 0;

    
}

- (void)setModel:(JHAudienceCommentMode *)model {
    _model = model;
    [self.goodsImage jhSetImageWithURL:[NSURL URLWithString:model.orderImg] placeholder:kDefaultCoverImage];
    self.goodsStarView.selectedCount = model.pass;
    self.textView.text = model.commentContent;
    [self.tagView showTagArray:model.commentTagsList];
    [self makePhotoView];
    self.starView1.selectedCount = model.pass1;
    self.starView2.selectedCount = model.pass2;
    self.starView3.selectedCount = model.pass3;
    self.textHeight.constant = self.textView.contentSize.height;
}


- (NSMutableArray *)camaraPhotos {
    if (!_camaraPhotos) {
        _camaraPhotos = [NSMutableArray array];
    }
    return _camaraPhotos;
}

- (NSMutableArray *)libPhotos {
    if (!_libPhotos) {
        _libPhotos = [NSMutableArray array];
    }
    return _libPhotos;
}

- (void)dealAllPhotosIsLib:(BOOL)isLib {
    self.allPhotos = [NSMutableArray array];
    if (isLib) {
        [self.allPhotos addObjectsFromArray:self.libPhotos];
        [self.allPhotos addObjectsFromArray:self.camaraPhotos];
        
    }else {
        [self.allPhotos addObjectsFromArray:self.camaraPhotos];
        
        [self.allPhotos addObjectsFromArray:self.libPhotos];
        
        
    }
}
- (void)makePhotoView {
    
    for (UIView *view in self.photosView.subviews) {
        if (view != self.addPicBtn) {
            [view removeFromSuperview];
        }
    }
    NSArray *array = self.allPhotos.copy;
    
    MJWeakSelf
    CGFloat ww = (ScreenW - 30)/4.;
    
    self.tipToTop.constant = 8;
    if (self.isShow) {
        array = self.model.commentImgsList;
        if (!array || array.count == 0) {
            self.tipToTop.constant = -ww;
            return;
        }
    }

    for (int i = 0; i < array.count; ++i) {
        JHPhotoItemView *item = [[JHPhotoItemView alloc] initWithFrame:CGRectMake(ww*i, 0, ww, ww)];
        item.tag = i;
        if (self.isShow) {
            
            [item showImageUrl:array[i]];
            item.clickImageAction = ^(UIImageView *imageview) {
                NSMutableArray * arr = [NSMutableArray arrayWithArray:weakSelf.model.commentImgsList];
                [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:imageview.tag result:^(NSInteger index) {
                    
                }];
                [EnlargedImage sharedInstance].audienceCommentMode = weakSelf.model;


            };
        }else {
            item.image = array[i];
            item.deleteAction = ^(id sender) {
                [weakSelf.allPhotos removeObject:array[i]];
                [weakSelf.camaraPhotos removeObject:array[i]];
                [weakSelf.libPhotos removeObject:array[i]];
                
                [weakSelf makePhotoView];
            };
        }
        
        [self.photosView addSubview:item];
    }
    
    if (array.count>=4) {
        self.addPicBtn.hidden = YES;
    }else {
        self.addPicBtn.hidden = NO;
        self.addBtnToLeftWidth.constant = ww*array.count;
    }
    
    if (self.isShow) {
        self.addPicBtn.hidden = YES;
    }
    
}
#pragma mark - textViewDelegate

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


- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= 0) {
        self.placeHolderLabel.hidden = NO;
        self.tipLabel2.text = [NSString stringWithFormat:@"0/%ld", (long)maxCount];
        
    }else if (textView.text.length <= maxCount){
        self.placeHolderLabel.hidden = YES;
        self.tipLabel2.text = [NSString stringWithFormat:@"%ld/%ld", (long)textView.text.length, (long)maxCount];
    }else {
        self.placeHolderLabel.hidden = YES;
        textView.text = [textView.text substringWithRange:NSMakeRange(0, maxCount)];
        self.tipLabel2.text = [NSString stringWithFormat:@"%ld/%ld", (long)textView.text.length, (long)maxCount];
    }
    
    if (textView.contentSize.height>self.textHeight.constant) {
        self.textHeight.constant = textView.contentSize.height;
    }
    
}



#pragma mark - action

- (IBAction)addPhotos:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:JHLocalizedString(@"selectPic") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:JHLocalizedString(@"album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:4-self.allPhotos.count delegate:self];
        
        MJWeakSelf
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos) {
                [weakSelf.libPhotos addObjectsFromArray:photos];
                [weakSelf dealAllPhotosIsLib:YES];
                [weakSelf makePhotoView];

            }
            
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:JHLocalizedString(@"takePhoto") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
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
    
    [alert addAction:[UIAlertAction actionWithTitle:JHLocalizedString(@"cancel") style: UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)submitAction:(UIButton *)btn {
    [self checkInfo];
}

- (void)hiddenKeyBoard {
    [self.textView resignFirstResponder];
}


#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.camaraPhotos addObject:image];
    [self dealAllPhotosIsLib:NO];
    [self makePhotoView];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - request

- (void)requestTags {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/orderComment/tags") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.tagView.tagArray = respondObject.data;
        self.tagView.starCount = self.goodsStarView.selectedCount;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (void)checkInfo {
    BOOL isText = NO;
    BOOL isAllPhoto = NO;
    [self.imgeURLs removeAllObjects];
    if (self.textView.text.length>=0) {
        isText = YES;
    }
    if (self.allPhotos.count >= 0) {
        isAllPhoto = YES;
    }
    [self uploadAllImage];
    return;
    if (isText && isAllPhoto) {
        [self uploadAllImage];
    } else {
        NSString *title = JHLocalizedString(@"comment30GetCash");
//        if (!isText) {
//            title = @"";
//            [self alertShowTitle:title];
//            return;
//        }
//        if (!isAllPhoto) {
//            title = @"";
//            [self alertShowTitle:title];
//            return;
//        }
        
        [self alertShowTitle:title];
        return;
    }
    
}

- (void)alertShowTitle:(NSString *)string {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:JHLocalizedString(@"haveRedbagNoGet") message:string preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:JHLocalizedString(@"giveupRedbag") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadAllImage];
        
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:JHLocalizedString(@"getRedbag") style: UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)postRequest {
    
    
    JHAudienceCommentMode *model = [[JHAudienceCommentMode alloc] init];
    model.orderId = self.orderId;
    model.pass = self.goodsStarView.selectedCount;
    model.pass1 = self.starView1.selectedCount;
    model.pass2 = self.starView2.selectedCount;
    model.pass3 = self.starView3.selectedCount;
    model.commentContent = self.textView.text;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[model mj_keyValues]];
    dic[@"commentTags"] = [self.tagView.selectedArray mj_JSONString];
    dic[@"commentImgs"] = [self.imgeURLs mj_JSONString];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderComment/auth/gen") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        
        [UITipView showTipStr:JHLocalizedString(@"commitSuccess")];
        
        if (self.commentComplete) {
            self.commentComplete();
        }
        NSInteger isValid = [respondObject.data[@"isValid"] integerValue];
        
        if (isValid && self.coponModel) {
            JHCommentSuccessViewController *vc = [[JHCommentSuccessViewController alloc] init];
            vc.price = self.coponModel.price;
            vc.orderId = self.orderId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
}

- (void)uploadAllImage {
    if (self.allPhotos.count) {
        self.imgeURLs = [NSMutableArray array];
        [SVProgressHUD show];
        [self uploadImage:0];
    }else {
        [self postRequest];
    }
    
}

- (void)uploadImage:(NSInteger)index {
    if (index>=self.allPhotos.count) {
        [SVProgressHUD dismiss];
        return;
    }
    
    NOSFormData * data = [[NOSFormData alloc]init];
    data.fileImage = self.allPhotos[index];
    data.fileDir = @"order_comment";
    
    MJWeakSelf
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        [weakSelf.imgeURLs addObject:respondObject.data];
        
        if (index < weakSelf.allPhotos.count-1) {
            [weakSelf uploadImage:index+1];
        }else {
            [weakSelf postRequest];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    
    
}

- (void)requestDetail {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/orderComment/detail") Parameters:@{@"orderId":self.orderId} successBlock:^(RequestModel *respondObject) {
        self.model = [JHAudienceCommentMode mj_objectWithKeyValues:respondObject.data];
        self.scrollView.hidden = NO;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}


- (void)requestRed {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/coupon") Parameters:@{@"couponId":@(16)} successBlock:^(RequestModel *respondObject) {
         self.coponModel = [CoponPackageMode mj_objectWithKeyValues:respondObject.data];
        if (!self.coponModel) {
            self.tipLabel1.text = @"";
            self.tipLabel2.text = @"";
            self.tipToTop.constant = 0;
        }
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

@end
