//
//  JHCustomizeCompleteInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCompleteInfoView.h"
#import "JHCustomizeOrderIndicateView.h"
#import "JHOrderAppraisalVideoViewController.h"
#import "JHCustomizeCheckCompleteViewController.h"
@interface JHCustomizeCompleteInfoView ()

@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *sallerName;
@property(nonatomic,strong) UIView *productContentView;
@end
@implementation JHCustomizeCompleteInfoView
-(void)setSubViews{
    
}
-(void)initCustomizeCompleteInfoViews{
   
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (1) {
        
        UILabel  * title=[[UILabel alloc]init];
        title.text=@"制作完成信息";
        title.font=[UIFont fontWithName:kFontMedium size:15];
        title.backgroundColor=[UIColor whiteColor];
        title.textColor=kColor333;
        title.numberOfLines = 1;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        JHCustomizeOrderIndicateView * indicateView = [JHCustomizeOrderIndicateView new];
        indicateView.title = @"";
        [self addSubview:indicateView];
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.size.mas_equalTo(CGSizeMake(120, 25));
            make.right.equalTo(self).offset(0);
        }];
        
        @weakify(self);
        indicateView.pressActionBlock = ^{
             @strongify(self);
            JHCustomizeCheckCompleteViewController * vc = [JHCustomizeCheckCompleteViewController new];
            //TODO jiang 传参
            vc.customizeOrderId = self.orderMode.customizeOrderId;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        };
        
        UIScrollView *  imagesScrollView=[[UIScrollView alloc]init];
        imagesScrollView.showsHorizontalScrollIndicator = NO;
        imagesScrollView.showsVerticalScrollIndicator = NO;
        imagesScrollView.scrollEnabled=YES;
        imagesScrollView.alwaysBounceHorizontal = YES; // 水平
        imagesScrollView.alwaysBounceVertical = NO;
        [self addSubview:imagesScrollView];
        
        [imagesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.height.offset(0);
            make.top.equalTo(title.mas_bottom).offset(0);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        // if (self.orderMode.complementVo.pics.count>0)
        
        [imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
            make.height.offset(66);
        }];
        // [self initImages:self.orderMode.complementVo.pics view:imagesScrollView];
        [self initImages:self.orderMode.completions[0].attachmentList view:imagesScrollView];
    }
}
-(void)initImages:(NSArray<JHCustomizeOrderMediaAttachModel*>*)images  view:(UIScrollView*)imagesScrollView{
    
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
      //  view.backgroundColor=[CommHelp randomColor];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds =YES;
        view.layer.cornerRadius =8;
        view.tag=i;
        [imagesScrollView addSubview:view];
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noteImageTap:)];
        [view addGestureRecognizer:tapGesture];
        
        if (images[i].type == 1) {
            UIImageView * icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sq_rcmd_icon_video"]];
            icon.contentMode=UIViewContentModeScaleAspectFit;
            [view addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
            }];
            [view jhSetImageWithURL:[NSURL URLWithString:images[i].coverUrl] placeholder:nil];
            
        }
        else{
          
            [view jhSetImageWithURL:[NSURL URLWithString:images[i].url] placeholder:nil];
        }
        
        
        float width=65;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.height.offset(width);
            make.top.equalTo(imagesScrollView);
            if (i==0) {
                make.left.equalTo(imagesScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==images.count-1) {
                make.right.equalTo(imagesScrollView.mas_right).offset(-10);
            }
        }];
        lastView=view;
    }
}
-(void)noteImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    
    if(self.orderMode.completions[0].attachmentList[gestureRecognizer.view.tag].type == 1) {
        JHOrderAppraisalVideoViewController *vc=[[JHOrderAppraisalVideoViewController alloc]initWithStreamUrl:self.orderMode.completions[0].attachmentList[gestureRecognizer.view.tag].url];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    
    else{
        UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
        NSMutableArray * arr=[NSMutableArray array];
        for (JHCustomizeOrderMediaAttachModel *mode in self.orderMode.completions[0].attachmentList){
            if (mode.type == 1) {
             //   [arr addObject:mode.coverUrl];
            }
            else{
                [arr addObject:mode.url];
            }
        }
        int index = 0 ;
        for (int i=0; i<[arr count]; i++) {
            if ([self.orderMode.completions[0].attachmentList[imageview.tag].url isEqualToString:arr[i]]) {
                index = i;
            }
        }
        
        [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:index result:^(NSInteger index) {
            
        }]; //使用
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
