//
//  JHCoverView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/23.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHCoverView.h"
#import "TTjianbaoHeader.h"

//上传照片最大数
#define MaxPhotos 6

@interface JHCoverView ()

@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * photoView;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UIButton * completeButton;
@end
@implementation JHCoverView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
       
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[UIColor whiteColor];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        
    }];
    
    [self initTitleView];
    [self initPhotoView];
    [self.contentScroll addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_photoView.mas_bottom).offset(50);
        make.centerX.equalTo(self.contentScroll);
           make.bottom.equalTo(self.contentScroll);
        
    }];
    
}
-(void)initTitleView{
    
    _titleView=[[UIView alloc]init];
    _titleView.backgroundColor=[UIColor clearColor];
    [self.contentScroll addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll).offset(20);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
        make.height.offset(80);
        make.width.offset(ScreenW);
        
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"请选择一张图,\n做为您直播房间入口的封面";
    title.font=[UIFont systemFontOfSize:18];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 2;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView).offset(20);
        make.left.equalTo(_titleView).offset(10);
      
    }];
    
}
-(void)initPhotoView{
    
    _photoView=[[UIView alloc]init];
    _photoView.backgroundColor=[UIColor whiteColor];
    [self.contentScroll addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(20);
        make.left.equalTo(self.contentScroll).offset(0);
        make.right.equalTo(self.contentScroll).offset(0);
     
        
    }];
    
}
-(UIButton*)completeButton{
    
    if (!_completeButton) {
        _completeButton=[UIButton new];
        _completeButton.contentMode=UIViewContentModeScaleAspectFit;
        [_completeButton setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        _completeButton.titleLabel.font=[UIFont systemFontOfSize:17];
        [_completeButton setBackgroundImage:[UIImage imageNamed:@"cover_sure"] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [_completeButton setTitle:@"设为封面" forState:UIControlStateNormal];
        
    }
    return _completeButton;
}
-(void)setPhotos:(NSArray *)photos{
    
    _photos=photos;
    
    NSInteger imageCount;
    if ([photos count]>=MaxPhotos) {
        
        imageCount=[photos count];
    }
    else{
        imageCount=[photos count]+1;
    }
    
    [_photoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger margin = 10;//设置相隔距离
    float imaWidth=(ScreenW-margin*4)/3;
    float imaHeight=imaWidth;
    UIButton * lastView ;;
    
    for (int i=0; i<imageCount; i++) {
        
         UIButton * photoImage=[[UIButton alloc]init];
         [_photoView addSubview:photoImage];
        if (i==[photos count]) {
            
            [photoImage  setImage:[UIImage imageNamed:@"cover_back"] forState:UIControlStateNormal];
            [photoImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [photoImage addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *addImage=[[UIImageView alloc]init];
            addImage.contentMode = UIViewContentModeScaleAspectFit;
            addImage.image=[UIImage imageNamed:@"cover_add"];
            [photoImage addSubview:addImage];
            
            [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(photoImage);
                make.top.equalTo(photoImage).offset(15);
            }];
            
            UILabel * title=[[UILabel alloc]init];
            title.text=@"添加封面";
            title.font=[UIFont systemFontOfSize:12];
            title.backgroundColor=[UIColor clearColor];
            title.textColor=[CommHelp toUIColorByStr:@"#333333"];
            title.numberOfLines = 1;
            title.textAlignment = UIControlContentHorizontalAlignmentCenter;
            title.lineBreakMode = NSLineBreakByWordWrapping;
            [photoImage addSubview:title];
            
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(addImage.mas_bottom).offset(5);
                make.centerX.equalTo(photoImage);
                
            }];
            
            UILabel * desc=[[UILabel alloc]init];
            desc.text=@"图片大小不超过2M";
            desc.font=[UIFont systemFontOfSize:10];
            desc.backgroundColor=[UIColor clearColor];
            desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
            desc.numberOfLines = 1;
            desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
            desc.lineBreakMode = NSLineBreakByWordWrapping;
            [photoImage addSubview:desc];
            
            [desc mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(title.mas_bottom).offset(5);
                make.centerX.equalTo(photoImage);
                
            }];
        
        }
        else{
    
            JHCoverModel  *cover=photos[i];
            [photoImage  setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [photoImage  setBackgroundImage:[UIImage imageNamed:@"cover_image_select"] forState:UIControlStateSelected];
            [photoImage addTarget:self action:@selector(photoImageSelect:) forControlEvents:UIControlEventTouchUpInside];
            photoImage.selected=NO;
            photoImage.tag=200+i;
            
            if (cover.isDefault ) {
                photoImage.selected=YES;
            }
            
            UIImageView * photo=[[UIImageView alloc]init];
            [photoImage addSubview:photo];
            
            [photo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(photoImage).offset(5);
                make.right.bottom.equalTo(photoImage).offset(-5);
                
            }];
            
            [photo jhSetImageWithURL:[NSURL URLWithString:cover.url]];
            
            UIButton * cancleImage=[[UIButton alloc]init];
            [cancleImage  setBackgroundImage:[UIImage imageNamed:@"cover_cancle"] forState:UIControlStateNormal];
            cancleImage.contentMode = UIViewContentModeScaleAspectFit;
            cancleImage.userInteractionEnabled=YES;
            [cancleImage addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
            cancleImage.tag=100+i;
            [cancleImage setHidden:YES];
            [_photoView addSubview:cancleImage];

            [cancleImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(photoImage.mas_top).offset(0);
                make.right.equalTo(photoImage.mas_right).offset(0);

            }];
        }
        
        [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(imaWidth);
            make.height.offset(imaHeight);
            
            if (i/3==0) {
                
                make.top.equalTo(_photoView.mas_top).offset(10);
            }
            else{
                
                NSInteger  rate= i/3;
                make.top.equalTo(_photoView.mas_top).offset(imaHeight*rate+10*(rate));
                
            }
            
            if (i%3 == 0) {
                make.left.offset(margin);
                
            }else{
             
                make.left.equalTo(lastView.mas_right).offset(margin);
            }
          
            if (i%3 == 2) {
                make.right.offset(-margin);
            }
            
            if (i == imageCount - 1){
                make.bottom.equalTo(_photoView).offset(-10);
            }
        }];
        
        lastView= photoImage;
    }
}
-(void)photoImageSelect:(UIButton*)button{
    
    for (UIView *view in _photoView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton * btn=(UIButton*)view;
            if (btn.tag>=200) {
                
                 btn.selected=NO;
            }
            if (btn.tag>=100&&btn.tag<200) {
                
                [btn setHidden:YES];
            }
           
        }
    }
        button.selected=YES;
        UIButton * cancleBtn=[_photoView viewWithTag:button.tag-100];
       [cancleBtn setHidden:NO];
    
    if (self.delegate) {
        [self.delegate photoImageSelect:self.photos[button.tag-200]];
    }
    
}
-(void)addPhoto:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate addPhoto];
    }
}
-(void)cancle:(UIButton*)button{
    
    if (self.delegate) {
        [self.delegate deletePhoto:self.photos[button.tag-100]];
    }
}
-(void)complete{
    
    if (self.delegate) {
        [self.delegate Complete];
    }
    
    
}
@end
