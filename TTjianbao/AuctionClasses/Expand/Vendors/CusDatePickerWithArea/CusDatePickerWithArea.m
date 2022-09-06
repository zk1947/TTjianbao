//
//  OrderStatusTableViewCell.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/2/7.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "CusDatePickerWithArea.h"

#define cusColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]   // 颜色
#define cusFont(font)  [UIFont systemFontOfSize:font]   // 字体
#define sureCellGrayColor cusColor(120, 120, 120, 1.0)       //    灰色
#define circleNum   0    // 圆角的度数
#define screenWidthW  [[UIScreen mainScreen] bounds].size.width
#define screenHeightH [[UIScreen mainScreen] bounds].size.height


#define headViewHHHHH  40     // 头视图的高度
#define datePickerHHHH 200   // pickView的高度

#define backButtonLeftDistance 0
#define backButtonW 60   // 取消和确定按钮的宽高
#define backButtonH 40

#define okButtonW 60
#define okButtonH 45

#define leftAndRightDistance 0   // 最右边距

@interface CusDatePickerWithArea ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSString *linkSelectIndex;     // 拼接的选中下标
}
/**
 *  所有的省份
 */
@property (nonatomic,strong)NSMutableArray *allProvince;
/**
 *  选中的省份对应的下标
 */
@property (nonatomic,assign)NSInteger      selectRowWithProvince;
/**
 *  选中的市级对应的下标
 */
@property (nonatomic,assign)NSInteger      selectRowWithCity;
/**
 *  选中的县级对应的下标
 */
@property (nonatomic,assign)NSInteger      selectRowWithTown;

@end

@implementation CusDatePickerWithArea
-(NSMutableArray *)allProvince{
    if (_allProvince==nil) {
        _allProvince=[NSMutableArray array];
    }
    return _allProvince;
}
-(instancetype)initWithFrame:(CGRect)frame cityData:(CityModelData *)cityData{
    if (self=[super init]) {
        self.frame=frame;
        self.allProvince=(NSMutableArray *)cityData.province;
        [self createUI];
    }
    return self;
    
}
+(instancetype)cusDatePickerWithArea:(CGRect)frame cityData:(CityModelData *)cityData{
    return [[self alloc]initWithFrame:frame cityData:cityData];
}
#pragma mark 创建对应的视图
-(void)createUI{
    
    CGFloat widthWithView=self.frame.size.width-leftAndRightDistance*2;
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]]; // 半透明
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(leftAndRightDistance,self.frame.size.height-(datePickerHHHH+headViewHHHHH),widthWithView,datePickerHHHH+headViewHHHHH)]; //蒙版视图的Frame
    [bg setBackgroundColor:[UIColor whiteColor]];
    bg.userInteractionEnabled=YES;
    bg.layer.cornerRadius=circleNum;
    bg.layer.masksToBounds=YES;
    [self addSubview:bg];
    
//    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, widthWithView,headViewHHHHH)];
//    [bg addSubview:toolBar];
//    toolBar.userInteractionEnabled=YES;
//    [toolBar setBackgroundColor:cusColor(178, 190,223,1.0)];
    
    UIView *toolBar=[[UIView alloc]initWithFrame:CGRectMake(0,0, widthWithView,headViewHHHHH)];
    [bg addSubview:toolBar];
    toolBar.userInteractionEnabled=YES;
    [toolBar setBackgroundColor:[UIColor colorWithRed:0.91f green:0.93f blue:0.97f alpha:1.00f]];
    
    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(backButtonLeftDistance,toolBar.frame.size.height/2-backButtonH/2, backButtonW, backButtonH)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [backButton setTitleColor:sureCellGrayColor forState:UIControlStateNormal];
    [backButton setTitleColor:sureCellGrayColor forState:UIControlStateHighlighted];
    backButton.titleLabel.font=cusFont(15);
    [backButton addTarget:self action:@selector(backOpeartion:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backButton];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"地区选择";
    title.font=[UIFont fontWithName:kFontNormal size:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [toolBar addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toolBar);
    }];
    
    UIButton *OKButton=[[UIButton alloc]initWithFrame:CGRectMake(toolBar.frame.size.width-okButtonW,toolBar.frame.size.height/2-okButtonH/2, okButtonW, okButtonH)];
    [OKButton setTitle:@"完成" forState:UIControlStateNormal];
    [OKButton setTitle:@"完成" forState:UIControlStateHighlighted];
    OKButton.titleLabel.font=cusFont(15);
    [OKButton setTitleColor:cusColor(0, 97, 215, 1.0) forState:UIControlStateNormal];
    [OKButton setTitleColor:cusColor(0, 97, 215, 1.0) forState:UIControlStateHighlighted];
    [OKButton addTarget:self action:@selector(OKOpeartion:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:OKButton];
    
    
    self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,headViewHHHHH,widthWithView,datePickerHHHH)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [bg addSubview:self.pickerView];
    
    self.pickerView.delegate=self;
    self.pickerView.dataSource=self;
    
}
#pragma mark -PickerView的数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    Province *province=self.allProvince[self.selectRowWithProvince];
    City *city=province.child[self.selectRowWithCity];
    if (component==0) return self.allProvince.count;
    if (component==1) return province.child.count;
    if (component==2) return city.child.count;
    return 0;

}
#pragma mark -PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *showTitleValue=@"";
    if (component==0){
        Province *province=self.allProvince[row];
        showTitleValue=province.areaName;
    }
    if (component==1){
        Province *province=self.allProvince[self.selectRowWithProvince];
        City *city=province.child[row];
        showTitleValue=city.areaName;
    }
    if (component==2) {
        Province *province=self.allProvince[self.selectRowWithProvince];
        City *city=province.child[self.selectRowWithCity];
        District *dictrictObj=city.child[row];
        showTitleValue=dictrictObj.areaName;
    }
    return showTitleValue;
}
//  设置对应的字体大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, (screenWidthW-30)/3,35)];
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=2;
    label.font=cusFont(14);
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component]; // 数据源
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return 35;

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component==0) {                    // 只有点击了第一列才去刷新第二个列对应的数据
        self.selectRowWithProvince=row;   //  刷新的下标
        self.selectRowWithCity=0;
        self.selectRowWithTown=0;
        [pickerView reloadComponent:1];  //   刷新第一,二列
        [pickerView reloadComponent:2];
        
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if(component==1){
         self.selectRowWithCity=row;//  选中的市级的下标
         self.selectRowWithTown=0;
         [pickerView reloadComponent:2];  //   刷新第三列
         [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if(component==2){
        self.selectRowWithTown=row;
    }
}
#pragma mark 返回操作
-(void)backOpeartion:(UIButton *)sender{

    [UIView animateWithDuration:0.3 animations:^{

        CGPoint point = self.center;
        point.y      += headViewHHHHH+datePickerHHHH;
        self.center   = point;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];

}
#pragma mark 完成操作
-(void)OKOpeartion:(UIButton *)sender{
    NSDictionary *cityVale=[self finaSureCity];
     self.areaValue(cityVale);
    [UIView animateWithDuration:0.3 animations:^{

        CGPoint point = self.center;
        point.y      += 240;
        self.center   = point;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];

}
#pragma mark 滚动到对应的下标
-(void)scrollToProvince:(NSInteger)provinceCode  city:(NSInteger)cityCode dictrict:(NSInteger)dictrictCode{
    
     NSInteger firstRank=0;
     NSInteger secondRand=0;
     NSInteger thirdRand=0;

    
    for (int i=0;i<[self.allProvince count];i++) {
        
        Province *mode =self.allProvince[i];
        if ([mode.areaId intValue]==provinceCode) {
            firstRank=i;
            
        
            break;
            
        }
    }
    
    Province *province =self.allProvince[firstRank];
    NSArray *cityModes=province.child ;
    for (int j=0;j<[cityModes count];j++) {
        
        City *mode =cityModes[j];
        
        if ([mode.areaId intValue]==cityCode) {
            secondRand=j;
            break;
            
        }
        
    }
    
     City *city =cityModes[secondRand];
     NSArray *dictrictModes=city.child;
    for (int i=0;i<[dictrictModes count];i++) {
        
        District *mode =dictrictModes[i];
        
        if ([mode.areaId intValue]==dictrictCode) {
            thirdRand=i;
            break;
        }
    }
    
    
    if (firstRank<self.allProvince.count) {
        self.selectRowWithProvince=firstRank;
        Province *provinceValue=self.allProvince[firstRank];
        if (secondRand<provinceValue.child.count) {
            self.selectRowWithCity=secondRand;
            [self.pickerView reloadComponent:1];
            City *city=provinceValue.child[secondRand];
            if (thirdRand<city.child.count) {
                self.selectRowWithTown=thirdRand;
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:firstRank inComponent:0 animated:YES];   //滚动到第一,二,三列的下标
                [self.pickerView selectRow:secondRand inComponent:1 animated:YES];
                [self.pickerView selectRow:thirdRand inComponent:2 animated:YES];
            }
        }
    }
}
#pragma mark 拼接最终的值
-(NSDictionary *)finaSureCity{
    
    NSDictionary * area;
    
    if (self.selectRowWithProvince<self.allProvince.count) {
        Province *provinceValue=self.allProvince[self.selectRowWithProvince];
        if (self.selectRowWithCity<provinceValue.child.count) {
            City *cityValue=provinceValue.child[self.selectRowWithCity];
            if (self.selectRowWithTown<cityValue.child.count) {
                
                
                
                District *dictrict=cityValue.child[self.selectRowWithTown];
           // NSString *linkString=[NSString stringWithFormat:@"%@-%@-%@",provinceValue.areaName,cityValue.areaName,dictrict.areaName];
           // NSString *linkCode=[NSString stringWithFormat:@"%@-%@-%@",provinceValue.areaId,cityValue.areaId,dictrict.areaId];
                linkSelectIndex=[NSString stringWithFormat:@"%zi-%zi-%zi",self.selectRowWithProvince,self.selectRowWithCity,self.selectRowWithTown];

                    area=@{@"province":provinceValue.areaName,
                           @"city":cityValue.areaName,
                           @"dictrict":dictrict.areaName,
                           @"provinceCode":provinceValue.areaId,
                           @"cityCode":cityValue.areaId,
                           @"dictrictCode":dictrict.areaId
                           };
                
                
               // NSLog(@"拼接的值:%@ 拼接的下标:%@  拼接的id:%@",linkString,linkSelectIndex,linkCode);
            }
        }
    }
    return area;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [self removeFromSuperview];
}
@end
