//
//  JHOrderNoteView.m
//  TTjianbao
//
//  Created by jiang on 2019/10/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderNoteView.h"
#import "JHOrderNOtePhotoItemView.h"
#import "TZImagePickerController.h"
#import "NOSUpImageTool.h"
#import "TTjianbaoHeader.h"
#import "MBProgressHUD.h"

#define photoMaxCount 6
@interface JHOrderNoteView ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>
{
      UILabel*  titleTip;
      CGFloat maxCount; //最大输入字数
      UITextView * noteTextview;
}
@property (strong, nonatomic)  UIView *photosView;
@property (strong, nonatomic)  NSMutableArray <OrderPhotoMode *>*allPhotos;
@property (nonatomic, strong) NSMutableArray *camaraPhotos;
//@property (strong, nonatomic)  UIButton *addBtn;
@property (strong, nonatomic)  UIButton *completeBtn;
@property (nonatomic, strong) UIButton *cancleBtn;

@end
@implementation JHOrderNoteView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         maxCount = 200;
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)]];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self initNoteView];
    }
    return self;
}
-(void)setOrderMode:(OrderMode *)orderMode{
    
     _orderMode=orderMode;
      noteTextview.text = self.orderMode.complementVo.remark;
    if ([noteTextview.text length] > 0) {
        [titleTip setHidden:YES];
    }
    for (NSString * url in  self.orderMode.complementVo.pics) {
        OrderPhotoMode * mode=[[OrderPhotoMode alloc]init];
        mode.url=url;
        [self.allPhotos addObject:mode];
    }
      [self makePhotoView];
}
-(void)initNoteView{
    
    UIView *  _noteView=[[UIView alloc]init];
    _noteView.backgroundColor=[UIColor whiteColor];
    _noteView.layer.cornerRadius = 4.0;
    [self addSubview:_noteView];
    
    [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(200);
        make.centerX.equalTo(self);
      //  make.height.offset(300);
        make.width.offset(300);
    }];
    
    [self  addSubview:self.cancleBtn];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteView).offset(-8);
        make.left.equalTo(_noteView.mas_right).offset(-15);
    }];
    
     UILabel  * title=[[UILabel alloc]init];
    title.text=@"完善订单信息";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_noteView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_noteView).offset(10);
        make.centerX.equalTo(_noteView).offset(02);
        make.width.equalTo(_noteView);
    }];
    
 
    
     noteTextview=[[UITextView alloc]init];
    noteTextview.backgroundColor=[UIColor clearColor];
    noteTextview.font = [UIFont fontWithName:@"Arial" size:12.0];
    noteTextview.alpha=1.0;
    noteTextview.layer.borderColor = [CommHelp toUIColorByStr:@"#eeeeee"].CGColor;
    noteTextview.layer.cornerRadius = 4.0;
    noteTextview.layer.borderWidth = 1.0;
    noteTextview.delegate=self;
    noteTextview.autocorrectionType = UITextAutocorrectionTypeYes;
    noteTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    noteTextview.keyboardType = UIKeyboardTypeDefault;
    noteTextview.returnKeyType = UIReturnKeyDone;
    [_noteView addSubview:noteTextview];
    
    [noteTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(_noteView).offset(15);
        make.right.equalTo(_noteView).offset(-15);
        make.height.offset(100);
    }];
    
    titleTip=[[UILabel alloc]init];
    titleTip.text=@"在此添加备注";
    titleTip.font=[UIFont systemFontOfSize:12];
    titleTip.backgroundColor=[UIColor clearColor];
    titleTip.textColor=[CommHelp toUIColorByStr:@"#999999"];
    titleTip.numberOfLines = 1;
    titleTip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    titleTip.lineBreakMode = NSLineBreakByWordWrapping;
    [noteTextview addSubview:titleTip];
    
    [titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextview).offset(7);
        make.left.equalTo(noteTextview).offset(5);
        make.width.equalTo(noteTextview);
    }];
    
    _photosView=[[UIView alloc]init];
   // _photosView.backgroundColor=[UIColor redColor];
     [_noteView addSubview:_photosView];
     [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteTextview.mas_bottom).offset(10);
      //  make.height.offset((300-20-15)/4);
        make.left.equalTo(_noteView).offset(10);
        make.right.equalTo(_noteView).offset(-10);
    }];
    [_noteView  addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photosView.mas_bottom).offset(20);
        make.height.offset(36);
        make.width.equalTo(@220);
        make.centerX.equalTo(_noteView);
        make.bottom.equalTo(_noteView.mas_bottom).offset(-20);
    }];

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
     CGFloat ww =(300-20-15)/4;
     UIView * lastView;
    for (int i = 0; i < array.count; ++i) {
        JHOrderNOtePhotoItemView *item = [[JHOrderNOtePhotoItemView alloc] init];
        [self.photosView addSubview:item];
      //  item.backgroundColor=[CommHelp randomColor];
        item.tag = i;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ww);
            make.width.offset(ww);
            
            if (i/4==0) {
                make.top.equalTo(self.photosView.mas_top).offset(0);
            }
            else{
                NSInteger  rate= i/4;
                make.top.equalTo(self.photosView.mas_top).offset(ww*rate+15*(rate));
            }
            if (i%4 == 0) {
                make.left.offset(0);
                
            }else{
                make.left.equalTo(lastView.mas_right).offset(5);
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
-(UIButton*)completeBtn{
    if (!_completeBtn) {
        _completeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [_completeBtn setTitle:@"提交" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font= [UIFont systemFontOfSize:15];
        _completeBtn.layer.cornerRadius = 13.0;
        [_completeBtn setBackgroundColor:[CommHelp toUIColorByStr:@"#fee100"]];
        [_completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    }
    return _completeBtn;
}
- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
       _cancleBtn=[[UIButton alloc]init];
        [_cancleBtn  setBackgroundImage:[UIImage imageNamed:@"copon_close"] forState:UIControlStateNormal];
        _cancleBtn.contentMode = UIViewContentModeScaleAspectFit;
        _cancleBtn.userInteractionEnabled=YES;
        [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
- (void)addPhotos{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:photoMaxCount-self.allPhotos.count delegate:self];
        
        MJWeakSelf
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos) {
                [weakSelf.camaraPhotos removeAllObjects];
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
-(void)commit {
    
    if (noteTextview.text.length<=0&& self.allPhotos.count<=0  ) {
        [self makeToast:@"添加备注 或者 添加照片"];
        return;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    NSMutableArray * arr=[NSMutableArray array];
    for (OrderPhotoMode * mode  in self.allPhotos) {
        [arr addObject:mode.url];
    }
      [dic setObject:self.orderMode.orderId forKey:@"orderId"];
      [dic setObject:arr forKey:@"pics"];
    
    if (noteTextview.text.length>0) {
        [dic setObject:noteTextview.text forKey:@"remark"];
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/complement") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self removeFromSuperview];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}
#pragma mark =============== delegate ===============
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
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
    if (textView.text.length > maxCount){
        textView.text = [textView.text substringWithRange:NSMakeRange(0, maxCount)];
    }
}

-(void)dismissKeyboard{
      [self endEditing:YES];
}
-(void)cancle{
    [self removeFromSuperview];
}
@end
