//
//  AdressTableViewCell.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/19.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressMode.h"
typedef enum
{
    setDefault = 1,
    setEdit =2,
    setDelete=3
    
}CellButton;

@protocol AdressTableViewCellDelegate <NSObject>

@optional
-(void)buttonPress:(UIButton*)button cellIndex:(NSInteger)index;


@end

@interface AdressTableViewCell : UITableViewCell



@property(weak,nonatomic)id<AdressTableViewCellDelegate>delegate;
@property(assign,nonatomic)NSInteger cellIndex;
@property(strong,nonatomic) AdressMode * adressMode;
- (float)getAutoCellHeight;

@end
