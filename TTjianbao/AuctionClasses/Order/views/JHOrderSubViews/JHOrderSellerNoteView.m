//
//  JHOrderSellerNoteView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderSellerNoteView.h"

@implementation JHOrderSellerNoteView

-(void)initSellerNoteSubViews{
    
      [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel  * title=[[UILabel alloc]init];
    title.text=@"商家备注";
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
        make.right.equalTo(self).offset(0);
    }];
    UILabel * note=[[UILabel alloc]init];
    note.font=[UIFont fontWithName:kFontNormal size:13];
    note.textColor=[CommHelp toUIColorByStr:@"#666666"];
    note.numberOfLines = 0;
    note.text =self.orderMode.complementVo.remark;
    note.preferredMaxLayoutWidth = ScreenW-40;
    note.textAlignment = UIControlContentHorizontalAlignmentCenter;
    note.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:note];
    [note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
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
        make.top.equalTo(note.mas_bottom).offset(0);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    if (self.orderMode.complementVo.pics.count>0) {
        [imagesScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(note.mas_bottom).offset(10);
            make.height.offset(66);
        }];
        [self initSellerNoteImages:self.orderMode.complementVo.pics view:imagesScrollView];
    }
}
-(void)initSellerNoteImages:(NSArray*)images  view:(UIScrollView*)imagesScrollView{
    UIView * lastView;
    for (int i=0; i<images.count; i++) {
        UIImageView * view=[[UIImageView alloc]init];
        // view.backgroundColor=[CommHelp randomColor];
        view.contentMode=UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds =YES;
        [view jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(images[i])]];
        [imagesScrollView addSubview:view];
        view.tag=i;
        view.userInteractionEnabled=YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noteImageTap:)];
        [view addGestureRecognizer:tapGesture];
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
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:self.orderMode.complementVo.pics];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:imageview.tag result:^(NSInteger index) {
        
    }]; //使用
}

-(void)initCustomizeSellerNoteSubViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel  * title=[[UILabel alloc]init];
    title.text=@"老师备注";
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
        make.right.equalTo(self).offset(0);
    }];
    UILabel * note=[[UILabel alloc]init];
    note.font=[UIFont fontWithName:kFontNormal size:13];
    note.textColor=[CommHelp toUIColorByStr:@"#666666"];
    note.numberOfLines = 0;
    note.text =self.customizeOrderMode.customizeRemark;
    note.preferredMaxLayoutWidth = ScreenW-40;
    note.textAlignment = UIControlContentHorizontalAlignmentCenter;
    note.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:note];
    [note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
