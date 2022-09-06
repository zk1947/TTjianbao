//
//  JHC2CPickView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CPickView.h"

@interface JHC2CPickView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign)NSInteger selectedIndex_0;

@end
@implementation JHC2CPickView
#pragma mark - --- init 视图初始化 ---
- (void)setupUI{
    [super setupUI];
    _heightPickerComponent = 44;
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    self.lineViewDown.hidden = YES;
    self.lineView.hidden = YES;
    self.buttonLeft.layer.borderColor = UIColor.clearColor.CGColor;
    self.buttonRight.layer.borderColor = UIColor.clearColor.CGColor;
}

- (void)seletedRow:(NSInteger)row{
    self.selectedIndex_0 = row;
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayData_0.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return (self.st_width)/2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        self.selectedIndex_0 = row;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    if (component == 0) {
        UILabel *label = [[UILabel alloc]init];
        [label setText:self.arrayData_0[row]];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }else {
        return nil;
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk {
    if(self.sureClickBlock){
        self.sureClickBlock(self.selectedIndex_0);
    }
    [super selectedOk];
}


#pragma mark - --- setters 属性 ---

- (void)setArrayData_0:(NSMutableArray<NSString *> *)arrayData_0
{
    _arrayData_0 = arrayData_0;
    [self.pickerView reloadAllComponents];
}
@end
