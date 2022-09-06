//
//  JHAddPhotoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHAddPhotoView.h"
#import "JHOrderNOtePhotoItemView.h"
#import "TZImagePickerController.h"
#import "NOSUpImageTool.h"
#define photoMaxCount 6
@interface JHAddPhotoView ()< UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *photosView;

@property (nonatomic, strong) NSMutableArray *camaraPhotos;
@end
@implementation JHAddPhotoView

-(void)setSubViews{
    
      _titleLabel=[[UILabel alloc]init];
      _titleLabel.text=@"发货凭证（帮助平台验证您的宝贝）";
      _titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
      _titleLabel.backgroundColor=[UIColor clearColor];
      _titleLabel.textColor=kColor333;
      _titleLabel.numberOfLines = 1;
      _titleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
      _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
      [self addSubview:_titleLabel];
      [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self).offset(5);
          make.left.equalTo(self).offset(10);
      }];
    
    _photosView=[[UIView alloc]init];
   // _photosView.backgroundColor=[UIColor redColor];
    [self addSubview:_photosView];
    [_photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
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
    CGFloat ww =(ScreenW-20-10-15)/4;
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
                make.top.equalTo(self.photosView.mas_top).offset(ww*rate+10*(rate));
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
                make.bottom.equalTo(self.photosView).offset(0);
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
