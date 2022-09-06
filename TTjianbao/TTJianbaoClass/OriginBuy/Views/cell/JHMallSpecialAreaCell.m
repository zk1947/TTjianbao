//
//  JHMallSpecialAreaCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallSpecialAreaCell.h"
#import "JHSpecialAreaSection.h"

@interface JHMallSpecialAreaCell ()
{
    UIView *contentBack;
}
@end
@implementation JHMallSpecialAreaCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        contentBack = [[UIView alloc]init];
        contentBack.backgroundColor = [UIColor clearColor];
       // contentBack.layer.cornerRadius = 8;
      //  contentBack.layer.masksToBounds = YES;
        [self.contentView addSubview:contentBack];
        [contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}
-(void)setSpecialAreaModes:(NSMutableArray<JHOperationDetailModel *> *)specialAreaModes{
    
    _specialAreaModes = specialAreaModes;
    [self initSubviews];
    
}
-(void)initSubviews{
    
    [contentBack.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    JHSpecialAreaSection *lastSection;
    NSInteger beginSectionsOfArea = 0; //section起点
    for (int i =0 ; i<self.specialAreaModes.count; i++) {
        JHSpecialAreaSection *section = [[JHSpecialAreaSection alloc]init];
        section.detailMode =self.specialAreaModes[i];
        //begin:仅为埋点
        NSInteger rowOfSection = section.detailMode.definiDetails.count;
        beginSectionsOfArea += rowOfSection;
        if(rowOfSection == 1)
        {//仅有一个时去掉
            beginSectionsOfArea -= 1;
            section.sectionsOfArea = beginSectionsOfArea;
        }
        else if(i == 0)
        {//第一行从0算起
            section.sectionsOfArea = 0;
        }
        else
        {
            section.sectionsOfArea = beginSectionsOfArea - rowOfSection;
        }
        //end:仅为埋点
        
        [contentBack addSubview:section];
        [section mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(self).offset(0);
            }
            else{
                make.top.equalTo(lastSection.mas_bottom).offset(0);
            }
            make.left.equalTo(contentBack).offset(0);
            make.right.equalTo(contentBack).offset(0);
            make.height.offset(self.specialAreaModes[i].cellHeight);
        }];
        lastSection = section;
    }

//    JHSpecialAreaSection *section0;
//    if (self.specialAreaModes.count>0) {
//        section0 = [[JHSpecialAreaSection alloc]init];
//        section0.detailMode =self.specialAreaModes[0];
//        [contentBack addSubview:section0];
//        [section0 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(contentBack).offset(0);
//            make.left.equalTo(contentBack).offset(0);
//            make.right.equalTo(contentBack).offset(0);
//            make.height.offset(self.specialAreaModes[0].cellHeight);
//        }];
//    }
//    if (self.specialAreaModes.count>1){
//        UIView *back = [[UIView alloc]init];
//        back.backgroundColor = [UIColor whiteColor];
//        back.layer.cornerRadius = 8;
//        back.layer.masksToBounds = YES;
//        [contentBack addSubview:back];
//        [back mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(contentBack).offset(0);
//            make.right.equalTo(contentBack).offset(0);
//            make.top.equalTo(section0.mas_bottom).offset(10);
//              make.bottom.equalTo(contentBack.mas_bottom).offset(00);
//        }];
//
//        JHSpecialAreaSection *lastSection;
//        for (int i =1 ; i<self.specialAreaModes.count; i++) {
//            JHSpecialAreaSection *section = [[JHSpecialAreaSection alloc]init];
//            section.detailMode =self.specialAreaModes[i];
//            [back addSubview:section];
//            [section mas_makeConstraints:^(MASConstraintMaker *make) {
//                if (i == 1) {
//                    make.top.equalTo(back).offset(0);
//                }
//                else{
//                    make.top.equalTo(lastSection.mas_bottom).offset(0);
//                }
//                make.left.equalTo(back).offset(0);
//                make.right.equalTo(back).offset(0);
//                make.height.offset(self.specialAreaModes[i].cellHeight);
//            }];
//            lastSection = section;
//        }
//    }
   
    
}
@end
