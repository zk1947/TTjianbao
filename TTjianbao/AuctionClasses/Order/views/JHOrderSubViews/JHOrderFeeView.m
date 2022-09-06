//
//  JHOrderFeeView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderFeeView.h"
#import "JHWebViewController.h"

#define   LimitCount 1
@interface JHOrderFeeView ()
@property (nonatomic, strong) UIView * listContentView;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) NSArray *titleArr;
@end
@implementation JHOrderFeeView

-(void)initFeeSubViews:(NSArray*)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.titleArr = titles;
    
    _listContentView = [[UIView alloc]init];
    [self addSubview:_listContentView];
    
    [_listContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    _moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"customize_indicate_zhankai"] forState:UIControlStateNormal];//
     [_moreBtn setImage:[UIImage imageNamed:@"customize_indicate_shouqi"] forState:UIControlStateSelected];//
    [_moreBtn setTitle:@"展开详情" forState:UIControlStateNormal];
    [_moreBtn setTitle:@"收起详情" forState:UIControlStateSelected];
    [_moreBtn setTitleColor:kColor999 forState:UIControlStateNormal];
     _moreBtn.titleLabel.font=[UIFont fontWithName:kFontNormal size:12];
    [_moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    [_moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                              imageTitleSpace:5];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_listContentView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.bottom.equalTo(self).offset(-10);
    }];
    
    if (self.titleArr.count>LimitCount) {
       [self initFeeList:[self.titleArr subarrayWithRange:NSMakeRange(0, LimitCount)]];
        [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
               make.size.mas_equalTo(CGSizeMake(100, 30));
           }];
    }
    else{
         [self initFeeList:self.titleArr];
    }
  
}
-(void)btnAction:(UIButton*)button{
    
    if (!button.selected) {
        [self initFeeList:self.titleArr];
    }
    else{
        if (self.titleArr.count>LimitCount){
            [self initFeeList:[self.titleArr subarrayWithRange:NSMakeRange(0, LimitCount)]];
        }
    }
    button.selected = !button.selected;
    
    if (self.viewHeightChangeBlock) {
        self.viewHeightChangeBlock();
    };
    
}
-(void)initFeeList:(NSArray*)titles{
    
    [_listContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_listContentView addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor999;
        title.font=[UIFont fontWithName:kFontNormal size:13.f];
        title.text=item.title;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor999;
        desc.font=[UIFont fontWithName:kFontNormal size:13.f];
        desc.text=item.desc;
        desc.textAlignment = NSTextAlignmentLeft;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        
        
        UILabel  *value=[[UILabel alloc]init];
        value.backgroundColor=[UIColor clearColor];
        [value setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        value.numberOfLines = 1;
        value.textColor=kColor999;
        value.font=[UIFont fontWithName:kFontNormal size:13.f];
        value.text=item.value;;
        value.textAlignment = NSTextAlignmentLeft;
        value.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:value];
        if (item.mediumFont) {
            title.font=[UIFont fontWithName:kFontMedium size:13];
            title.textColor=kColor333;
            value.font=[UIFont fontWithName:kFontMedium size:13];
            value.textColor=kColor333;
        }
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).offset(5);
            make.top.bottom.equalTo(view);
        }];
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i!=[titles count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_listContentView);
            make.height.offset(47);
            if (i==0) {
                make.top.equalTo(_listContentView).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_listContentView).offset(0);
            }
            
        }];
        
        lastView= view;
    }
    
}

-(void)initTaxesFeeSubViews:(NSArray*)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_listContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor999;
        title.font=[UIFont fontWithName:kFontNormal size:13.f];
        title.text=item.title;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_payinfo_icon"]];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:icon];
        icon.tag = i+1;
        icon.userInteractionEnabled = YES;
        [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introducePress:)]];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.left.equalTo(title.mas_right).offset(5);
        }];
        
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor999;
        desc.font=[UIFont fontWithName:kFontNormal size:13.f];
        desc.text=item.desc;
        desc.textAlignment = NSTextAlignmentLeft;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        UILabel  *value=[[UILabel alloc]init];
        value.backgroundColor=[UIColor clearColor];
        [value setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        value.numberOfLines = 1;
        value.textColor=kColor999;
        value.font=[UIFont fontWithName:kFontNormal size:13.f];
        value.text=item.value;;
        value.textAlignment = NSTextAlignmentLeft;
        value.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:value];
        if (item.mediumFont) {
            title.font=[UIFont fontWithName:kFontMedium size:13];
            title.textColor=kColor333;
            value.font=[UIFont fontWithName:kFontMedium size:13];
            value.textColor=kColor333;
        }
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.top.bottom.equalTo(view);
        }];
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i!=[titles count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(47);
            if (i==0) {
                make.top.equalTo(self).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(self).offset(0);
            }
            
        }];
        
        lastView= view;
    }
  
}
-(void)initC2CTaxesFeeSubViews:(NSArray*)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_listContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        JHItemMode * item =titles[i];
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        title.numberOfLines = 1;
        title.textColor=kColor999;
        title.font=[UIFont fontWithName:kFontNormal size:13.f];
        title.text=item.title;
        title.textAlignment = NSTextAlignmentLeft;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *value=[[UILabel alloc]init];
        value.backgroundColor=[UIColor clearColor];
        [value setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        value.numberOfLines = 1;
        value.textColor=kColor999;
        value.font=[UIFont fontWithName:kFontNormal size:13.f];
        value.text=item.value;;
        value.textAlignment = NSTextAlignmentLeft;
        value.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:value];
        if (item.mediumFont) {
            title.font=[UIFont fontWithName:kFontMedium size:13];
            title.textColor=kColor333;
            value.font=[UIFont fontWithName:kFontMedium size:13];
            value.textColor=kColor333;
        }
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i!=[titles count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.offset(47);
            if (i==0) {
                make.top.equalTo(self).offset(0);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(0);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(self).offset(0);
            }
            
        }];
        
        lastView= view;
    }
  
}
-(NSMutableArray*)handleFeeData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    
    float price=[mode.manualCost floatValue]+[mode.materialCost floatValue];
    
    if (price>0) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"加工费";
        item.desc=@"（只能用津贴抵扣）";
        item.mediumFont = YES;
        NSString * string=[NSString stringWithFormat:@"%.2f",price];
        item.value=[@"¥ " stringByAppendingString:string];
        [titles addObject:item];
    }
    
    if (mode.materialCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"材料费";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.materialCost)];
        [titles addObject:item];
    }
    
    if (mode.manualCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"手工费";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.manualCost)];
        [titles addObject:item];
    }
    
    
    
    return titles;
    
}
-(NSMutableArray*)handleCustomizeFeeData:(JHOrderDetailMode*)mode{
    
      NSMutableArray * titles=[NSMutableArray array];
    
    if (mode.orderCategoryType==JHOrderCategoryCustomizedOrder){
        if (mode.manualCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"服务金";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.manualCost)];
        [titles addObject:item];
    }
        
        if (mode.materialCost) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"材料费";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.materialCost)];
        [titles addObject:item];
    }
        }
   
  else  if (mode.orderCategoryType==JHOrderCategoryCustomizedIntentionOrder){
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"意向金";
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.originOrderPrice)];
        [titles addObject:item];
     }
      
    return titles;
    
}
-(NSMutableArray*)handleTaxesFeeData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    
      if (mode.freight) {
      JHItemMode * item =[[JHItemMode alloc]init];
      item.title=@"跨境运费";
      item.desc=@"（津贴不能抵扣）";
      item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.freight)];
      [titles addObject:item];
  }
      if (mode.taxes) {
      JHItemMode * item =[[JHItemMode alloc]init];
      item.title=@"税费";
       item.desc=@"（津贴不能抵扣）";
      item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.taxes)];
      [titles addObject:item];
  }

    
  return titles;
    
}
-(NSMutableArray*)handleC2CTaxesFeeData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    JHItemMode * item =[[JHItemMode alloc]init];
    item.title=@"运费";
    if ([mode.freight intValue]>0) {
        item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.freight)];
    }
    else{
        item.value = @"包邮";
    }
    [titles addObject:item];
    
    return titles;
    
    
    
}
- (void)introducePress:(UITapGestureRecognizer *)gestureRecognizer{
   
//    if (self.introducePressBlock) {
//        self.introducePressBlock([NSNumber numberWithInteger:gestureRecognizer.view.tag]);
//    }
    if(gestureRecognizer.view.tag == 1){
         // 税费介绍url
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = H5_BASE_STRING(@"/jianhuo/app/overseas/shippingInstructions.html");
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    
  else if (gestureRecognizer.view.tag == 2) {
        
        // 运费介绍url
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = H5_BASE_STRING(@"/jianhuo/app/overseas/shippingInstructions.html");
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    };
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
