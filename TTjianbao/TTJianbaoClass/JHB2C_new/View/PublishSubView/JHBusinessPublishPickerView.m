//
//  JHBusinessPublishPickerView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishPickerView.h"
@interface JHBusinessPublishPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@end
@implementation JHBusinessPublishPickerView
- (void)setupUI
{
    [super setupUI];
    _heightPickerComponent = 44;
    self.title = @"请选择持商品分类";
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    JHGoodManagerFilterModel* secModel = (self.normalModel.backCateList[_selectedIndex_0]);
    JHGoodManagerFilterModel* thirdModel = secModel.children[_selectedIndex_1];
    if (component == 0) {
        return self.normalModel.backCateList.count;
    }else if (component == 1){
        return secModel.children.count;
    }else {
        return thirdModel.children.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return (self.st_width)/3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        self.selectedIndex_0 = row;
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }else if(component == 1){
        self.selectedIndex_1 = row;
        self.selectedIndex_2 = 0;
        [self.pickerView reloadComponent:2];
    }else{
        self.selectedIndex_2 = row;
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
        JHGoodManagerFilterModel* firstModel = self.normalModel.backCateList[row];
        UILabel *label = [[UILabel alloc]init];
        [label setText:firstModel.cateName];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }else if (component == 1){
        JHGoodManagerFilterModel* firstModel = self.normalModel.backCateList[_selectedIndex_0];
        JHGoodManagerFilterModel* secModel = firstModel.children[row];
        UILabel *label = [[UILabel alloc]init];
        [label setText:secModel.cateName];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }else {
        JHGoodManagerFilterModel* firstModel = self.normalModel.backCateList[_selectedIndex_0];
        JHGoodManagerFilterModel* secModel = firstModel.children[_selectedIndex_1];
        JHGoodManagerFilterModel* thirdModel = secModel.children[row];
        UILabel *label = [[UILabel alloc]init];
        [label setText:thirdModel.cateName];
        [label setTextAlignment:NSTextAlignmentCenter];
        return label;
    }
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk {
    if(self.sureClickBlock){
        self.sureClickBlock(self.selectedIndex_0, self.selectedIndex_1,self.selectedIndex_2);
    }
    if(self.sureClickBlock2){
        JHGoodManagerFilterModel* firstModel = self.normalModel.backCateList[_selectedIndex_0];
        JHGoodManagerFilterModel* secModel = firstModel.children[_selectedIndex_1];
        JHGoodManagerFilterModel* thirdModel = secModel.children[_selectedIndex_2];
        NSString * str = [NSString stringWithFormat:@"%@-%@-%@",firstModel.cateName,secModel.cateName,thirdModel.cateName];
        self.sureClickBlock2(str,firstModel.cateId,secModel.cateId,thirdModel.cateId,_selectedIndex_0,_selectedIndex_1,_selectedIndex_2);
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
