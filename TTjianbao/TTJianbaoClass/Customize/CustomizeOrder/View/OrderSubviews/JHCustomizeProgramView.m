//
//  JHCustomizeProgramView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeProgramView.h"
#import "JHCustomizeProgramInfoView.h"
#import "JHCustomizeOrderIndicateView.h"
#import "JHCustomizeAddProgramViewController.h"

#define   LimitCount 2
@interface JHCustomizeProgramView ()
@property (nonatomic, strong) UIView * listContentView;
@property (nonatomic, strong) UIButton * moreBtn;
@end


@implementation JHCustomizeProgramView
-(void)setSubViews{
    
}
-(void)initCustomizeProgramViews{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel  * title=[[UILabel alloc]init];
    title.text=@"定制方案信息";
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
        make.right.equalTo(self).offset(0);
    }];
    
    if (self.isSeller&&self.orderMode.customizeType!=1&&(
        self.orderMode.customizeOrderStatusType==
          JHCustomizeOrderStatusCustomizerPlanning||
       self.orderMode.customizeOrderStatusType ==JHCustomizeOrderStatusWaitCustomerAckPlan||
       self.orderMode.customizeOrderStatusType == JHCustomizeOrderStatusCustomizing
       ))
    {
        JHCustomizeOrderIndicateView * indicateView = [JHCustomizeOrderIndicateView new];
        indicateView.title = @"添加";
        [self addSubview:indicateView];
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.size.mas_equalTo(CGSizeMake(120, 25));
            make.right.equalTo(self).offset(0);
        }];
        
        @weakify(self);
        indicateView.pressActionBlock = ^{
            @strongify(self);
            JHCustomizeAddProgramViewController * vc = [JHCustomizeAddProgramViewController new];
            vc.customizeOrderId = self.orderMode.customizeOrderId;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        };
    }
    
    _listContentView=[[UIView alloc]init];
    [self addSubview:_listContentView];
    
    [_listContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(title.mas_bottom).offset(0);
        make.right.equalTo(self);
    }];
    
    _moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"customize_indicate_zhankai"] forState:UIControlStateNormal];//
    [_moreBtn setImage:[UIImage imageNamed:@"customize_indicate_shouqi"] forState:UIControlStateSelected];//
    [_moreBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_moreBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_moreBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
    _moreBtn.titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
    [_moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    [_moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                              imageTitleSpace:5];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_listContentView.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(0, 0));
        make.bottom.equalTo(self).offset(-10);
    }];
    
    if (self.orderMode.plans.count > 0) {
        [_listContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(10);
        }];
    }
    if (self.orderMode.plans.count>LimitCount) {
        [self initsections:[self.orderMode.plans subarrayWithRange:NSMakeRange(0, LimitCount)]];
        [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
    }
    else{
        [self initsections:self.orderMode.plans];
    }
    
}
-(void)initsections:(NSArray<JHCustomizeOrderPlanModel*>*)plans {
    
    [_listContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    for (int i=0; i<plans.count; i++) {
        JHCustomizeProgramInfoView * view=[[JHCustomizeProgramInfoView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        view.planMode = plans[i];
        view.orderMode = self.orderMode;
        [view initCustomizeProgramInfoViews];
        [self.listContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_listContentView);
            make.right.equalTo(_listContentView);
            if (i==0) {
                make.top.equalTo(_listContentView);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(5);
            }
            if (i==plans.count-1) {
                make.bottom.equalTo(_listContentView.mas_bottom).offset(0);
            }
        }];
        
        if (i!=[plans count]-1) {
            UIView * line=[[UIView alloc]init];
            line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(10);
                make.bottom.equalTo(view.mas_bottom).offset(0);
                make.right.equalTo(view).offset(0);
                make.height.offset(1);
            }];
        }
        lastView=view;
    }
    
}
-(void)btnAction:(UIButton*)button{
    
    if (!button.selected) {
        [self initsections:self.orderMode.plans];
    }
    else{
        if (self.orderMode.plans.count>LimitCount){
            [self initsections:[self.orderMode.plans subarrayWithRange:NSMakeRange(0, LimitCount)]];
        }
    }
    button.selected = !button.selected;
    
    if (self.viewHeightChangeBlock) {
        self.viewHeightChangeBlock();
    };
}
@end
