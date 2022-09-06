//
//  JHOrderInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderInfoView.h"
#import "UIView+AddSubviews.h"

@interface JHOrderInfoView()
@property (strong, nonatomic)  UILabel *priceValue;
@end

@implementation JHOrderInfoView
-(NSMutableArray*)handleOrderData:(JHOrderDetailMode*)mode{
    
    
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.orderCode) {
        [titles addObject: [@"订单号:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCode)]];
    }
    if (mode.orderCreateTime) {
        [titles addObject: [@"下单时间:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCreateTime)]];
    }
    
    
    
    if (mode.payTime) {
        [titles addObject: [@"支付时间:  " stringByAppendingString:OBJ_TO_STRING(mode.payTime)]];
    }
    if (mode.sellerSentTime) {
        [titles addObject: [@"卖家发货:  " stringByAppendingString:OBJ_TO_STRING(mode.sellerSentTime)]];
    }
    if (mode.portalReceivedTime) {
           [titles addObject: [@"平台收货时间:  " stringByAppendingString:OBJ_TO_STRING(mode.portalReceivedTime)]];
       }
    if (mode.portalSentTime) {
        [titles addObject: [@"平台发货:  " stringByAppendingString:OBJ_TO_STRING(mode.portalSentTime)]];
    }
   return titles;
    
}

-(NSMutableArray*)handleOrderData:(JHOrderDetailMode*)mode andTag:(Boolean)tag {
    
    
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.orderCode && tag) {
        [titles addObject: [@"订单号:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCode)]];
    }
    if (mode.createTime && tag) {
        [titles addObject: [@"下单时间:  " stringByAppendingString:OBJ_TO_STRING(mode.createTime)]];
    }
    
    if (mode.payTime) {
        [titles addObject: [@"支付时间:  " stringByAppendingString:OBJ_TO_STRING(mode.payTime)]];
    }
    if (mode.sellerSentTime) {
        [titles addObject: [@"卖家发货:  " stringByAppendingString:OBJ_TO_STRING(mode.sellerSentTime)]];
    }
    if (mode.portalReceivedTime) {
           [titles addObject: [@"平台收货时间:  " stringByAppendingString:OBJ_TO_STRING(mode.portalReceivedTime)]];
       }
    if (mode.portalSentTime) {
        [titles addObject: [@"平台发货:  " stringByAppendingString:OBJ_TO_STRING(mode.portalSentTime)]];
    }
   return titles;
    
}

- (void)addTitleView {
    UILabel *priceValue = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
    priceValue.text = @"订单信息";
    
    [priceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    self.priceValue = priceValue;
}

-(void)setupOrderInfo:(NSArray*)titles{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    if(self.priceValue) {
        lastView = self.priceValue;
    }
  
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [self addSubview:view];
        
        UILabel  *title=[[UILabel alloc]init];
        title.backgroundColor=[UIColor clearColor];
        [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
        //  title.font=[UIFont systemFontOfSize:14];
        //  title.textColor=[CommHelp toUIColorByStr:@"#999999"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:title];
        
        NSRange range = [[titles objectAtIndex:i] rangeOfString:@":"];
        NSString * substring=[[titles objectAtIndex:i] substringToIndex:range.location+1];
        title.attributedText=[[titles objectAtIndex:i] attributedSubString:substring font:[UIFont systemFontOfSize:14] color:[CommHelp toUIColorByStr:@"#999999"] allColor:[CommHelp toUIColorByStr:@"#222222"] allfont:[UIFont systemFontOfSize:14] ];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.bottom.equalTo(view);
          //  make.right.equalTo(view.mas_right).offset(-10);
        }];
        if(i==0){
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"复制" forState:UIControlStateNormal];
            button.titleLabel.font= [UIFont fontWithName:kFontNormal size:11];
            button.layer.cornerRadius = 7.5;
            [button setBackgroundColor:[kColorMain colorWithAlphaComponent:0.2]];
            button.layer.borderColor = [kColorMain colorWithAlphaComponent:1].CGColor;
            button.layer.borderWidth = 0.5f;
            [button setTitleColor:kColor333 forState:UIControlStateNormal];
            [button addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(title.mas_right).offset(15);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(35, 15));
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self);
            if (i==0) {
                make.top.equalTo(self).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(self).offset(-10);
            }
            
        }];
        
        lastView= view;
    }
    
}
- (void)copyAction:(UIButton*)button{
    
    [JHKeyWindow makeToast:@"复制成功!" duration:1.0 position:CSToastPositionCenter];
      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
     pasteboard.string = self.orderMode.orderCode;
    
}

@end
