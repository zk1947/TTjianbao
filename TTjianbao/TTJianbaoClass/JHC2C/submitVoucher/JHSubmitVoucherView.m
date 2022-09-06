//
//  JHSubmitVoucherView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSubmitVoucherView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHSubmitVoucherPhotoItemView.h"
#import "TZImagePickerController.h"
#import "JHPickerView.h"
#import "JHOrderReturnMode.h"
#import "NOSUpImageTool.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "MBProgressHUD.h"
#import "JHQYChatManage.h"
#import "UIView+CornerRadius.h"
#import "UIImage+JHColor.h"
#import "JHRecycleOrderCancelViewController.h"

#define photoMaxCount 6
@interface JHSubmitVoucherView ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate,STPickerSingleDelegate>
{
    UITextView *noteTextview;
    UILabel * titleTip;
    NSInteger  selectedIndex;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView *productView;
@property(nonatomic,strong) UIView *statusView;
@property(nonatomic,strong) UIView *reasonView;
@property(nonatomic,strong) UIView *noteView;
@property(nonatomic,strong) UIView *introduceView;
@property(nonatomic,strong) UIView *voucherView;
@property (strong, nonatomic)  UIView *photosView;
@property (strong, nonatomic)  NSMutableArray <OrderPhotoMode *>*allPhotos;
@property (nonatomic, strong) NSMutableArray *camaraPhotos;
@property(nonatomic,strong) NSMutableArray <JHOrderReturnReasonMode*>*dataList;
@property (strong, nonatomic)  UIButton *addBtn;
@property (strong, nonatomic)  UIButton *completeBtn;

@property (strong, nonatomic)  UILabel *orderCode;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *productPrice;
@property (strong, nonatomic)  UILabel *productTitle;
@property (strong, nonatomic)  UILabel *reasonDesc;
@property (strong, nonatomic)  UILabel *statusDesc;
@property (strong, nonatomic)  UILabel *desc;
@property (strong, nonatomic)  UILabel *textCount;
@property (strong, nonatomic)  UILabel *serviceCash;
@property (strong, nonatomic)  UILabel *returnCash;

@property(nonatomic,strong) JHPickerView *picker;

@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;

@property (strong, nonatomic)    UITextField  *cash;

@property (strong, nonatomic)    NSString  *returnReson;
@property (strong, nonatomic)    NSString  *produtStatus;

@end
@implementation JHSubmitVoucherView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
        self.backgroundColor=[UIColor redColor];
        
        [self initScrollview];
        
    }
    return self;
}
-(void)dismissKeyboard{
    
    [self endEditing:YES];
    
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        
    }];
    [self initStatusView];
    [self initReasonView];
    // [self initOrderNote];
    [self initVoucherView];
    
    [self.contentScroll addSubview:self.completeBtn];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voucherView.mas_bottom).offset(60);
        make.height.offset(44);
        make.width.offset(320);
        make.centerX.equalTo(self.contentScroll);
        make.bottom.equalTo(self.contentScroll).offset(-20);
    }];
    
}
-(void)initStatusView{
    
    _statusView=[[UIView alloc]init];
    _statusView.backgroundColor=[UIColor whiteColor];
    _statusView.userInteractionEnabled=YES;
    [_statusView yd_setCornerRadius:8 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    _statusView.clipsToBounds = YES;
    [_statusView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(statusChoose:)]];
    [self.contentScroll addSubview:_statusView];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.width.offset(ScreenW-20);
        make.height.offset(50);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [_statusView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_statusView).offset(-15);
        make.centerY.equalTo(_statusView);
        
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"货物状态";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_statusView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_statusView).offset(15);
        make.centerY.equalTo(_statusView);
    }];
    
    _statusDesc=[[UILabel alloc]init];
    _statusDesc.text=@"请选择";
    _statusDesc.font=[UIFont systemFontOfSize:15];
    _statusDesc.backgroundColor=[UIColor clearColor];
    _statusDesc.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _statusDesc.numberOfLines = 1;
    _statusDesc.textAlignment = NSTextAlignmentLeft;
    _statusDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    [_statusView addSubview:_statusDesc];
    
    [_statusDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
        make.left.equalTo(title.mas_right).offset(10);
    }];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [_statusView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title).offset(0);
        make.bottom.equalTo(_statusView).offset(0);
        make.right.equalTo(indicator).offset(0);
        make.height.offset(1);
    }];
}
-(void)initReasonView{
    
    _reasonView=[[UIView alloc]init];
    _reasonView.backgroundColor=[UIColor whiteColor];
    _reasonView.userInteractionEnabled=YES;
    [_reasonView yd_setCornerRadius:8 corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    _reasonView.clipsToBounds = YES;
    [_reasonView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(reasonChoose:)]];
    [self.contentScroll addSubview:_reasonView];
    
    [_reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusView.mas_bottom).offset(0);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.width.offset(ScreenW-20);
        make.height.offset(50);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [_reasonView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_reasonView).offset(-15);
        make.centerY.equalTo(_reasonView);
        
    }];
    
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"申请原因";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_reasonView addSubview:title];
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reasonView).offset(15);
        make.centerY.equalTo(_reasonView);
    }];
    
    _reasonDesc=[[UILabel alloc]init];
    _reasonDesc.text=@"请选择";
    _reasonDesc.font=[UIFont systemFontOfSize:15];
    _reasonDesc.backgroundColor=[UIColor clearColor];
    _reasonDesc.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _reasonDesc.numberOfLines = 1;
    _reasonDesc.textAlignment = NSTextAlignmentLeft;
    _reasonDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    [_reasonView addSubview:_reasonDesc];
    
    [_reasonDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
        make.left.equalTo(title.mas_right).offset(10);
    }];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [_reasonView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title).offset(0);
        make.bottom.equalTo(_reasonView).offset(0);
        make.right.equalTo(indicator).offset(0);
        make.height.offset(1);
    }];
}

-(void)initVoucherView{
    
    _voucherView=[[UIView alloc]init];
    _voucherView.backgroundColor=[UIColor whiteColor];
    _voucherView.layer.cornerRadius = 8;
    _voucherView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:_voucherView];
    
    [_voucherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    UILabel *title=[[UILabel alloc]init];
    title.text= @"补充描述和凭证";
    title.font= [UIFont fontWithName:kFontNormal size:14];
    title.textColor = kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_voucherView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voucherView).offset(10);
        make.left.equalTo(_voucherView).offset(10);
    }];
    
    _noteView=[[UIView alloc]init];
    _noteView.layer.cornerRadius = 8;
    _noteView.layer.masksToBounds = YES;
    _noteView.backgroundColor=[CommHelp toUIColorByStr:@"#fafafa"];
    [_voucherView addSubview:_noteView];
    
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voucherView).offset(50);
        make.left.equalTo(_voucherView).offset(10);
        make.right.equalTo(_voucherView).offset(-10);
        make.bottom.equalTo(_voucherView).offset(-10);
    }];
    
    noteTextview=[[UITextView alloc]init];
    noteTextview.backgroundColor=[UIColor clearColor];
    noteTextview.font = [UIFont fontWithName:@"Arial" size:14.0];
    noteTextview.alpha=1.0;
    //[textview.layer setCornerRadius:5];//远角
    //textview.layer.masksToBounds = YES;
    noteTextview.delegate=self;
    noteTextview.autocorrectionType = UITextAutocorrectionTypeYes;
    noteTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteTextview.keyboardType = UIKeyboardTypeDefault;
    noteTextview.returnKeyType = UIReturnKeyDone;
    [_noteView addSubview:noteTextview];
    
    titleTip=[[UILabel alloc]init];
    titleTip.text=@"为更好解决您的问题，请描述具体的问题以及您的期望；凭证可上传，如收货时的商品图，聊天记录截图，快照单照片的等有效证据";
    titleTip.font=[UIFont systemFontOfSize:15];
    titleTip.backgroundColor=[UIColor clearColor];
    titleTip.textColor=[CommHelp toUIColorByStr:@"#999999"];
    titleTip.numberOfLines = 0;
    titleTip.textAlignment = NSTextAlignmentLeft;
    titleTip.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:titleTip];
    
    [titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(15);
        make.left.equalTo(_noteView).offset(15);
        make.right.equalTo(_noteView).offset(-12);
        //  make.width.equalTo(_noteView);
    }];
    
    [noteTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(10);
        make.left.equalTo(_noteView).offset(10);
        make.right.equalTo(_noteView).offset(-10);
        make.height.equalTo(@120);
    }];
    
    _textCount=[[UILabel alloc]init];
    _textCount.text=@"0/200";
    _textCount.font=[UIFont systemFontOfSize:15];
    _textCount.backgroundColor=[UIColor clearColor];
    _textCount.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _textCount.numberOfLines = 1;
    _textCount.textAlignment = NSTextAlignmentLeft;
    _textCount.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:_textCount];
    
    [_textCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextview.mas_bottom).offset(5);
        make.right.equalTo(_noteView).offset(-10);
        //  make.width.equalTo(_noteView);
    }];
    
    _photosView=[[UIView alloc]init];
    //  _photosView.backgroundColor=[UIColor redColor];
    [_noteView addSubview:_photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textCount.mas_bottom).offset(10);
        //  make.height.offset((ScreenW-20-15)/4);
        make.left.equalTo(_noteView).offset(10);
        make.right.equalTo(_noteView).offset(-10);
        make.bottom.equalTo(_noteView).offset(-10);
    }];
    // [self addSubview:self.addBtn];
    
    //    CGFloat ww =(ScreenW-20-15)/4;
    //    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(_photosView);
    //        make.height.offset(ww);
    //        make.width.offset(ww);
    //        make.left.equalTo(_photosView.mas_right).offset(5);
    //    }];
    
    
    [self makePhotoView];
}

- (void)makePhotoView {
    
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray <OrderPhotoMode*>*array = self.allPhotos.mutableCopy;
    if (array.count<photoMaxCount) {
        OrderPhotoMode * mode =[[OrderPhotoMode alloc]init];
        mode.showAddButton = YES;
        [array addObject:mode];
    }
    MJWeakSelf
    CGFloat ww =(ScreenW-60-20)/3;
    UIView * lastView;
    for (int i = 0; i < array.count; ++i) {
        JHSubmitVoucherPhotoItemView *item = [[JHSubmitVoucherPhotoItemView alloc] init];
        [self.photosView addSubview:item];
        //  item.backgroundColor=[CommHelp randomColor];
        item.tag = i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ww);
            make.width.offset(ww);
            
            if (i/3==0) {
                make.top.equalTo(self.photosView.mas_top).offset(10);
            }
            else{
                NSInteger  rate= i/3;
                make.top.equalTo(self.photosView.mas_top).offset(ww*rate+10*(rate));
            }
            if (i%3 == 0) {
                make.left.offset(0);
                
            }else{
                make.left.equalTo(lastView.mas_right).offset(10);
            }
            //            if (i%4 == 3) {
            //                make.right.equalTo(self.photosView).offset(0);
            //            }
            if (i==array.count-1) {
                make.bottom.equalTo(self.photosView).offset(-10);
            }
        }];
        
        [item setPhotoMode:array[i]];
        
        item.deleteAction = ^(id sender) {
            [weakSelf.allPhotos removeObject:array[i]];
            [weakSelf makePhotoView];
        };
        item.addAction = ^(id sender) {
            
            [weakSelf addPhotos];
        };
        lastView= item;
        
    }
    
}
-(UIButton*)addBtn{
    if (!_addBtn) {
        _addBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"note_add_image"]  forState:UIControlStateNormal];
    }
    return _addBtn;
}
-(UIButton*)completeBtn{
    if (!_completeBtn) {
        _completeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_completeBtn setTitle:@"提交" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font= [UIFont systemFontOfSize:15];
        _completeBtn.layer.cornerRadius = 22.0;
        
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
        [_completeBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        
    }
    return _completeBtn;
}
- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (NSMutableArray *)camaraPhotos {
    if (!_camaraPhotos) {
        _camaraPhotos = [NSMutableArray array];
    }
    return _camaraPhotos;
}
- (NSMutableArray *)allPhotos {
    if (!_allPhotos) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}

//-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
//
//    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
//    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
//    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
//
//    }];
//}
-(void)statusChoose:(UIGestureRecognizer*)gestureRecognizer{
    
    // [self.picker show];
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.dataArray =self.statusArr;
    vc.titleString = @"选择状态";
    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString * _Nonnull code) {
        @strongify(self);
        self.produtStatus = code;
        _statusDesc.text=message;
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
    
}
-(void)reasonChoose:(UIGestureRecognizer*)gestureRecognizer{
    
    // [self.picker show];
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.jhNavView.hidden = YES;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.dataArray =self.reasonArr;
    vc.titleString = @"选择退款理由";
    @weakify(self);
    vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString * _Nonnull code) {
        @strongify(self);
        self.returnReson = code;
        _reasonDesc.text=message;
    };
    [self.viewController presentViewController:vc animated:YES completion:nil];
    
}
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    _reasonDesc.text=self.dataList[selectedIndex].label;
    self.returnReson=self.dataList[selectedIndex].value;
}
- (void)addPhotos{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:photoMaxCount-self.allPhotos.count delegate:self];
        
        MJWeakSelf
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos) {
                [self.camaraPhotos removeAllObjects];
                for (UIImage * image in photos) {
                    OrderPhotoMode * mode=[[OrderPhotoMode alloc]init];
                    mode.image=image;
                    [weakSelf.camaraPhotos addObject:mode];
                }
                [weakSelf uploadImage];
            }
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
        
        
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
            
            [self.viewController presentViewController:picker animated:YES completion:nil];
        }else {
            NSLog(@"模拟器");
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.camaraPhotos removeAllObjects];
    OrderPhotoMode * mode=[[OrderPhotoMode alloc]init];
    mode.image=image;
    [self.camaraPhotos addObject:mode];
    [self uploadImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage{
    
    if ([self.camaraPhotos count]<=0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        [self.camaraPhotos enumerateObjectsUsingBlock:^(OrderPhotoMode * _Nonnull mode, NSUInteger idx, BOOL * _Nonnull stop) {
            if(mode.url){
                return;
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_group_enter(group);
            NOSFormData * data = [[NOSFormData alloc]init];
            data.fileImage =mode.image;
            data.fileDir = @"order_comment";
            [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
                mode.url=respondObject.data;
                
            } failureBlock:^(RequestModel *respondObject) {
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
                [self makeToast:respondObject.message];
            }];
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"完成!");
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
            [self.allPhotos addObjectsFromArray:self.camaraPhotos];
            [self makePhotoView];
        });
    });
}
//-(void)setReasonArr:(NSArray *)reasonArr{
//
//    _reasonArr=reasonArr;
//    self.dataList = [JHOrderReturnReasonMode mj_objectArrayWithKeyValuesArray:_reasonArr];
//    NSMutableArray *muArray = [NSMutableArray array];
//    for (JHOrderReturnReasonMode* mode in self.dataList) {
//        [muArray addObject:mode.label];
//    }
//    self.picker.arrayData = muArray;
//
//}
-(void)commit {
    
    if (self.returnReson.length<=0) {
        [self makeToast:@"请选择申请原因"];
        return;
    }
    
    if (self.produtStatus.length<=0) {
        [self makeToast:@"请选择货物状态"];
        return;
    }
    
    if (noteTextview.text.length<=0) {
        [self makeToast:@"请填写描述"];
        return;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    NSMutableArray * arr=[NSMutableArray array];
   // NSMutableString * str = [NSMutableString stringWithCapacity:10];
    for (OrderPhotoMode * mode  in self.allPhotos) {
          [arr addObject:mode.url];
       // [str appendFormat:@"%@,", mode.url];
    }
    [dic setObject:self.orderId forKey:@"orderId"];
    [dic setObject:self.workOrderId forKey:@"workOrderId"];
    [dic setObject:arr forKey:@"images"];
    
    if (noteTextview.text.length>0) {
        [dic setObject:noteTextview.text forKey:@"problemDesc"];
    }
    [dic setObject:self.returnReson forKey:@"applyReason"];
    [dic setObject:self.produtStatus forKey:@"cargoStatus"];
    
    if (self.completeBlock) {
        self.completeBlock(dic);
    }
}

//-(void)setOrderMode:(OrderMode *)orderMode{
//
//    _orderMode=orderMode;
//    _orderCode.text=[NSString stringWithFormat:@"订单号:%@",orderMode.orderCode];
//    [_productImage jhSetImageWithURL:[NSURL URLWithString: ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
//    _productTitle.text=_orderMode.goodsTitle;
//    _orderTime.text=_orderMode.orderCreateTime;
//    NSString * string=[NSString stringWithFormat:@"订单总额  ¥%@",_orderMode.originOrderPrice];
//    NSRange  range1 =[string rangeOfString:@"订单总额"];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
//    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range1];
//    [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range1];
//    _productPrice.attributedText=attString;
//
//    _serviceCash.text=[NSString stringWithFormat:@"-¥%@",orderMode.orderPrice];
//    _returnCash.text=[NSString stringWithFormat:@"¥%@",orderMode.orderPrice];
//
//}
#pragma mark =============== delegate ===============
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [titleTip setHidden:NO];
    }else{
        [titleTip setHidden:YES];
    }
    if (textView.text.length > 200){
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
    }
    
    _textCount.text=[NSString stringWithFormat:@"%ld/200",textView.text.length];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end

