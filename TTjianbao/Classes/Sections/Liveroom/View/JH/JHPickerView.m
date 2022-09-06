//
//  JHPickerView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPickerView.h"

@implementation JHPickerView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.arrayData.count>row) {
        self.selectedIndex = row;
    }

}
- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData {
    [super setArrayData:arrayData];
    self.selectedIndex = 0;
}

//- (void)selectedOk
//{
//    if ([self.delegate respondsToSelector:@selector(pickerSingle:selectedTitle:)]) {
//        [super.delegate pickerSingle:self selectedTitle:[super valueForKey:@"selectedTitle"]];
//    }
//    
//    [super selectedOk];
//}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex<self.arrayData.count) {
        [super setValue:self.arrayData[selectedIndex] forKey:@"selectedTitle"];
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [self.pickerView selectRow:row inComponent:component animated:YES];
    self.selectedIndex = row;
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
        return nil;
    }else if (component == 1){
        UILabel *label = [[UILabel alloc]init];
        [label setText:self.arrayData[row]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.adjustsFontSizeToFitWidth = YES;
        return label;
    }else {
        UILabel *label = [[UILabel alloc]init];
        [label setText:self.titleUnit];
        [label setTextAlignment:NSTextAlignmentLeft];
        return label;
    }
}


@end
