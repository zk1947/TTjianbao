//
//  JHAnchorBreakPaperItemView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHAnchorBreakPaperItemView.h"
#import "JHPickerView.h"
#import "JHKeyValueModel.h"
@interface JHAnchorBreakPaperItemView ()<STPickerSingleDelegate>
@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSMutableArray *pickerTitleArray;

@end
@implementation JHAnchorBreakPaperItemView

- (void)makeUI {
    self.backgroundColor = [UIColor whiteColor];
    self.breakPrice = [JHUIFactory createTitleTextWithTitle:@"购入价格" textPlace:@"请输入购入价格" isEdit:YES isShowLine:NO text:@""];
    self.breakPrice.isCarryTwoDote = YES;
    self.breakPrice.textField.textAlignment = NSTextAlignmentRight;
    self.breakStyle = [JHUIFactory createTitleTextWithTitle:@"拆单类型" textPlace:@"请选择拆单类型" isEdit:NO isShowLine:NO text:@""];
    [self.breakStyle openClickActionRightArrowWithTarget:self action:@selector(showStyle)];
    
    JHCustomLine *line = [JHUIFactory createLine];
    
    self.title = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"订单"];
    [self addSubview:self.title];
    [self addSubview:self.breakStyle];
    [self addSubview:self.breakPrice];
    [self addSubview:line];
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.leading.offset(10);
    }];
    
    [self.breakStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self.title.mas_bottom);
        make.trailing.equalTo(self);
        make.height.equalTo(@48);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.title);
        make.top.equalTo(self.breakStyle.mas_bottom);
        make.trailing.offset(0);
        make.height.offset(1);
    }];
    
    [self.breakPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.breakStyle);
        make.top.equalTo(line.mas_bottom);
        make.trailing.equalTo(self);
        make.height.equalTo(@48);
        make.bottom.equalTo(self);
    }];
    
}

- (void)makeUIPrice {
    self.backgroundColor = [UIColor whiteColor];
    self.breakPrice = [JHUIFactory createTitleTextWithTitle:@"价格" textPlace:@"请输入价格" isEdit:YES isShowLine:YES text:@""];
    self.breakPrice.isCarryTwoDote = YES;
    [self addSubview:self.breakPrice];
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
           
    [self.breakPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@48);
        make.bottom.equalTo(self).offset(-10);
    }];
    
}

- (void)makeUIOrderCount {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.breakStyle = [JHUIFactory createTitleTextWithTitle:@"拆单数量" textPlace:@"请选择拆单类型" isEdit:NO isShowLine:NO text:@"2"];
    [self.breakStyle openClickActionRightArrowWithTarget:self action:@selector(showBreakCount)];
    
    [self addSubview:self.breakStyle];
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    
    
    
    [self.breakStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@48);
    }];
    
    
    
}

- (void)setSplitModeArray:(NSArray *)splitModeArray {
    _splitModeArray = splitModeArray;
    NSMutableArray *titles = [NSMutableArray array];
           for (JHKeyValueModel *model in splitModeArray) {
               [titles addObject:model.value];
           }
    self.pickerTitleArray = titles;
           
}

- (void)showStyle {
    [self.viewController.view endEditing:YES];
    if (self.pickerTitleArray) {
        self.picker = [[JHPickerView alloc] init];
         self.picker.widthPickerComponent = 300;
         self.picker.delegate = self;
        self.picker.tag = 2;
         self.picker.arrayData = self.pickerTitleArray;
         [self.picker show];
    }
 
    
}

- (void)showBreakCount {
    [self.viewController.view endEditing:YES];
    self.picker = [[JHPickerView alloc] init];
    self.picker.tag = 1;
    self.picker.widthPickerComponent = 300;
    self.picker.delegate = self;
    self.picker.arrayData = @[@"2",@"3",@"4",@"5",@"6"].mutableCopy;
    [self.picker show];
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    self.breakStyle.textField.text = selectedTitle;
    if (pickerSingle.tag == 1) { //拆单数量
        if (self.seletedBlock) {
            self.seletedBlock(_picker);
        }
    } else if (pickerSingle.tag == 2) { //拆单方式
        if (pickerSingle.selectedIndex < self.splitModeArray.count) {
            JHKeyValueModel *model = self.splitModeArray[pickerSingle.selectedIndex];
            self.tag = model.key;

        }
    }
    
}

@end
