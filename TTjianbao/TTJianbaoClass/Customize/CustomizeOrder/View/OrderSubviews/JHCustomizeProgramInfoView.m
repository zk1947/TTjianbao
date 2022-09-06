//
//  JHCustomizeProgramInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeProgramInfoView.h"
#import "JHCustomizeOrderIndicateView.h"
#import "JHOrderAppraisalVideoViewController.h"
#import "JHCustomizeCheckProgramViewController.h"

@interface JHCustomizeProgramInfoView ()

@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *sallerName;
@property(nonatomic,strong) UIView *productContentView;
@end
@implementation JHCustomizeProgramInfoView
-(void)setSubViews{
    
}
-(void)initCustomizeProgramInfoViews{
    
    // self.backgroundColor=[CommHelp randomColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (1) {
        
        UILabel  * title=[[UILabel alloc]init];
        title.text=self.planMode.customizeFeeName ;
        title.font=[UIFont fontWithName:kFontMedium size:13];
        title.backgroundColor=[UIColor whiteColor];
        title.textColor=kColor333;
        title.numberOfLines = 1;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self).offset(10);
            make.height.offset(20);
        }];
        
        UILabel  * status=[[UILabel alloc]init];
        status.font=[UIFont fontWithName:kFontNormal size:13];
        status.textColor=kColorFF4200;
        status.numberOfLines = 1;
        status.textAlignment = NSTextAlignmentLeft;
        status.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:status];
        
        if (self.planMode.status == 0) {
            status.text=@"(待提交)";
        }
        else if (self.planMode.status == 1) {
            status.text=@"(待确认)";
        }
        else if (self.planMode.status == 2) {
            status.text=@"(已确认)";
        }
        else if (self.planMode.status == 3) {
            status.text=@"(拒绝)";
        }
        
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.left.equalTo(title.mas_right).offset(5);
        }];
        
        JHCustomizeOrderIndicateView * indicateView = [JHCustomizeOrderIndicateView new];
        indicateView.title = [NSString stringWithFormat:@"¥%@",self.planMode.totalPrice];
        [self addSubview:indicateView];
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.size.mas_equalTo(CGSizeMake(120, 25));
            make.right.equalTo(self).offset(0);
        }];
        
        @weakify(self);
        indicateView.pressActionBlock = ^{
            @strongify(self);
            JHCustomizeCheckProgramViewController * vc = [JHCustomizeCheckProgramViewController new];
            vc.customizePlanId = self.planMode.customizePlanId;
            vc.anchorId = self.orderMode.sellerCustomerId;
            vc.customizeOrderId = self.orderMode.customizeOrderId;
            vc.isSeller = self.orderMode.isSeller;
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
            make.top.equalTo(title.mas_bottom).offset(5);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
        
        // if (self.orderMode.complementVo.pics.count>0)
        
        [imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
            make.height.offset(66);
        }];
        // [self initImages:self.orderMode.complementVo.pics view:imagesScrollView];
        [self initImages:self.planMode.attachmentVOs view:imagesScrollView];
    }
}
-(void)initImages:(NSArray<JHCustomizeOrderMediaAttachModel*>*)images  view:(UIScrollView*)imagesScrollView{
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius =8;
        view.layer.masksToBounds =YES;
        view.tag=i;
        [imagesScrollView addSubview:view];
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
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
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    
    if (self.planMode.attachmentVOs[gestureRecognizer.view.tag].type == 1) {
        JHOrderAppraisalVideoViewController *vc=[[JHOrderAppraisalVideoViewController alloc]initWithStreamUrl:self.planMode.attachmentVOs[gestureRecognizer.view.tag].url];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    else{
        UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
        NSMutableArray * arr=[NSMutableArray array];
        for (JHCustomizeOrderMediaAttachModel *mode in self.planMode.attachmentVOs) {
            if (mode.type == 1) {
              //  [arr addObject:mode.coverUrl];
            }
            else{
                [arr addObject:mode.url];
            }
        }
        
        int index = 0 ;
        for (int i=0; i<[arr count]; i++) {
            if ([self.planMode.attachmentVOs[imageview.tag].url isEqualToString:arr[i]]) {
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
