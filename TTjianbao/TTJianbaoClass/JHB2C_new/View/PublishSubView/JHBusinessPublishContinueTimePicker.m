//
//  JHBusinessPublishContinueTimePicker.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishContinueTimePicker.h"
@interface JHBusinessPublishContinueTimePicker()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, assign)NSInteger selectedIndex_0;
@end
@implementation JHBusinessPublishContinueTimePicker
- (void)setupUI
{
    [super setupUI];
    _heightPickerComponent = 44;
    self.title = @"请选择持续时间";
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.normalModel.publishLastTimeList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return (self.st_width);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex_0 = row;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    JHPublishTimeListModel* firstModel = self.normalModel.publishLastTimeList[row];
    UILabel *label = [[UILabel alloc]init];
    [label setText:firstModel.timeDesc];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk {

    if(self.sureClickBlock2){
        JHPublishTimeListModel* firstModel = self.normalModel.publishLastTimeList[_selectedIndex_0];
        self.sureClickBlock2(firstModel.timeDesc, firstModel.time);
    }
    
    [super selectedOk];
}
@end
