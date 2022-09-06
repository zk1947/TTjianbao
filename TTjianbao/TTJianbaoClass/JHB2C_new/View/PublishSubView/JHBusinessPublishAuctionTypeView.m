//
//  JHBusinessPublishAuctionTypeView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishAuctionTypeView.h"
#import "JHBusinessPublishTimePickerView.h"
#import "JHBusinessPublishContinueTimePicker.h"
@interface JHBusinessPublishAuctionTypeView ()
@property(nonatomic,strong) UIView * line;
@property(nonatomic,strong) UILabel * cateLabel;
@property(nonatomic,strong) UILabel * seleLabel;  //商品发布
@property(nonatomic,strong) UILabel * startLabel2;  //开始时间
@property(nonatomic,strong) UILabel * continueLabel2;  //持续时间

@property(nonatomic,strong) UIView *startBgView;//开始时间底部View
@property(nonatomic,strong) UIView *continuBgView;//开始时间底部View
@end

@implementation JHBusinessPublishAuctionTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self setItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self creatUI];
}


- (void)creatUI{
    self.cateLabel = [[UILabel alloc] init];
    self.cateLabel.font = JHMediumFont(15);
    self.cateLabel.textColor = HEXCOLOR(0x222222);
    self.cateLabel.text = @"商品发布";
    [self addSubview:self.cateLabel];
    [self.cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self addSubview:starImageView];
    [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cateLabel);
        make.left.equalTo(self.cateLabel.mas_right).offset(2);
    }];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UIControl * control = [[UIControl alloc] init];
    [self addSubview:control];
    [control addTarget:self action:@selector(controlAction1) forControlEvents:UIControlEventTouchUpInside];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(102);
        make.right.top.equalTo(self);
    }];
    
    self.seleLabel = [[UILabel alloc] init];
    self.seleLabel.font = JHFont(13);
    self.seleLabel.textColor = HEXCOLOR(0x999999);
    self.seleLabel.text = @"立即上架";
    [control addSubview:self.seleLabel];
    [self.seleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.right.equalTo(control).inset(30);
    }];
    
    UIImageView * seleImage = [[UIImageView alloc] init];
    seleImage.image = [UIImage imageNamed:@"icon_cell_arrow"];
    [control addSubview:seleImage];
    [seleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(18);
        make.right.equalTo(self).inset(10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];

    self.startBgView = [[UIView alloc] init];
    self.startBgView.clipsToBounds = YES;
    [self addSubview:self.startBgView];
    [self.startBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(14);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    UILabel * propetyLabel = [[UILabel alloc] init];
    propetyLabel.font = JHMediumFont(15);
    propetyLabel.textColor = HEXCOLOR(0x222222);
    propetyLabel.text = @"开始时间";
    [self.startBgView addSubview:propetyLabel];
    [propetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startBgView).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self.startBgView addSubview:starImageView2];
    [starImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(propetyLabel);
        make.left.equalTo(propetyLabel.mas_right).offset(2);
    }];
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.startBgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(propetyLabel.mas_bottom).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    UIControl * control2 = [[UIControl alloc] init];
    [self.startBgView addSubview:control2];
    [control2 addTarget:self action:@selector(controlAction2) forControlEvents:UIControlEventTouchUpInside];
    [control2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(102);
        make.right.equalTo(self.startBgView);
        make.top.equalTo(self.startBgView);
    }];
    
    self.startLabel2 = [[UILabel alloc] init];
    self.startLabel2.font = JHFont(13);
    self.startLabel2.textColor = HEXCOLOR(0x999999);
    self.startLabel2.text = @"请选择上拍时间";
    [control2 addSubview:self.startLabel2];
    [self.startLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startBgView).offset(14);
        make.left.equalTo(@0);
    }];
    
    
    self.continuBgView = [[UIView alloc] init];
    self.continuBgView.clipsToBounds = YES;
    [self addSubview:self.continuBgView];
    [self.continuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.startBgView.mas_bottom).offset(0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.bottom.equalTo(@0).offset(-12);
    }];
    
    UILabel * propetyLabel2 = [[UILabel alloc] init];
    propetyLabel2.font = JHMediumFont(15);
    propetyLabel2.textColor = HEXCOLOR(0x222222);
    propetyLabel2.text = @"持续时间";
    [self.continuBgView addSubview:propetyLabel2];
    [propetyLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.continuBgView).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self.continuBgView addSubview:starImageView3];
    [starImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(propetyLabel2);
        make.left.equalTo(propetyLabel2.mas_right).offset(2);
    }];
//    UIView * line2 = [[UIView alloc] init];
//    line2.backgroundColor = HEXCOLOR(0xEEEEEE);
//    [self.continuBgView addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(propetyLabel2.mas_bottom).offset(13);
//        make.height.mas_equalTo(1);
//        make.left.mas_equalTo(102);
//        make.right.equalTo(self.continuBgView);
//    }];
    UIControl * control3 = [[UIControl alloc] init];
    [self.continuBgView addSubview:control3];
    [control3 addTarget:self action:@selector(controlAction3) forControlEvents:UIControlEventTouchUpInside];
    [control3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(102);
        make.top.right.bottom.equalTo(self.continuBgView);
    }];
    
    self.continueLabel2 = [[UILabel alloc] init];
    self.continueLabel2.font = JHFont(13);
    self.continueLabel2.textColor = HEXCOLOR(0x999999);
    self.continueLabel2.text = @"请选择持续时间";
    [control3 addSubview:self.continueLabel2];
    [self.continueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.continuBgView).offset(14);
        make.left.equalTo(@0);
    }];

    [self resetLayoutSubview:0];
}
- (void)controlAction1{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选商品发布类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //更改标题样式
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"请选商品发布类型"];
    [title addAttributes:@{NSFontAttributeName:JHFont(14),NSForegroundColorAttributeName:kColor999} range:NSMakeRange(0, title.length)];
    [alertVC setValue:title forKey:@"attributedMessage"];

    
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"立即上架"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        self.publishModle.productStatus = 0;
        [self resetLayoutSubview:0];
        
        //0-上架（立即上架） 1-下架（下架待售）  2违规禁售  3预告中(指定时间上架)  4已售出  5流拍  6交易取消 （3，5，6是拍卖商品特有的状态）【必须】",
                                                   }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"指定时间上架"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        self.publishModle.productStatus = 3;
        [self resetLayoutSubview:3];
        
                                                   }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"下架待售"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        self.publishModle.productStatus = 1;
        [self resetLayoutSubview:1];
        
                                                   }];
    UIAlertAction *button4 = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                   }];
    //文字颜色
    [button4 setValue:kColor666 forKey:@"titleTextColor"];
    
    [alertVC addAction:button];
    [alertVC addAction:button2];
    [alertVC addAction:button3];
    [alertVC addAction:button4];
    
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)controlAction2{
 
    [self.superview endEditing:YES];
    JHBusinessPublishTimePickerView *countPicker = [[JHBusinessPublishTimePickerView alloc] init];
    countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    countPicker.normalModel = self.normalModel;
    [countPicker show];
   
    countPicker.sureClickBlock2 = ^(NSString * _Nonnull showStr, NSString * _Nonnull timeStr) {
        self.publishModle.auctionStartTime = timeStr;
        self.startLabel2.text = showStr;
    };
}
- (void)controlAction3{
    
    [self.superview endEditing:YES];
    JHBusinessPublishContinueTimePicker *countPicker = [[JHBusinessPublishContinueTimePicker alloc] init];
    countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    countPicker.normalModel = self.normalModel;
    [countPicker show];
   
    countPicker.sureClickBlock2 = ^(NSString * _Nonnull showStr, NSString * _Nonnull timeStr) {
        self.continueLabel2.text = showStr;
        self.publishModle.auctionLastTime = timeStr;
    };
}

- (void)resetLayoutSubview:(NSInteger)type{
    //0-上架（立即上架） 1-下架（下架待售）  2违规禁售  3预告中(指定时间上架)
    self.line.hidden = NO;
   if(type == 1){
       self.line.hidden = YES;
        self.seleLabel.text = @"下架待售";
        [self.startBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(14);
            make.left.right.equalTo(@0);
            make.height.equalTo(@0);
        }];
        [self.continuBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.startBgView.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@0);
            make.bottom.equalTo(@0).offset(-12);
        }];
    }else if(type == 3){
        self.seleLabel.text = @"指定时间上架";
        [self.startBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(14);
            make.left.right.equalTo(@0);
            make.height.equalTo(@50);
        }];
        [self.continuBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.startBgView.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.height.equalTo(@50);
            make.bottom.equalTo(@0).offset(-12);
        }];
    }else{
        self.seleLabel.text = @"立即上架";
        self.publishModle.productStatus = 0;
        [self.startBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cateLabel.mas_bottom).offset(14);
            make.left.right.equalTo(@0);
            make.height.equalTo(@0);
        }];
        
        [self.continuBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.startBgView.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
//            make.height.equalTo(@50);
            make.bottom.equalTo(@0).offset(-12);
        }];
    }
}
- (void)resetNetDataWithType:(NSInteger)type{
    [self resetLayoutSubview:type];
    for (JHPublishTimeListModel *temp in self.normalModel.publishStartTimeList) {
        if ([self.publishModle.auctionStartTime isEqualToString:temp.time]) {
            self.startLabel2.text = temp.timeDesc;
            break;
        }
    }
    for (JHPublishTimeListModel *temp in self.normalModel.publishLastTimeList) {
        if ([self.publishModle.auctionLastTime isEqualToString:temp.time]) {
            self.continueLabel2.text = temp.timeDesc;
            break;
        }
    }
//    @property(nonatomic,strong) UILabel * startLabel2;  //开始时间
//    @property(nonatomic,strong) UILabel * continueLabel2;  //持续时间
}
@end
