//
//  JHCustomizeFlyOrderCountPickerView.m
//  TTjianbao
//
//  Created by lihang on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFlyOrderCountPickerView.h"
@interface JHCustomizeFlyOrderCountPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign)NSInteger selectedIndex_0;
@property (nonatomic, assign)NSInteger selectedIndex_1;
@end
@implementation JHCustomizeFlyOrderCountPickerView
#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];
    _heightPickerComponent = 44;
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayData_0.count;
    }else if (component == 1){
        return self.arrayData_1.count;
    }else {
        return 1;
    }
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
    }else{
        self.selectedIndex_1 = row;
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
    }else if (component == 1){
        UILabel *label = [[UILabel alloc]init];
        [label setText:self.arrayData_1[row]];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }else {
        return nil;
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk {
    if(self.sureClickBlock){
        self.sureClickBlock(self.selectedIndex_0, self.selectedIndex_1);
    }
    [super selectedOk];
}


#pragma mark - --- setters 属性 ---

- (void)setArrayData_0:(NSMutableArray<NSString *> *)arrayData_0
{
    _arrayData_0 = arrayData_0;
    [self.pickerView reloadAllComponents];
}
- (void)setArrayData_1:(NSMutableArray<NSString *> *)arrayData_1
{
    _arrayData_1 = arrayData_1;
    [self.pickerView reloadAllComponents];
}
@end
