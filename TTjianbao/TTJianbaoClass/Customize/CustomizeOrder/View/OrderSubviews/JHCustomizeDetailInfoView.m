//
//  JHCustomizeDetailInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeDetailInfoView.h"
#import "JHCustomizeOrderIndicateView.h"
#import "JHOrderAppraisalVideoViewController.h"

@implementation JHCustomizeDetailInfoView
-(void)setSubViews{
    
}
-(void)initCustomizeDetailViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (1) {
        
        UILabel  * title=[[UILabel alloc]init];
        title.text=@"定制详情信息";
        title.font=[UIFont fontWithName:kFontMedium size:13];
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
        indicateView.title = [NSString stringWithFormat:@"%@",self.orderMode.picInfoVo.lastUpdateDesc];
        [self addSubview:indicateView];
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.size.mas_equalTo(CGSizeMake(ScreenW, 25));
            make.right.equalTo(self).offset(0);
        }];
        
        @weakify(self);
        indicateView.pressActionBlock = ^{
            // @strongify(self);
            
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
        [self initImages:self.orderMode.picInfoVo.attachmentVOS view:imagesScrollView];
    }
}
-(void)initImages:(NSArray<JHCustomizeOrderMediaAttachModel*>*)images   view:(UIScrollView*)imagesScrollView{
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
      //  view.backgroundColor=[CommHelp randomColor];
        view.layer.cornerRadius =8;
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds =YES;
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
    
    
    if (self.orderMode.picInfoVo.attachmentVOS[gestureRecognizer.view.tag].type == 1) {
        JHOrderAppraisalVideoViewController *vc=[[JHOrderAppraisalVideoViewController alloc]initWithStreamUrl:self.orderMode.picInfoVo.attachmentVOS[gestureRecognizer.view.tag].url];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    
    else{
        UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
        NSMutableArray * arr=[NSMutableArray array];
        for (JHCustomizeOrderMediaAttachModel *mode in self.orderMode.picInfoVo.attachmentVOS) {
            if (mode.type == 1) {
             //   [arr addObject:mode.coverUrl];
            }
            else{
                [arr addObject:mode.url];
            }
        }
        
        int index = 0 ;
        for (int i=0; i<[arr count]; i++) {
            if ([self.orderMode.picInfoVo.attachmentVOS[imageview.tag].url isEqualToString:arr[i]]) {
                index = i;
            }
        }
        
        [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:index result:^(NSInteger index) {
            
        }]; //使用
    }
}


@end
