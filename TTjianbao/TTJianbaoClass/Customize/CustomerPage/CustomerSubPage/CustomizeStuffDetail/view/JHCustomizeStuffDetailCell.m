//
//  JHCustomizeStuffDetailCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeStuffDetailCell.h"
#import <YYKit/YYKit.h>
#import "CommHelp.h"
#import "TTjianbaoHeader.h"
@interface JHCustomizeStuffDetailCell ()
@property (nonatomic, strong) UIImageView * coverImage;
@property (strong, nonatomic)  UILabel* title;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation JHCustomizeStuffDetailCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=[UIImage imageNamed:@""];
        _coverImage.userInteractionEnabled=YES;
        _coverImage.backgroundColor=[CommHelp randomColor];
        _coverImage.layer.cornerRadius = 8;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverImage];
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        UIView *titleBack = [[UIView alloc] init];
        titleBack.backgroundColor = HEXCOLORA(0x000000, 0.4f);
        [_coverImage addSubview:titleBack];
        [titleBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_coverImage.mas_bottom).offset(0);
            make.left.right.equalTo(_coverImage).offset(0);
            make.height.equalTo(@25);
        }];
        
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont fontWithName:kFontNormal size:12];
        _title.textColor = kColorFFF;
        _title.numberOfLines = 1;
        [titleBack addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
           // make.bottom.equalTo(_coverImage.mas_bottom).offset(-5);
            make.center.equalTo(titleBack);
        }];

      
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setImage:[UIImage imageNamed:@"customize_detail_icon_nomal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"customize_detail_icon_select"] forState:UIControlStateSelected];
        [_coverImage addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(10);
            make.right.equalTo(_coverImage).offset(-10);
        }];
     
    }
    return self;
}
- (void)setStuffModel:(JHMeterialsCategoryModel *)stuffModel{

    _stuffModel = stuffModel;
    _selectBtn.selected = _stuffModel.isSelect;
    [_coverImage jhSetImageWithURL:[NSURL URLWithString:_stuffModel.img] placeholder:kDefaultCoverImage];
    _title.text = _stuffModel.name;
}

@end
