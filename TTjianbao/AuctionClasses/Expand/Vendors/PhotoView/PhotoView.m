//
//  PhotoView.m
//  仿Pinterest首页
//
//  Created by 徐茂怀 on 16/5/31.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "PhotoView.h"
#import "UIImageView+JHWebImage.h"
#import "JHAudienceCommentMode.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"

//#define ScreenH     ([[UIScreen mainScreen] bounds].size.height)
//#define ScreenW      ([[UIScreen mainScreen] bounds].size.width)
@interface PhotoView   ()<UIScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *scrollArr;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) UILabel *pageLabel;
@property (strong, nonatomic) UIImageView *bottomView;
@end

@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _scrollView = [[UIScrollView alloc]init];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)initWithPicArray:(NSMutableArray *)array picNo:(NSInteger)number placeholderImage:(UIImage*)defaultImage;
{
    self.pageIndex=number;
    _dataArr = [NSMutableArray arrayWithArray:array];
    _scrollArr = [NSMutableArray array];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    _scrollView.pagingEnabled = YES;
    
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
   
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.delegate=self;
    _scrollView.contentSize = CGSizeMake(array.count * ScreenW, 1);
    _scrollView.contentOffset = CGPointMake(ScreenW * number, 0);
    [self addSubview:_scrollView];
    for (NSInteger i = 0; i < _dataArr.count; i++) {
      //  ProductDetailPhotoMode *model = _dataArr[i];
        UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(ScreenW * i, 0, ScreenW, ScreenH)];
        scroller.delegate = self;
        scroller.minimumZoomScale = 1.0;
        scroller.maximumZoomScale = 1.5;
        _scrollView.backgroundColor=[UIColor clearColor];
       
        [_scrollArr addObject:scroller];
        [_scrollView addSubview:scroller];
      
       
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor=[UIColor clearColor];
        imageView.tag = 1;
        
//        float scaleHeight = self.width/defaultImage.size.width * defaultImage.size.height;
//        imageView.frame = CGRectMake(0, (self.height - scaleHeight)/2 ,self.width,scaleHeight);
        
     __block  UIActivityIndicatorView *activityIndicator=[UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = imageView.center;
        [imageView addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
        
        if ([_dataArr[i] isKindOfClass:[NSString class]]) {
            [imageView jhSetImageWithURL:[NSURL URLWithString:_dataArr[i]] placeholder:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
            }];

        }else if ([_dataArr[i] isKindOfClass:[UIImage class]]) {
            imageView.image = _dataArr[i];
            
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;

            
        }
        
        [scroller addSubview:imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        [scroller addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [scroller addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    self.pageControl = [[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
     //[self.pageControl setValue:[UIImage imageNamed:@"椭圆-8-副本-2"] forKeyPath:@"pageImage"];
     //[self.pageControl setValue:[UIImage imageNamed:@"圆角矩形-34"] forKeyPath:@"currentPageImage"];
     self.pageControl.numberOfPages = [array count];
//    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1.00f green:0.40f blue:0.40f alpha:1.00f];
//    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
     [self.pageControl setCurrentPage:number];
      self.pageControl.hidesForSinglePage=YES;
     [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.centerX.equalTo(self);
        make.width.equalTo(self );
        make.height.offset(40 );
    }];
    
    [self.pageControl setHidden:YES];
    
    _pageLabel=[[UILabel alloc]init];
    _pageLabel.font=[UIFont systemFontOfSize:15];
    _pageLabel.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    _pageLabel.numberOfLines = 1;
    _pageLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    _pageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_pageLabel];
    
    
    
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (UI.bottomSafeAreaHeight>0) {
             make.top.equalTo(self).offset(UI.statusBarHeight);
        }
        else{
            make.top.equalTo(self).offset(20);
        }
        make.centerX.equalTo(self);
        make.width.equalTo(self );
        make.height.offset(44);
    }];
    if (self.dataArr.count>1) {
           self.pageLabel.attributedText = [[NSString stringWithFormat:@"%ld/%ld",(long)number+1,self.dataArr.count] attributedShadow];
    }
    
}

#pragma mark - 代理方法
/*
 当scrollView进行滚动的时候，调用的方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==_scrollView) {
        CGFloat scorllW = scrollView.frame.size.width;
         int page = (scrollView.contentOffset.x + scorllW * 0.5) / scorllW;
        [self.pageControl setCurrentPage:page];
         self.pageLabel.attributedText = [[NSString stringWithFormat:@"%ld/%ld",(long)page+1,self.dataArr.count] attributedShadow];;
    }
}
-(void)singleTap:(UITapGestureRecognizer *)tap{

      [self removeFromsuper];
}
//双击放大或者缩小
-(void)tapToZoom:(UITapGestureRecognizer *)tap
{
    UIScrollView *zoomable = (UIScrollView*)tap.view;
    if (zoomable.zoomScale > 1.0) {
        [zoomable setZoomScale:1 animated:YES];
    } else {
        float newscale=1.5;
        CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tap locationInView:tap.view]];
        NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
        [ zoomable zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
        [zoomable setZoomScale:newscale animated:YES];//以原先中心为点向外扩
    }
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {//传入缩放比例和手势的点击的point返回<span style="color:#ff0000;">缩放</span>后的scrollview的大小和X、Y坐标点

    CGRect zoomRect;

    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [_scrollView frame].size.height / scale;
    zoomRect.size.width  = [_scrollView frame].size.width  / scale;

    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    //    zoomRect.origin.x=center.x;
    //    zoomRect.origin.y=center.y;
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);

    return zoomRect;
}
#pragma mark 缩放停止
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"缩放停止    %.2f", scale);
}

#pragma mark 缩放所对应的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        UIImageView *imageView = [scrollView viewWithTag:1];
        return imageView;

    }
    return nil;
}


-(void)removeFromsuper
{
     NSInteger i =   _scrollView.contentOffset.x / ScreenW;
    
    if (self.pageIndex==i) {
        
        [_scrollView removeFromSuperview];
        [self removeFromSuperview];
    }
    else{
    
            [UIView animateWithDuration:0.5 animations:^(){
                _scrollView .alpha=0;
                self .alpha=0;
        
            } completion:^(BOOL finished){
        
                [_scrollView removeFromSuperview];
                [self removeFromSuperview];
            }];

    }
    
    if ([self.removeDelegate respondsToSelector:@selector(didremovePicture:)]) {
        [self.removeDelegate didremovePicture:i];
    }
}

-(void)deletePhoto
{
    NSInteger i =   _scrollView.contentOffset.x / ScreenW;
    
    UIScrollView *scroll = _scrollArr[i];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = scroll.frame;
        frame.origin.y -= ScreenH;
        scroll.frame = frame;
    } completion:^(BOOL finished) {
         [scroll removeFromSuperview];
    }];
    [_scrollArr removeObjectAtIndex:i];
    [_dataArr removeObjectAtIndex:i];
    [self.removeDelegate deletePicture:_dataArr];
    if (i == _dataArr.count) {
        //最后的一页
    } else {
        //右边的依次往左移动一页
        for (NSInteger j = i ; j < _dataArr.count; j ++) {
            [UIView animateWithDuration:0.5 animations:^{
                UIScrollView *scroll = _scrollArr[j];
                CGRect frame=scroll.frame;
                frame.origin.x -= ScreenW;
                scroll.frame=frame;
            }];
        }
    }
    if (_dataArr.count == 0) {
        [_scrollView removeFromSuperview];
        [self.removeDelegate didremovePicture:i];
        [self removeFromSuperview];
    }
    _scrollView.contentSize = CGSizeMake((_dataArr.count ) * ScreenW, 1);
}

-(void)setAudienceCommentMode:(JHAudienceCommentMode *)audienceCommentMode{
    
    _audienceCommentMode=audienceCommentMode;
    if (_audienceCommentMode) {
         [self initBottomView];
    }
}
-(void)initBottomView{
    
    _bottomView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"comment_photoback"]];
   // _bottomView.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:_bottomView];
    _bottomView.userInteractionEnabled=YES;
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        make.height.offset(ScreenW*300/750);
    }];
    
    UIImageView *headImage=[[UIImageView alloc]init];
    headImage.layer.masksToBounds =YES;
    headImage.layer.cornerRadius =17;
    headImage.userInteractionEnabled=YES;
    [_bottomView addSubview:headImage];
    [headImage jhSetImageWithURL:[NSURL URLWithString:self.audienceCommentMode.customerImg] placeholder:kDefaultAvatarImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_bottomView).offset(10);
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.left.offset(10);
    }];
    
    UILabel* name=[[UILabel alloc]init];
    name.text=self.audienceCommentMode.customerName;
    name.font=[UIFont systemFontOfSize:13];
    name.textColor=[UIColor whiteColor];
    name.numberOfLines = 1;
    name.textAlignment = UIControlContentHorizontalAlignmentCenter;
    name.lineBreakMode = NSLineBreakByWordWrapping;
    [_bottomView addSubview:name];
    
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImage).offset(-8);
        make.left.equalTo(headImage.mas_right).offset(7);
    }];
    
    UIView * starView=[[UIView alloc]init];
    [_bottomView addSubview:starView];
    
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).offset(5);
        make.left.equalTo(headImage.mas_right).offset(7);
    }];
    
    UIButton * lastButton ;
    NSInteger count =5;
    for (int i=0; i<count; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i;
        [button setImage:[UIImage imageNamed:@"comment_star"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"comment_star_kong"] forState:UIControlStateNormal];
        [starView addSubview:button];
        if (i<self.audienceCommentMode.pass) {
            button.selected=YES;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(starView);
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.bottom.equalTo(starView);
            if (i==0) {
                make.left.equalTo(starView).offset(0);
            }
            else{
                make.left.equalTo(lastButton.mas_right).offset(3);
            }
            if (i==count-1) {
                make.right.equalTo(starView);
            }
        }];
        
        lastButton=button;
    }
    
    UITextView* textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.text=self.audienceCommentMode.commentContent;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.textColor = [CommHelp toUIColorByStr:@"#ffffff"];
    textView.editable = NO;
    textView.scrollEnabled = YES;//滑动
    //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
    textView.userInteractionEnabled = YES; ///
    //自定义键盘
    [_bottomView addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(starView.mas_bottom).offset(5);
        make.left.equalTo(_bottomView).offset(10);;
        make.right.equalTo(_bottomView.mas_right).offset(-10);
        make.bottom.equalTo(_bottomView).offset(-10);
    }];
    
    UIButton * close=[[UIButton alloc]init];
    [close setImage:[UIImage imageNamed:@"photo_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(removeFromsuper) forControlEvents:UIControlEventTouchUpInside];
    close.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:close];
    
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_pageLabel);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.right.equalTo(self).offset(-15);
    }];
}
@end
