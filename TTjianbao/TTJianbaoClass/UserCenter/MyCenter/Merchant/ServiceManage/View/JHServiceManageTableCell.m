//
//  JHServiceManageTableCell.m
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHServiceManageTableCell.h"

#define PlaceorderStr @"请输入此问题的自动回复内容，最多100字"

@interface JHServiceManageTableCell ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *titLable;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UITextView *txtV;

@property (nonatomic, strong) UILabel *expLab;

@property (nonatomic, strong) UILabel *numLable;

@property (nonatomic, strong) UIImageView *imgv;

@end

@implementation JHServiceManageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = kColorFFF;
    [_backView jh_cornerRadius:8];
    [self.contentView addSubview:_backView];
    
    _titLable = [UILabel new];
    _titLable.font = JHFont(16);
    _titLable.textColor = kColor333;
    [_backView addSubview:_titLable];

    //apprise_pay_protal_nomal  apprise_pay_protal_select
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button setImage:JHImageNamed(@"apprise_pay_protal_nomal") forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_button];
    
    _imgv = [UIImageView new];
    _imgv.userInteractionEnabled = NO;
    [_button addSubview:_imgv];
    
    
    _line = [[UIView alloc]init];
    _line.backgroundColor = HEXCOLOR(0xECECEC);
    [_backView addSubview:_line];
    
    _txtV =[[UITextView alloc]init];
    _txtV.text = PlaceorderStr;
    _txtV.textColor = HEXCOLOR(0xBBBBBB);
    _txtV.font = JHFont(14);
    _txtV.delegate = self;
    [_backView addSubview:_txtV];
    
    _numLable = [UILabel new];
    _numLable.text = @"0/100";
    _numLable.font = JHFont(12);
    _numLable.textColor = HEXCOLOR(0xBBBBBB);
    [_backView addSubview:_numLable];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_titLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-45);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];

    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(1);
    }];
    
    [_txtV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(_line.mas_bottom).offset(8);
        make.bottom.mas_equalTo(-41);
    }];
    
    [_numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-12);
    }];
}

- (void)setModel:(JHServiceManageItemModel *)model{
    _model = model;
    //标题
    _titLable.text = _model.quickReplyTerms;
    //内容
    if (_model.defaultReply.length > 0) {
        _txtV.text = _model.defaultReply;
        _txtV.textColor=kColor333;
    }else{
        _txtV.text = PlaceorderStr;
        _txtV.textColor = HEXCOLOR(0xBBBBBB);
    }
    //是否勾选
    NSString *imgStr = [_model.status intValue] == 1 ? @"apprise_pay_protal_select":@"apprise_pay_protal_nomal";
//    [_button setBackgroundImage:JHImageNamed(imgStr) forState:UIControlStateNormal];
//    [_button setImage:JHImageNamed(imgStr) forState:UIControlStateNormal];
    _imgv.image = JHImageNamed(imgStr);
}

- (void)buttonAction:(UIButton *)btn{
    _model.status = [_model.status intValue] == 1 ? @"0":@"1";
//    [_button setBackgroundImage:[_model.status intValue] == 1 ? JHImageNamed(@"apprise_pay_protal_select"):JHImageNamed(@"apprise_pay_protal_nomal") forState:UIControlStateNormal];
//    [_button setImage:[_model.status intValue] == 1 ? JHImageNamed(@"apprise_pay_protal_select"):JHImageNamed(@"apprise_pay_protal_nomal") forState:UIControlStateNormal];
    _imgv.image = [_model.status intValue] == 1 ? JHImageNamed(@"apprise_pay_protal_select"):JHImageNamed(@"apprise_pay_protal_nomal");
    
//    if ([self.delegate respondsToSelector:@selector(selectCell:)]) {
//        [self.delegate selectCell:_model];
//    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(textView.text.length < 1){
        textView.text = PlaceorderStr;
        textView.textColor = HEXCOLOR(0xBBBBBB);
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:PlaceorderStr]){
        textView.text=@"";
        textView.textColor=kColor333;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location>= 100)
    {
        return NO;
    } else{
         return YES;
     }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 100){
        textView.text = [textView.text substringToIndex:100];
    }
    _model.defaultReply = [textView.text isEqualToString:PlaceorderStr] ? @"":textView.text;
    _numLable.text = [NSString stringWithFormat:@"%ld/100",textView.text.length];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![_txtV isExclusiveTouch]) {
        [_txtV resignFirstResponder];
    }
}

- (void)setEditIndex:(int)editIndex{
    _editIndex = editIndex;
    /**
     1- 添加 可编辑
     2- 审核通过、审核拒绝 选中可编辑，非选中的不可编辑
     3- 审核中 均不可编辑
     */
    
    switch (_editIndex) {
        case 1:{
            _txtV.userInteractionEnabled = YES;
            _button.enabled = YES;
        }
            break;
        case 2:{
            if ([_txtV.text isEqualToString:PlaceorderStr]) {
                _txtV.userInteractionEnabled = NO;
                _button.enabled = NO;
            }else{
                _txtV.userInteractionEnabled = YES;
                _button.enabled = YES;
            }
        }
            break;
        case 3:{
            _txtV.userInteractionEnabled = NO;
            _button.enabled = NO;
        }
            break;
        default:
            break;
    }
}

@end
