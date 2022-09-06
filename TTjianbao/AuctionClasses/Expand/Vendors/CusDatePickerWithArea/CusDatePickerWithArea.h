//
//  OrderStatusTableViewCell.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/7.
//  Copyright © 2017年 jiangchao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CityModelData.h"
typedef void(^AreaBlock)(NSDictionary *area);  // 区域回调Block

#import "BaseView.h"

@interface CusDatePickerWithArea : BaseView

-(instancetype)initWithFrame:(CGRect)frame cityData:(CityModelData *)cityData;

+(instancetype)cusDatePickerWithArea:(CGRect)frame cityData:(CityModelData *)cityData;

/**
 *  选择器对象
 */
@property (nonatomic,strong)UIPickerView *pickerView;
/**
 *  最终选中的值
 */
@property (nonatomic,copy)AreaBlock areaValue;
/**
 *  滚动到对应的行
 *
 *  @param provinceCode  第一列的下标
 *  @param cityCode 第二列的下标
 *  @param dictrictCode  第三列的下标
 */
-(void)scrollToProvince:(NSInteger)provinceCode  city:(NSInteger)cityCode dictrict:(NSInteger)dictrictCode;
@end
