//
//  AdressTableViewCell.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/19.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "AdressTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "UIButton+ImageTitleSpacing.h"

@interface AdressTableViewCell()

@property(strong,nonatomic)UIView *contentBack;
@property(strong,nonatomic)UILabel *name;
@property(strong,nonatomic)UILabel *phoneNum;
@property(strong,nonatomic)UILabel *adress;
@property(strong,nonatomic)UIButton *adressDefaultBtn;
@end
@implementation AdressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.backgroundColor = [UIColor clearColor];
        self.contentBack=[[UIView alloc]init];
        self.contentBack.backgroundColor=[UIColor whiteColor];
        self.contentBack.layer.cornerRadius = 8;
        self.contentBack.layer.masksToBounds = YES;
        [self.contentView addSubview:self.contentBack];
        [self.contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        _name=[[UILabel alloc]init];
        _name.text=@"";
        _name.font=[UIFont fontWithName:kFontMedium size:15];
        _name.backgroundColor=[UIColor clearColor];
        _name.textColor=kColor333;
        //saleName.adjustsFontSizeToFitWidth = YES;
        _name.numberOfLines = 0;
        _name.textAlignment = NSTextAlignmentLeft;
         _name.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_name];
        
        _phoneNum=[[UILabel alloc]init];
        _phoneNum.text=@"";
        _phoneNum.font=[UIFont fontWithName:kFontMedium size:15];
        _phoneNum.backgroundColor=[UIColor clearColor];
        _phoneNum.textColor=kColor333;
        //saleName.adjustsFontSizeToFitWidth = YES;
        _phoneNum.numberOfLines = 1;
        _phoneNum.textAlignment = NSTextAlignmentLeft;
         _phoneNum.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_phoneNum];

        _adress=[[UILabel alloc]init];
        _adress.text=@"";
        _adress.font=[UIFont fontWithName:kFontNormal size:12];
        _adress.backgroundColor=[UIColor clearColor];
         _adress.preferredMaxLayoutWidth=ScreenW;
        _adress.textColor=kColor666;
        _adress.numberOfLines = 0;
        _adress.preferredMaxLayoutWidth = ScreenW-20;
        _adress.textAlignment = NSTextAlignmentLeft;
         _adress.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentBack addSubview:_adress];

        UIView *line=[[UIView alloc]init];
         line.backgroundColor=[UIColor colorWithRed:0.92f green:0.91f blue:0.92f alpha:1.00f];
        [self.contentBack addSubview:line];
        
        _adressDefaultBtn = [[UIButton alloc] init];
        _adressDefaultBtn.backgroundColor = [UIColor clearColor];
        _adressDefaultBtn.contentMode=UIViewContentModeScaleToFill;
        [_adressDefaultBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [_adressDefaultBtn setTitleColor:[UIColor colorWithRed:0.23f green:0.23f blue:0.23f alpha:1.00f]  forState:UIControlStateNormal];
        _adressDefaultBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        _adressDefaultBtn.tag=setDefault;
        [_adressDefaultBtn setImage:[UIImage imageNamed:@"order_return_class_icon.png"] forState:UIControlStateNormal];
        [_adressDefaultBtn setImage:[UIImage imageNamed:@"order_return_class_icon_select.png"] forState:UIControlStateSelected];
        [_adressDefaultBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat space =5;
        [_adressDefaultBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                           imageTitleSpace:space];
              [self.contentBack addSubview:_adressDefaultBtn];
    
        
        UIButton *editBtn = [[UIButton alloc] init];
        editBtn.backgroundColor = [UIColor clearColor];
        editBtn.contentMode=UIViewContentModeScaleToFill;
         editBtn.tag=setEdit;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor colorWithRed:0.23f green:0.23f blue:0.23f alpha:1.00f]   forState:UIControlStateNormal];
        editBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [editBtn setImage:[UIImage imageNamed:@"adress_edit.png"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                           imageTitleSpace:space];
        [self.contentBack addSubview:editBtn];
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        deleteBtn.backgroundColor = [UIColor clearColor];
         deleteBtn.tag=setDelete;
        deleteBtn.contentMode=UIViewContentModeScaleToFill;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor colorWithRed:0.23f green:0.23f blue:0.23f alpha:1.00f]   forState:UIControlStateNormal];
        deleteBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [deleteBtn setImage:[UIImage imageNamed:@"adress_delete.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                 imageTitleSpace:space];
        [self.contentBack addSubview:deleteBtn];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentBack).offset(10);
            make.left.equalTo(self.contentBack).offset(10);
             // make.right.equalTo(self.content).offset(-10);

        }];
        [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(_name);
              make.left.equalTo(_name.mas_right).offset(5);
            
            
        }];

        [_adress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name.mas_bottom).offset(10);
            
            make.left.equalTo(self.name).offset(0);
            make.right.equalTo(self.contentBack).offset(-10);
          
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_adress.mas_bottom).offset(10);
            make.right.equalTo(self.contentBack);
            make.left.equalTo(_name);
            make.height.equalTo(@0.5);
            
        }];
        
        [_adressDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(line.mas_bottom).offset(10);
            make.left.equalTo(_name);
            make.width.equalTo(@100);
            
        }];

        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.centerY.equalTo(_adressDefaultBtn);
              make.width.equalTo(@60);
              make.right.equalTo(self.contentBack.mas_right).offset(-10);
            
        }];
        

        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_adressDefaultBtn);
            make.right.equalTo(deleteBtn.mas_left).offset(0);
            make.width.equalTo(@60);
            make.bottom.equalTo(self.contentBack.mas_bottom).offset(-10);
        }];
        
    }
    return self;
}

-(void)setAdressMode:(AdressMode *)adressMode{
    
    
       _adressMode=adressMode;
        _adress.text=[NSString stringWithFormat:@"%@ %@ %@ %@",_adressMode.province,_adressMode.city,_adressMode.county,_adressMode.detail];
        _phoneNum.text=_adressMode.phone;
        _name.text=_adressMode.receiverName;
       _adressDefaultBtn.selected=NO;
       if (_adressMode.isDefault)  {
        _adressDefaultBtn.selected=YES;
    }

}
-(void)btnClick:(UIButton*)sender {
     [self.delegate buttonPress:sender cellIndex:self.cellIndex];
}

-(void)setCellIndex:(NSInteger)cellIndex{

    _cellIndex=cellIndex;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
