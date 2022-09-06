//
//  EnlargedImage.m
//  test
//
//  Created by test on 2017/2/4.
//  Copyright © 2017年 test. All rights reserved.
//

#import "EnlargedImage.h"
#import "PhotoView.h"
static CGRect oldRect;
static id tempImageView;
static CGFloat enlargedTime;
static EnlargedImage *enlargedimage;

@interface EnlargedImage ()<didRemovePictureDelegate>
{
    UIImageView *imageView ;
    UIView *backView;
    NSInteger photoSelectIndex;
    void(^ scrollPhotoSelect)( NSInteger index);
    
}@end
@implementation EnlargedImage


+(EnlargedImage*)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        enlargedimage=[[EnlargedImage alloc]init];
    });
    
      return enlargedimage;
    
}
- (void)enlargedImage:(UIImageView*)oldImageview enlargedTime:(CGFloat)uesTime  images:(NSMutableArray*)imageurls andIndex:(NSInteger)photoIndex result:(void (^)(NSInteger))scrollIndex;
{
    if (!oldImageview.image) {
        return;
    }
    photoSelectIndex=photoIndex;
    oldImageview.alpha = 0;
    enlargedTime = uesTime;
    tempImageView = oldImageview;
    scrollPhotoSelect=scrollIndex;
    
    UIImage *image = oldImageview.image;
    CGRect rect = [UIScreen mainScreen].bounds;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    oldRect= [oldImageview convertRect:oldImageview.bounds toView:window];
    
    backView = [[UIView alloc]initWithFrame:window.bounds];
    backView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:1.0];
    backView.alpha=1;
   
    imageView = [[UIImageView alloc]initWithFrame:oldRect];
    imageView.image = image;
    imageView.tag = 1;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    [backView addSubview:imageView];
    [window addSubview:backView];
    
    float scaleHeight = rect.size.width/oldImageview.image.size.width * oldImageview.image.size.height;
    
    [UIView animateWithDuration:enlargedTime animations:^(){
        imageView.frame = CGRectMake(0, (rect.size.height - scaleHeight)/2 ,rect.size.width,scaleHeight);
        backView.alpha = 1;
    } completion:^(BOOL flished){

        PhotoView* _photoView = [[PhotoView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        [_photoView initWithPicArray:imageurls picNo:photoIndex placeholderImage:oldImageview.image];
        _photoView.removeDelegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_photoView];
        if (self.audienceCommentMode) {
            _photoView.audienceCommentMode=self.audienceCommentMode;
        }
    }];
}

-(void)didremovePicture:(NSInteger )index{

    self.audienceCommentMode=nil;
    if (index==photoSelectIndex) {
        backView.userInteractionEnabled = NO;
        UIImageView *imageview=(UIImageView*)[backView viewWithTag:1];
        UIImageView *oldImage = tempImageView;
        
        [UIView animateWithDuration:enlargedTime animations:^(){
            imageview.frame = oldRect;
        } completion:^(BOOL finished){
            [backView removeGestureRecognizer:backView.gestureRecognizers[0]];
            oldImage.alpha = 1;
            [backView removeFromSuperview];
        }];
 
    }
    else{
        
         scrollPhotoSelect(index);
         UIImageView *oldImage = tempImageView;
         oldImage.alpha = 1;
         backView.userInteractionEnabled = NO;
         [backView removeGestureRecognizer:backView.gestureRecognizers[0]];
         [backView removeFromSuperview];
        
        
    }

    
    
}
@end
