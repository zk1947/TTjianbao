//
//  JHCustomizeOrderInfoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderInfoView.h"
#define   LimitCount 4
@interface JHCustomizeOrderInfoView ()
@property (nonatomic, strong) UIView * listContentView;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation JHCustomizeOrderInfoView
-(void)handleOrderData:(JHCustomizeOrderModel*)mode{
    
    NSMutableArray * titles=[NSMutableArray array];
    if (mode.orderCode) {
        [titles addObject: [@"订单号:  " stringByAppendingString:OBJ_TO_STRING(mode.orderCode)]];
    }
    for (JHCustomizeOrderStatusLogVosModel *model in mode.orderStatusLogVos) {
        [titles addObject: [NSString stringWithFormat:@"%@:  %@",model.currentStatusName,model.createTime]];
    }

    self.titleArr = titles;
    
}

-(void)setupOrderInfo{
    
    [self handleOrderData:self.orderMode];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
    [_moreBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_moreBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_moreBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
     _moreBtn.titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
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
       [self initOrderInfoList:[self.titleArr subarrayWithRange:NSMakeRange(0, LimitCount)]];
        [_moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
               make.size.mas_equalTo(CGSizeMake(100, 30));
           }];
    }
    else{
         [self initOrderInfoList:self.titleArr];
    }
  
    
}
-(void)btnAction:(UIButton*)button{
    
    if (!button.selected) {
        [self initOrderInfoList:self.titleArr];
    }
    else{
        if (self.titleArr.count>LimitCount){
            [self initOrderInfoList:[self.titleArr subarrayWithRange:NSMakeRange(0, LimitCount)]];
        }
    }
    button.selected = !button.selected;
    
    if (self.viewHeightChangeBlock) {
        self.viewHeightChangeBlock();
    };
}
-(void)initOrderInfoList:(NSArray*)titles{
    
    [_listContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * lastView;
    for (int i=0; i<[titles count]; i++) {
        
        UIView *view=[[UIView alloc]init];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.userInteractionEnabled=YES;
        view.tag=i;
        [_listContentView addSubview:view];
        
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
        title.attributedText=[[titles objectAtIndex:i] attributedSubString:substring font:[UIFont fontWithName:kFontNormal size:12] color:kColor666 allColor:kColor666 allfont:[UIFont fontWithName:kFontNormal size:12]];
        
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
            
            make.left.right.equalTo(_listContentView);
            if (i==0) {
                make.top.equalTo(_listContentView).offset(10);
            }
            else{
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }
            if (i==[titles count]-1) {
                make.bottom.equalTo(_listContentView).offset(-10);
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
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
