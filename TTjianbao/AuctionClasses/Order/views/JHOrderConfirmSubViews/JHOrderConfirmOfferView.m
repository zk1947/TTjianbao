//
//  JHOrderConfirmOfferView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmOfferView.h"

@implementation JHOrderConfirmOfferView

-(void)initOfferSubViews:(NSArray*)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
        title.textColor=kColor333;
        title.font=[UIFont systemFontOfSize:13.f];
        title.text=item.title;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor333;
        desc.font=[UIFont systemFontOfSize:14.f];
        desc.text=item.value;;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        if (i==[titles count]-2) {
            title.font=[UIFont fontWithName:kFontMedium size:13];
            desc.textColor=kColorMainRed;
            desc.font=[UIFont systemFontOfSize:15.f];
            UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"]];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(title);
                make.left.equalTo(title.mas_right).offset(5);
            }];
        }
        if (i==[titles count]-1) {
            title.textColor=kColor999;
            title.font=[UIFont systemFontOfSize:13.f];
        }
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
        }];
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i<=[titles count]-2) {
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
        //箭头线
//        if (i==[titles count]-2) {
//            UIImageView *indicator=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"orderConfirm_tip_line"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 200, 0,0) resizingMode:UIImageResizingModeStretch]];
//            indicator.contentMode = UIViewContentModeScaleToFill;
//            [view addSubview:indicator];
//            [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(view).offset(15);
//                make.bottom.equalTo(view.mas_bottom).offset(0);
//                make.right.equalTo(view).offset(0);
//                make.height.offset(6);
//
//            }];
//        }
        
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
-(NSMutableArray *)handleOfferData:(JHStoneIntentionInfoModel*)mode andConfirmDetailMode:(JHOrderDetailMode*)detailMode{
    NSMutableArray * titles=[NSMutableArray array];
       if (mode.offerPrice) {
           JHItemMode * item =[[JHItemMode alloc]init];
           item.title=@"出价金额";
           item.value=[@"¥ " stringByAppendingString:mode.offerPrice?:@"0"];
           [titles addObject:item];
       }
       if (mode.intentionPrice) {
           JHItemMode * item =[[JHItemMode alloc]init];
           NSString *rate = @"";
           if (detailMode.orderCategoryType == JHOrderCategoryResaleIntentionOrder||detailMode.orderCategoryType == JHOrderCategoryResaleOrder) {
               rate = @"10%";
           } else if (detailMode.orderCategoryType == JHOrderCategoryRestoreIntention||detailMode.orderCategoryType == JHOrderCategoryRestore) {
               rate = @"5%";
           }
           item.title=[NSString stringWithFormat:@"意向金(出价价格*%@)", rate];
           item.value=[@"¥ " stringByAppendingString:mode.intentionPrice?:@"0"];
           [titles addObject:item];
       }
       if (mode.serviceCostPrice) {
           JHItemMode * item =[[JHItemMode alloc]init];
           item.title=@"平台服务费(商品价格*5%)";
           item.value=[@"¥ " stringByAppendingString:mode.serviceCostPrice?:@"0"];
           [titles addObject:item];
       }
       if (detailMode.orderPrice) {
           JHItemMode * item =[[JHItemMode alloc]init];
           item.title=@"应付金额";
           item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(detailMode.orderPrice)];
           [titles addObject:item];
       }
       if (mode.intentionPrice&&[mode.intentionPrice floatValue]>0.) {
           JHItemMode * item =[[JHItemMode alloc]init];
           item.title=@"应付金额=出价金额-意向金+平台服务费";
           item.value=@"";
           [titles addObject:item];
       }
       //一口价订单没有意向金
       else{
           JHItemMode * item =[[JHItemMode alloc]init];
           item.title=@"应付金额=商品金额+平台服务费";
           item.value=@"";
           [titles addObject:item];
       }
    
    return titles;
}

-(NSMutableArray *)handleCustomizeOfferData:(JHOrderDetailMode*)detailMode{
    
    NSMutableArray * titles=[NSMutableArray array];
      
    if (detailMode.orderCategoryType == JHOrderCategoryCustomizedIntentionOrder) {
        if (detailMode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"应付金额";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(detailMode.orderPrice)];
            [titles addObject:item];
        }
        
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"应付金额=意向金";
        item.value=@"";
        [titles addObject:item];
    }
   else if (detailMode.orderCategoryType == JHOrderCategoryCustomizedOrder) {
        if (detailMode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"应付金额";
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(detailMode.orderPrice)];
            [titles addObject:item];
        }
        
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"应付金额=服务金+材料费";
        item.value=@"";
        [titles addObject:item];
    }
    
    return titles;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
