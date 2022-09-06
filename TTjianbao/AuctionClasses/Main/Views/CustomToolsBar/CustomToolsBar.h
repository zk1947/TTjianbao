//
//  CustomToolsBar.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

@interface CustomToolsBar : BaseView
@property(nonatomic,strong)UILabel *titleLbl;
@property(nonatomic,strong)UIView *ImageView;
@property(nonatomic,strong)UIButton *comBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property (nonatomic, assign) double        hh;

-(void)setTitle:(NSString*)title;
-(void)setSpecialTitle:(NSString*)title; //定制化title
-(void)setJHBackgroundColor:(UIColor *)color;
-(void)addBtn:(NSString*)title withImage:(UIImage*)image withHImage:(UIImage *)hImage withFrame:(CGRect)frame;
-(void)addrightBtn:(NSString*)title withImage:(UIImage*)image withHImage:(UIImage *)hImage withFrame:(CGRect)frame;
-(void)addNavImage:(UIImage*)image;
@end
