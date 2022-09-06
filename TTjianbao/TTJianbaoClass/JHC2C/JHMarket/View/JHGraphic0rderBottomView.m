//
//  JHGraphic0rderBottomView.m
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphic0rderBottomView.h"
#import "JHGraphicalBottomModel.h"
#import "UIImage+JHColor.h"

@interface JHGraphic0rderBottomView ()

@property (nonatomic, strong) NSArray <JHGraphicalBottomModel *> *bottomButtons;

@end

@implementation JHGraphic0rderBottomView

- (void)updateGraphicBottom:(NSArray <JHGraphicalBottomModel *> *)buttons {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    buttons = [self sortButtons:buttons];//[[buttons reverseObjectEnumerator] allObjects];
    _bottomButtons = buttons;
    UIButton * lastView;
    for (int i=0; i<buttons.count; i++) {
        
        JHGraphicalBottomModel *bottomModel = [buttons objectAtIndex:i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font= [UIFont systemFontOfSize:12];
        [button setTitle:bottomModel.titleName forState:UIControlStateNormal];
        [button setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:button];
        button.tag = 222222 + i;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(bottomModel.titleSizeWidth + 20, 30));
            make.centerY.equalTo(self);
            if (i==0) {
                make.right.equalTo(self).offset(-10);
            }
            else{
                make.right.equalTo(lastView.mas_left).offset(-10);
            }
        }];
        
        if (bottomModel.isShowUISpecial) {
            button.layer.borderWidth = 0;
            UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(bottomModel.titleSizeWidth + 20, 30) radius:15];
            [button setBackgroundImage:nor_image forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
        }
        else {
            button.layer.cornerRadius = 15.0;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            button.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
            button.layer.borderWidth = 0.5f;
        }
        
        lastView= button;
    }
}

- (void)buttonPress:(UIButton *)sender {
    NSInteger num = sender.tag - 222222;
    JHGraphicalBottomModel *bottomModel = [_bottomButtons objectAtIndex:num];
    if (self.buttonBlock) {
        self.buttonBlock(bottomModel);
    }
    
}

///按钮排序，特殊样式的排在后面
- (NSArray *)sortButtons:(NSArray *)array{
    if (array.count<2) {
        return array;
    }
    NSMutableArray *marray = [array mutableCopy];
    for (NSInteger i = 0; i < marray.count; i++) {
        JHGraphicalBottomModel *model1 = marray[i];
        for (NSInteger j = 1; j < marray.count; j++) {
            JHGraphicalBottomModel *model2 = marray[j];
            //特殊样式
            if (!model1.isShowUISpecial && model2.isShowUISpecial) {
                [marray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return [marray copy];
}

@end
