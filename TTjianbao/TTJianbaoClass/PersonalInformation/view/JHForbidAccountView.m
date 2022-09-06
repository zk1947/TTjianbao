//
//  JHForbidAccountView.h
//  TTjianbao
//
//  Created by jiang on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
#import "JHForbidAccountView.h"
#import "BYTimer.h"
#import "JHCouponListView.h"
#import "JHMallCoponListView.h"
#import "JHOrderNOtePhotoItemView.h"
#import "TZImagePickerController.h"
#import "JHPickerView.h"
#import "JHOrderReturnMode.h"
#import "NOSUpImageTool.h"
#import "TTjianbao.h"
#import "EnlargedImage.h"
#import "OrderMode.h"
#import "MBProgressHUD.h"

@interface JHForbidAccountView ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate,STPickerSingleDelegate>
{
    UITextView *noteTextview;
    UILabel * titleTip;
    NSInteger  selectedIndex;
    
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView *productView;
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

@property (strong, nonatomic)  UILabel *desc;

@property (strong, nonatomic)  UILabel *serviceCash;
@property (strong, nonatomic)  UILabel *returnCash;

@property(nonatomic,strong) JHPickerView *picker;

@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  UIImageView *sallerHeadImage;

@property (strong, nonatomic)    UITextField  *cash;

@property (strong, nonatomic)    NSString  *returnReson;

@end
@implementation JHForbidAccountView
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
    
    // [self initProductView];
    // [self initIntroduceView];
    [self initReasonView];
    [self initOrderNote];
    [self initVoucherView];
    
    [self.contentScroll addSubview:self.completeBtn];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voucherView.mas_bottom).offset(60);
        make.height.offset(44);
        make.width.offset(300);
        make.centerX.equalTo(self.contentScroll);
        make.bottom.equalTo(self.contentScroll).offset(-20);
    }];
    
}

-(void)initProductView{
    
    _productView=[[UIView alloc]init];
    _productView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_productView];
    
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.width.offset(ScreenW);
    }];
    
    _orderCode=[[UILabel alloc]init];
    _orderCode.text=@"";
    _orderCode.font=[UIFont systemFontOfSize:13];
    _orderCode.backgroundColor=[UIColor clearColor];
    _orderCode.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _orderCode.numberOfLines = 1;
    _orderCode.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _orderCode.lineBreakMode = NSLineBreakByWordWrapping;
    _orderCode.lineBreakMode = NSLineBreakByTruncatingTail;
    [_productView addSubview:_orderCode];
    
    [_orderCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productView).offset(10);
        make.left.equalTo(_productView).offset(10);
        
    }];
    
    _productImage=[[UIImageView alloc]initWithImage:kDefaultCoverImage];
    [_productView addSubview:_productImage];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    _productImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [_productImage addGestureRecognizer:tapGesture];
    [_productView addSubview:_productImage];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderCode.mas_bottom).offset(10);
        make.left.equalTo(_orderCode);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(_productView).offset(-20);
    }];
    
    _productTitle=[[UILabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont systemFontOfSize:14];
    _productTitle.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _productTitle.numberOfLines = 2;
    _productTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productTitle];
    
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productImage).offset(5);
        make.left.equalTo(_productImage.mas_right).offset(5);
        make.right.equalTo(_productView.mas_right).offset(-5);
    }];
    
    _productPrice=[[UILabel alloc]init];
    _productPrice.text=@"";
    _productPrice.font=[UIFont fontWithName:kFontBoldDIN size:15.f];
    _productPrice.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_productPrice];
    
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productTitle.mas_bottom).offset(10);
        make.left.equalTo(_productTitle).offset(0);
    }];
    
    _orderTime=[[UILabel alloc]init];
    _orderTime.text=@"";
    _orderTime.font=[UIFont systemFontOfSize:11];
    _orderTime.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _orderTime.numberOfLines = 1;
    _orderTime.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _orderTime.lineBreakMode = NSLineBreakByWordWrapping;
    [_productView addSubview:_orderTime];
    
    [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_productImage).offset(5);
        make.left.equalTo(_productTitle).offset(0);
    }];
    
}
-(void)initReasonView{
    
    _reasonView=[[UIView alloc]init];
    _reasonView.backgroundColor=[UIColor whiteColor];
    _reasonView.userInteractionEnabled=YES;
    [_reasonView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(reasonChoose:)]];
    [self.contentScroll addSubview:_reasonView];
    
    [_reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(0);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(50);
        make.width.offset(ScreenW);
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
    title.text=@"选择理由";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
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
    _reasonDesc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _reasonDesc.lineBreakMode = NSLineBreakByWordWrapping;
    [_reasonView addSubview:_reasonDesc];
    
    [_reasonDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.right.equalTo(indicator.mas_left).offset(-10);
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

-(void)initOrderNote{
    
    _noteView=[[UIView alloc]init];
    _noteView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_noteView];
    
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reasonView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(130);
    }];
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"描述";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(10);
        make.left.equalTo(_noteView).offset(10);
    }];
    
    noteTextview=[[UITextView alloc]init];
    noteTextview.backgroundColor=[UIColor clearColor];
    noteTextview.font = [UIFont fontWithName:@"Arial" size:14.0];
    noteTextview.alpha=1.0;
    //[textview.layer setCornerRadius:5];//远角
    //textview.layer.masksToBounds = YES;
    noteTextview.layer.borderColor = [[CommHelp toUIColorByStr:@"#dddddd"] colorWithAlphaComponent:0.5].CGColor;
    noteTextview.layer.borderWidth = 1;
    noteTextview.delegate=self;
    noteTextview.autocorrectionType = UITextAutocorrectionTypeYes;
    noteTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteTextview.keyboardType = UIKeyboardTypeDefault;
    noteTextview.returnKeyType = UIReturnKeyDone;
    [_noteView addSubview:noteTextview];
    
    titleTip=[[UILabel alloc]init];
    titleTip.text=@"在此描述宝友详细的违规内容";
    titleTip.font=[UIFont systemFontOfSize:15];
    titleTip.backgroundColor=[UIColor clearColor];
    titleTip.textColor=[CommHelp toUIColorByStr:@"#999999"];
    titleTip.numberOfLines = 1;
    titleTip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    titleTip.lineBreakMode = NSLineBreakByWordWrapping;
    [noteTextview addSubview:titleTip];
    
    [titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextview).offset(6);
        make.left.equalTo(noteTextview).offset(3);
    }];
    
    [noteTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(_noteView).offset(10);
        make.right.equalTo(_noteView).offset(-10);
        make.bottom.equalTo(_noteView).offset(-10);
        
    }];
}

-(void)initVoucherView{
    
    _voucherView=[[UIView alloc]init];
    _voucherView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_voucherView];
    
    [_voucherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"违规照片（点击查看大图）";
    title.font=[UIFont systemFontOfSize:14];
    title.textColor=[CommHelp toUIColorByStr:@"#666666"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_voucherView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_voucherView).offset(10);
        make.left.equalTo(_voucherView).offset(10);
    }];
    
    _photosView=[[UIView alloc]init];
    // _photosView.backgroundColor=[UIColor redColor];
    [_voucherView addSubview:_photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.height.offset((ScreenW-20-15)/4);
        make.left.equalTo(_voucherView).offset(10);
        make.bottom.equalTo(_voucherView).offset(-10);
    }];
    [self addSubview:self.addBtn];
    
    CGFloat ww =(ScreenW-20-15)/4;
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_photosView);
        make.height.offset(ww);
        make.width.offset(ww);
        make.left.equalTo(_photosView.mas_right).offset(5);
    }];
    
    [self makePhotoView];
}

- (void)makePhotoView {
    
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    NSArray <OrderPhotoMode*>*array = self.allPhotos.copy;
    MJWeakSelf
    CGFloat ww =(ScreenW-20-15)/4;
    UIView * lastView;
    for (int i = 0; i < array.count; ++i) {
        JHOrderNOtePhotoItemView *item = [[JHOrderNOtePhotoItemView alloc] init];
        [self.photosView addSubview:item];
        //     item.backgroundColor=[CommHelp randomColor];
        item.tag = i;
        //   [item showImageUrl:array[i]];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ww);
            make.top.equalTo(self.photosView).offset(0);
            make.width.offset(ww);
            if (i==0) {
                make.left.equalTo(self.photosView).offset(0);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==array.count-1) {
                make.right.equalTo(self.photosView).offset(0);
            }
        }];
        
        [item showImageUrl:array[i].url];
        
        item.clickImageAction = ^(UIImageView *imageview) {
             NSMutableArray * arr = [NSMutableArray array];
            for (OrderPhotoMode * mode  in array) {
                [arr addObject:mode.url];
            }
       
         [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:imageview.tag result:^(NSInteger index) {
                           
            }];
        };
        item.deleteAction = ^(id sender) {
            [weakSelf.allPhotos removeObject:array[i]];
            [weakSelf makePhotoView];
        };
        lastView= item;
        
    }
    
    if (array.count>=3) {
        self.addBtn.hidden = YES;
    }else {
        self.addBtn.hidden = NO;
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
        // _completeBtn.layer.cornerRadius = 13.0;
        [_completeBtn setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
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

-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
//    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
//    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
//    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
//
//    }];
}
-(void)reasonChoose:(UIGestureRecognizer*)gestureRecognizer{
    
    [self.picker show];
    
}
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    _reasonDesc.text=self.dataList[selectedIndex].value;
    self.returnReson=self.dataList[selectedIndex].label;
}
- (void)addPhotos{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1-self.allPhotos.count delegate:self];
        
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
-(void)setReasonArr:(NSArray *)reasonArr{
    
    _reasonArr=reasonArr;
    self.dataList = [JHOrderReturnReasonMode mj_objectArrayWithKeyValuesArray:_reasonArr];
    NSMutableArray *muArray = [NSMutableArray array];
    for (JHOrderReturnReasonMode* mode in self.dataList) {
        [muArray addObject:mode.value];
    }
    self.picker.arrayData = muArray;
    
}
-(void)commit {
    
    if (self.returnReson.length<=0) {
        [self makeToast:@"请选择封禁原因"];
        return;
    }
    if (noteTextview.text.length<=0) {
        [self makeToast:@"描述宝友详细的违规内容"];
        return;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    NSMutableArray * arr=[NSMutableArray array];
    for (OrderPhotoMode * mode  in self.allPhotos) {
        [arr addObject:mode.url];
    }
    
    if (arr.count > 0) {
        [dic setObject:arr[0] forKey:@"image"];
    } else {
        [dic setObject:@"" forKey:@"image"];
    }
    [dic setObject:self.customerId forKey:@"customerId"];
    
    if (noteTextview.text.length>0) {
        [dic setObject:noteTextview.text forKey:@"mark"];
      }
     [dic setObject:self.returnReson forKey:@"reason"];
     [dic setObject:@"1" forKey:@"banFlag"];
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ForbidSuccessNotifaction object:nil];//
        [self.viewController.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}

-(void)setOrderMode:(OrderMode *)orderMode{
    
    
}

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
    if (textView.text.length > 100){
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 100)];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end


