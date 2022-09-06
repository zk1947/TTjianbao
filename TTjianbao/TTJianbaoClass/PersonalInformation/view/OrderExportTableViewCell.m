//
//  OrderExportTableViewCell.m
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "OrderExportTableViewCell.h"
#import "CommHelp.h"

@interface OrderExportTableViewCell ()
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel* time;

@end
@implementation OrderExportTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _title=[[UILabel alloc]init];
        _title.text=@"订单时间";
        _title.font=[UIFont boldSystemFontOfSize:12];
        _title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _title.numberOfLines = 2;
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(10);
            
        }];
        
        _time=[[UILabel alloc]init];
        _time.text=@"导出时间";
        _time.font=[UIFont boldSystemFontOfSize:12];
        _time.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _time.numberOfLines = 1;
        _time.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _time.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_time];
        
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title.mas_bottom).offset(8);
            make.right.equalTo(self.contentView).offset(-5);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        UIButton  *button=[[UIButton alloc]init];
        [button setTitle:@"导出" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
//        [button setBackgroundImage:[UIImage imageNamed:@"order_downLoad_image"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"order_downLoad_image"] forState:UIControlStateSelected];
         [button setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
         button.backgroundColor=[CommHelp toUIColorByStr:@"#fee100"];
         button.layer.cornerRadius =15;
        [button addTarget:self action:@selector(export) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(65, 30));
        }];
    
    }
    return self;
}
-(void)export{
    
    if (self.buttonClick) {
        self.buttonClick(self.indexPath);
    }
}
-(void)setMode:(ExportOrderMode *)mode{
    
    _mode=mode;
    
    NSString * string=[NSString stringWithFormat:@"订单时间:%@",_mode.orderTime];
    NSRange  range1 =[string rangeOfString:@"订单时间:"];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range1];
    [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range1];
    _title.attributedText=attString;

    NSString * string2=[NSString stringWithFormat:@"导出时间:%@",_mode.exportDate];
    NSRange  range2 =[string2 rangeOfString:@"导出时间:"];
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range2];
    [attString2 addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#333333"] range:range2];
    _time.attributedText=attString2;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
