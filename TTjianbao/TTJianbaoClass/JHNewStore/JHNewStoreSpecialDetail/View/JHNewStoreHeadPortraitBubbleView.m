//
//  JHNewStoreHeadPortraitBubbleView.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHeadPortraitBubbleView.h"

@interface JHNewStoreHeadPortraitBubbleView()

@property (nonatomic, strong) NSMutableArray * dataImgArr_net;

@property (nonatomic, strong) NSMutableArray * dataImgViewArr;
@property (nonatomic, assign) BOOL isAnimateFinish;
@end

@implementation JHNewStoreHeadPortraitBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataImgArr_net = [NSMutableArray array];
        self.isAnimateFinish = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.dataImgViewArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<6; i++) {
        
        UIImageView * imgv = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-30-30*i, 0, 26, 26)];
        imgv.tag = 10+i;
        imgv.centerY = self.height/2;
        imgv.layer.cornerRadius = 13;
        imgv.layer.masksToBounds = YES;
//        imgv.layer.borderColor = [UIColor orangeColor].CGColor;
//        imgv.layer.borderWidth = 1;
        [self addSubview:imgv];
        [self.dataImgViewArr addObject:imgv];
    }
}

- (void)setDataArr_loc:(NSArray *)dataArr_loc
{
    NSArray * array = dataArr_loc;
    if (dataArr_loc.count > 6) {
        array = [dataArr_loc subarrayWithRange:NSMakeRange(0, 6)];
    }
    
    for (int i = 0; i<array.count; i++) {
        UIImageView * imgv = self.dataImgViewArr[i];
//        imgv.image = [UIImage imageNamed:dataArr_loc[i]];
        JHNewStoreSpecialShowImage * model = array[i];
        [imgv jh_setAvatorWithUrl:model.img];
    }
    if (array.count<6) {

    }else{

        [self startAnimation_loc];
    }
    
}

- (void)startAnimation_loc
{
    if (!self.isAnimateFinish) {
        return;
    }
    self.isAnimateFinish = NO;
    UIImageView * imgg = [self.dataImgViewArr lastObject];
    imgg.transform = CGAffineTransformScale(imgg.transform, 0.1, 0.1);
    imgg.hidden = YES;
    @weakify(self);
    [UIView animateWithDuration:1 animations:^{
        @strongify(self);
        for (int i = 0;i<self.dataImgViewArr.count; i++) {
            UIImageView * imgg = self.dataImgViewArr[i];
            if (i==0) {
                imgg.transform = CGAffineTransformScale(imgg.transform, 0.1, 0.1);
            }else if (i==self.dataImgViewArr.count-1){
                imgg.transform = CGAffineTransformScale(imgg.transform, 10, 10);
                imgg.centerX = imgg.centerX+30;
                imgg.hidden = NO;
            }
            else{
               imgg.centerX = imgg.centerX+30;
            }
        }
        
    } completion:^(BOOL finished) {
        @strongify(self);
        UIImageView * imgg = self.dataImgViewArr[0];
        imgg.centerX = self.width-30-30*(self.dataImgViewArr.count-1)+15;
        [self.dataImgViewArr removeObjectAtIndex:0];
        [self.dataImgViewArr addObject:imgg];
        imgg.transform = CGAffineTransformScale(imgg.transform, 10, 10);
        imgg.hidden = YES;
        self.isAnimateFinish = YES;

    }];
}
@end
