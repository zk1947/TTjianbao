//
//  JHCustomizeOrderButtonsView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderButtonsView.h"
#import "UIImage+JHColor.h"
#import "JHCommMenuView.h"
#import "JHQYChatManage.h"
#import "NSString+NTES.h"
@interface JHCustomizeOrderButtonsView ()
@property (nonatomic, strong) NSArray <JHCustomizeOrderButtonModel*>*buttons;
@end

@implementation JHCustomizeOrderButtonsView

-(void)setSubViews{
    
    self.layer.cornerRadius = 0;
}
-(void)setupBuyerButtons:(NSArray<JHCustomizeOrderButtonModel*>*)buttonArr{
    
    self.buttons = buttonArr;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    
    NSInteger buttonsCount = [buttonArr count]>=buttonLimitCount?buttonLimitCount:[buttonArr count];

    for (int i=0; i<buttonsCount; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonArr[i].title forState:UIControlStateNormal];
        button.tag=buttonArr[i].buttonType;
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 15.0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        
        CGSize titleSize=[buttonArr[i].title stringSizeWithFont: button.titleLabel.font];
        if (titleSize.width<49) {
            titleSize.width = 49;
        }
        
        if  (buttonArr[i].style == 1)
        {
            button.layer.borderWidth = 0;
            UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(titleSize.width+20, 30) radius:15];
            [button setBackgroundImage:nor_image forState:UIControlStateNormal];
            
        }
        else if  (buttonArr[i].style == 2) {
            button.layer.borderWidth = 0;
            [button setBackgroundColor:[UIColor clearColor]];
        }
        else{
            button.layer.cornerRadius = 15.0;
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
            button.layer.borderWidth = 0.5f;
        }
        
       
      //
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(titleSize.width+20);
            make.height.offset(30);
           // make.size.mas_equalTo(CGSizeMake(75, 30));
            make.centerY.equalTo(self);
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
//        if (button.tag==JHOrderButtonTypeComment){
//            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                                    imageTitleSpace:5];
//        }
        
        lastView= button;
    }
}
-(void)setupSellerButtons:(NSArray*)buttonArr{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIButton * lastView;
    for (int i=0; i<[buttonArr count]; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[[buttonArr objectAtIndex:i]objectForKey:@"buttonTitle"] forState:UIControlStateNormal];
        button.tag=[[[buttonArr objectAtIndex:i]objectForKey:@"buttonTag"] intValue];
        button.titleLabel.font= [UIFont systemFontOfSize:13];
        button.layer.cornerRadius = 15.0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
        button.layer.borderWidth = 0.5f;
        [button setTitleColor:kColor222 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        if(button.tag==JHOrderButtonTypeSend||
           button.tag==JHOrderButtonTypePrintCard||
           button.tag==JHOrderButtonTypeCompleteInfo) {
          [button setBackgroundColor:kColorMain];
          button.layer.borderWidth = 0;
        }
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(72, 30));
            make.centerY.equalTo(self);
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        lastView= button;
    }
}
- (void)buttonPress:(UIButton*)button{
    
    if (button.tag ==JHCustomizeOrderButtonMore) {
        JHCommMenuView * menuView = [[JHCommMenuView alloc ]init];
        [JHKeyWindow addSubview:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button.mas_top).offset(-5);
            make.left.equalTo(button).offset(20);
        }];
        NSMutableArray * arr = [NSMutableArray array];
        for (int i =buttonLimitCount; i<self.buttons.count; i++) {
            [arr addObject:self.buttons[i].title];
          }
          [menuView setDataArr:arr];
         @weakify(self);
          menuView.buttonHandle = ^(id obj) {
         @strongify(self);
            if (self.buttonHandle) {
                self.buttonHandle([NSNumber numberWithInteger:self.buttons[[obj integerValue]+buttonLimitCount].buttonType]);
            }
//              self.orderMode.customizeShowBtnVo.buttons[[obj integerValue]+buttonLimitCount].buttonType
        };
    }
    else{
        if (self.buttonHandle) {
            self.buttonHandle([NSNumber numberWithInteger:button.tag]);
        }
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
