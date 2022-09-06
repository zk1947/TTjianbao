//
//  JHOrderDeductionView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderDeductionView.h"

@implementation JHOrderDeductionView
-(void)initDeductionSubViews:(NSArray*)titles{
    
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
        title.numberOfLines = 2;
        title.textColor=kColor999;
        title.font=[UIFont fontWithName:kFontNormal size:13];
        title.text=item.title;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        UILabel  *desc=[[UILabel alloc]init];
        desc.backgroundColor=[UIColor clearColor];
        [desc setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        desc.numberOfLines = 1;
        desc.textColor=kColor999;
        desc.font=[UIFont fontWithName:kFontNormal size:13];
        desc.text=item.value;;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:desc];
        
        if (i==[titles count]-2) {
            title.textColor=kColor333;
            title.font=[UIFont fontWithName:kFontMedium size:13];
            desc.textColor=kColorMainRed;
            desc.font=[UIFont fontWithName:kFontBoldDIN size:13];
            if (item.valueColor) {
                desc.textColor=item.valueColor;
                desc.font=[UIFont fontWithName:kFontNormal size:13];
            }
            UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"]];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(title);
                make.left.equalTo(title.mas_right).offset(5);
            }];
        }
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.equalTo(view).offset(15);;
            make.bottom.equalTo(view).offset(-15);
        }];
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(view);
            make.right.equalTo(view.mas_right).offset(-10);
        }];
        
        if (i==[titles count]-1) {
            title.textColor=kColor999;
            title.font=[UIFont systemFontOfSize:13.f];
            
            //最后一行是公式，可能需要换行
            [title mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(15);
                make.right.equalTo(view).offset(-15);
                make.top.equalTo(view).offset(15);;
                make.bottom.equalTo(view).offset(-15);
            }];
        }
        
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
            //  make.height.offset(47);
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

-(NSMutableArray *)handleProcessDeductionwData:(JHOrderDetailMode*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    if ([mode.sellerDiscountAmount doubleValue]>0) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"代金券";
        item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.sellerDiscountAmount)];
        [titles addObject:item];
    }
    if ([mode.discountAmount doubleValue]>0) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"红包";
        item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.discountAmount)];
        [titles addObject:item];
    }
    if ([mode.discountCouponAmount doubleValue]>0) {
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=@"折扣活动";
        item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.discountCouponAmount)];
        [titles addObject:item];
    }
    
    JHItemMode * item1 =[[JHItemMode alloc]init];
    item1.title= @"优惠后金额" ;
    item1.value=[@"¥ " stringByAppendingString:mode.priceAfterDiscount?:@""];
    item1.valueColor = kColor333;
    [titles addObject:item1];
    
    JHItemMode * item =[[JHItemMode alloc]init];
    item.title=@"优惠后金额=宝贝价格-红包-代金券-折扣活动";
    [titles addObject:item];
    
    return  titles;
    
}

-(NSMutableArray *)handleDeductionwData:(JHOrderDetailMode*)mode{
    
    NSString * preString = @"实付";
    if ([mode.orderStatus isEqualToString:@"waitack"]||
        [mode.orderStatus isEqualToString:@"waitpay"]||
        [mode.orderStatus isEqualToString:@"cancel"]) {
        preString=@"应付";
    }
    
    NSMutableArray * titles=[NSMutableArray array];
    
    //原石回血单 涉及出价 和服务费
    if (mode.orderCategoryType==JHOrderCategoryRestore) {
        if (mode.offerPrice&&[mode.offerPrice floatValue]>0.) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"出价金额";
            item.value=[@"¥ " stringByAppendingString:mode.offerPrice?:@"0"];
            [titles addObject:item];
        }
        if (mode.intentionPrice&&[mode.intentionPrice floatValue]>0.) {
            JHItemMode * item =[[JHItemMode alloc]init];
            NSString *rate = @"";
            if (mode.orderCategoryType == JHOrderCategoryResaleIntentionOrder||mode.orderCategoryType == JHOrderCategoryResaleOrder) {
                rate = @"10%";
            } else if (mode.orderCategoryType == JHOrderCategoryRestoreIntention||mode.orderCategoryType == JHOrderCategoryRestore) {
                rate = @"5%";
            }
            item.title=[NSString stringWithFormat:@"意向金(出价价格*%@)", rate];
            item.value=[@"-¥ " stringByAppendingString:mode.intentionPrice?:@"0"];
            [titles addObject:item];
        }
        if (mode.serviceCostPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"平台服务费(商品价格*5%)";
            item.value=[@"¥ " stringByAppendingString:mode.serviceCostPrice?:@"0"];
            [titles addObject:item];
        }
        
        if (mode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额"];
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.orderPrice)];
            [titles addObject:item];
        }
        if (mode.intentionPrice&&[mode.intentionPrice floatValue]>0.) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额=出价金额-意向金+平台服务费"];
            item.value=@"";
            [titles addObject:item];
        }
        //一口价订单没有意向金
        else{
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额=商品金额+平台服务费"];
            item.value=@"";
            [titles addObject:item];
        }
    }
    //个人转售订单
    else  if (mode.orderCategoryType==JHOrderCategoryResaleOrder) {
        if (mode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额"];
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.orderPrice)];
            [titles addObject:item];
        }
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=[preString stringByAppendingString:@"金额=商品金额"];
        item.value=@"";
        [titles addObject:item];
    }
    
    //定制意向金订单
    else if (mode.orderCategoryType==JHOrderCategoryCustomizedIntentionOrder) {
        if (mode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额"];
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.orderPrice)];
            [titles addObject:item];
        }
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=[preString stringByAppendingString:@"金额=意向金"];
        item.value=@"";
        [titles addObject:item];
    }
    
    //定制服务单
    else  if (mode.orderCategoryType==JHOrderCategoryCustomizedOrder) {
        if (mode.orderPrice) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=[preString stringByAppendingString:@"金额"];
            item.value=[@"¥ " stringByAppendingString:OBJ_TO_STRING(mode.orderPrice)];
            [titles addObject:item];
        }
        JHItemMode * item =[[JHItemMode alloc]init];
        item.title=[preString stringByAppendingString:@"金额=服务金+材料费"];
        item.value=@"";
        [titles addObject:item];
    }
    
    else{
        
        if (mode.orderCategoryType!=JHOrderCategoryRestoreProcessing&&
            mode.orderCategoryType!=JHOrderCategoryProcessingGoods&&
            mode.orderCategoryType!=JHOrderCategoryProcessing) {
            
            if ([mode.sellerDiscountAmount doubleValue]>0) {
                JHItemMode * item =[[JHItemMode alloc]init];
                item.title=@"代金券";
                item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.sellerDiscountAmount)];
                [titles addObject:item];
            }
            if ([mode.discountAmount doubleValue]>0) {
                JHItemMode * item =[[JHItemMode alloc]init];
                item.title=@"红包";
                item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.discountAmount)];
                [titles addObject:item];
            }
            if ([mode.discountCouponAmount doubleValue]>0) {
                
                if (![self.orderCategory isEqualToString:@"mallAuctionOrder"]) {
                    JHItemMode * item =[[JHItemMode alloc]init];
                    item.title=@"折扣活动";
                    item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.discountCouponAmount)];
                    [titles addObject:item];
                }
                
            }
            
        }
        
        if ([mode.bountyAmount doubleValue]>0) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"津贴";
            item.value=[@"- ¥ " stringByAppendingString:OBJ_TO_STRING(mode.bountyAmount)];
            [titles addObject:item];
        }
        
        if ([mode.freight doubleValue]>0) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"跨境运费";
            item.value=[@"+ ¥ " stringByAppendingString:OBJ_TO_STRING(mode.freight)];
            [titles addObject:item];
        }
        
        if ([mode.taxes doubleValue]>0) {
            JHItemMode * item =[[JHItemMode alloc]init];
            item.title=@"税费";
            item.value=[@"+ ¥ " stringByAppendingString:OBJ_TO_STRING(mode.taxes)];
            [titles addObject:item];
        }
        
        
        
        JHItemMode * item1 =[[JHItemMode alloc]init];
        item1.title=[preString stringByAppendingString:@"金额"];
        item1.value=[@"¥ " stringByAppendingString:mode.orderPrice?:@""];
        [titles addObject:item1];
        
        JHItemMode * item =[[JHItemMode alloc]init];
        item.value=@"";
        [titles addObject:item];
        //普通加工单
        if (mode.orderCategoryType==JHOrderCategoryProcessing) {
            item.title=[preString stringByAppendingString:@"金额=宝贝价格优惠后金额+加工费-津贴"];
        }
        //加工单
        else if (mode.orderCategoryType==JHOrderCategoryRestoreProcessing||
                 mode.orderCategoryType==JHOrderCategoryProcessingGoods) {
            item.title=[preString stringByAppendingString:@"金额=宝贝价格优惠后金额+加工费-津贴"];;
        }
        else  if (mode.orderCategoryType==JHOrderCategoryLimitedTime) {
            item.title=[preString stringByAppendingString:@"金额=宝贝价格-津贴"];;
        }
        else  if (mode.orderCategoryType==JHOrderCategoryMallOrder) {
            item.title=[preString stringByAppendingString:@"金额=宝贝价格-红包-代金券-津贴"];
        }
        else{
            if ([self.orderCategory isEqualToString:@"mallAuctionOrder"]) {
                item.title=[preString stringByAppendingString:@"金额=宝贝价格-津贴"];
            }else{
                item.title=[preString stringByAppendingString:@"金额=宝贝价格-红包-代金券-折扣活动-津贴"];;
            }
        }
        
        //税费运费
        if(mode.taxes.doubleValue>0||
           mode.freight.doubleValue>0){
            item.title=[NSString stringWithFormat:@"%@%@",item.title,@"+跨境运费+税费"];
        }
    }
    
    
    return  titles;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
