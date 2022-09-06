//
//  JHApplyCustomizeOrderCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHApplyCustomizeOrderCell.h"
#import "UIImage+GIF.h"
#import "TTjianbaoHeader.h"
#import "AnimotionObject.h"
#import "JHUIFactory.h"
#import "NTESLiveLikeView.h"

@interface JHApplyCustomizeOrderCell ()
{
  
}
@property (strong, nonatomic)  UIImageView *coverImage;
@property (strong, nonatomic)  UILabel* name;


@end

@implementation JHApplyCustomizeOrderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];

        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=[UIImage imageNamed:@"customize_apply_camera"];
        _coverImage.contentMode=UIViewContentModeScaleToFill;
        _coverImage.layer.masksToBounds = YES;
        _coverImage.layer.cornerRadius = 8;
        _coverImage.userInteractionEnabled=YES;
        [self.contentView addSubview:_coverImage];
        
        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont fontWithName:kFontNormal size:13];
        _name.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _name.numberOfLines = 1;
        _name.textAlignment = NSTextAlignmentCenter;
        _name.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:_name];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(_coverImage.mas_bottom).offset(5);
        }];
        
        _selectImage=[[UIImageView alloc]init];
        _selectImage.image=[UIImage imageNamed:@"order_return_class_icon_select"];
        [_coverImage addSubview:_selectImage];
        [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverImage).offset(5);
            make.right.equalTo(_coverImage).offset(-5);
        }];
    }
    return self;
}

-(void)setIscamera:(BOOL)iscamera{
    
    _iscamera = iscamera;
    if (_iscamera) {
        _name.text=@"拍照上传";
        _coverImage.image=[UIImage imageNamed:@"customize_apply_camera"];
        _selectImage.hidden = YES;
    }
}
-(void)setOrderModel:(OrderMode *)orderModel{
    
    _orderModel = orderModel;
    [_coverImage jhSetImageWithURL:[NSURL URLWithString: ThumbSmallByOrginal(_orderModel.goodsUrl)] placeholder:kDefaultCoverImage];
       _name.text=_orderModel.goodsTitle;
}
@end
