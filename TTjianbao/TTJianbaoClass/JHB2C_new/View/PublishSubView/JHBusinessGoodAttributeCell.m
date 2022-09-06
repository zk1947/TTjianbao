//
//  JHBusinessGoodAttributeCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessGoodAttributeCell.h"
#import "JHBusinessGoodsAttributeModel.h"

@interface JHBusinessGoodAttributeArrowCell()
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * placeholderLbl;
@property(nonatomic, strong) UIImageView * starImageView;
@end

@implementation JHBusinessGoodAttributeArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;

        [self creatCellItem];
    }
    return self;
}

- (void)creatCellItem{
    [self setItems];
}
- (void)setCellTitle:(NSString *)title andIsRequired:(int)required andShowStr:(NSString *)showStr{
    self.titleLbl.text = title;
    self.starImageView.hidden = (required == 0);
    if (showStr.length>0) {
        self.placeholderLbl.text = showStr;
        if([showStr containsString:@"其它-"]){
            self.placeholderLbl.text = [showStr substringFromIndex:3];
        }
    }else{
        self.placeholderLbl.text = [NSString stringWithFormat:@"请选择%@",title];
    }
}
- (void)setItems{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.starImageView];
    [self.contentView addSubview:self.placeholderLbl];
    [self layoutItems];
    UIImageView * seleImage2 = [[UIImageView alloc] init];
    seleImage2.image = [UIImage imageNamed:@"icon_cell_arrow"];
    [self.contentView addSubview:seleImage2];
    [seleImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).inset(10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(30);
        make.right.equalTo(self);
    }];
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.top.equalTo(@0).offset(14);
        make.left.mas_equalTo(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(2);
    }];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-30);
        make.height.equalTo(@24);
        make.top.equalTo(self.titleLbl.mas_top);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(30);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        NSString *placeStr = @"请选择";
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.text = placeStr;
        label.numberOfLines = 0;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}



- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@interface JHBusinessGoodAttributeCell()<UITextFieldDelegate>
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UITextField * textView;
@property(nonatomic, strong) UIImageView * starImageView;
@property(nonatomic, strong) JHBusinessGoodsAttributeModel * datamodel;

@end

@implementation JHBusinessGoodAttributeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

        [self creatCellItem];
    }
    return self;
}

- (void)creatCellItem{
    [self setItems];
}

- (void)setItems{
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.starImageView];
    [self.contentView addSubview:self.textView];
    [self layoutItems];
}
- (void)setCellTitle:(NSString *)title andIsRequired:(int)required andShowStr:(NSString *)showStr{
    self.titleLbl.text = title;
    self.starImageView.hidden = (required == 0);
    if (showStr.length==0) {
        self.textView.placeholder = [NSString stringWithFormat:@"请输入%@",title];
    }else{
        self.textView.text = showStr;
    }
    
}
- (void)setDataModel:(JHBusinessGoodsAttributeModel *)model{
    self.datamodel = model;
}
- (void)layoutItems{
    [self.titleLbl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.top.equalTo(@0).offset(14);
        make.left.mas_equalTo(12);
    }];
    [self.starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(2);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.height.equalTo(@24);
        make.top.mas_equalTo(self.titleLbl.mas_top);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(30);
    }];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.titleLbl.mas_right).offset(30);
        make.right.equalTo(self);
    }];
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UITextField *)textView{
    if (!_textView) {
        UITextField *view = [UITextField new];
        view.font = JHFont(13);
        view.placeholder = @"请输入";
        view.delegate = self;
        view.textColor = HEXCOLOR(0x222222);
        view.tintColor = HEXCOLOR(0xFED73A);
        _textView = view;
    }
    return _textView;
}

- (UIImageView *)starImageView{
    if (!_starImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
        _starImageView = view;
    }
    return _starImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger maxlenth = 20;
    if (textField.text.length + string.length > maxlenth) {return NO;}

    
    return YES;
}
-(void)textFieldChanged:(NSNotification *)obj{
    self.datamodel.showValue = self.textView.text;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
