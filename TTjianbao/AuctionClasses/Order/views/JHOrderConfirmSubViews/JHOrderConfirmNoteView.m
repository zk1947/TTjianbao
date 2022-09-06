//
//  JHOrderConfirmNoteView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmNoteView.h"

@interface JHOrderConfirmNoteView ()<UITextViewDelegate>
@property(nonatomic,strong)  UILabel * titleTip;
@end
@implementation JHOrderConfirmNoteView
-(void)setSubViews{
    
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"订单备注:";
    title.font=[UIFont systemFontOfSize:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[CommHelp toUIColorByStr:@"#333333"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(9);
        make.width.equalTo(self);
        }];
    
       _noteTextview=[[UITextView alloc]init];
       _noteTextview.backgroundColor=[UIColor clearColor];
       _noteTextview.font = [UIFont fontWithName:@"Arial" size:14.0];
       _noteTextview.alpha=1.0;
       _noteTextview.delegate=self;
       _noteTextview.autocorrectionType = UITextAutocorrectionTypeYes;
       _noteTextview.autocapitalizationType = UITextAutocapitalizationTypeNone;
       _noteTextview.keyboardType = UIKeyboardTypeDefault;
       _noteTextview.returnKeyType = UIReturnKeyDone;
       [self addSubview:_noteTextview];
    
          [_noteTextview mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(title.mas_bottom).offset(0);
              make.left.equalTo(self).offset(5);
              make.right.equalTo(self).offset(-5);
              make.bottom.equalTo(self).offset(-10);
          }];

       _titleTip=[[UILabel alloc]init];
       _titleTip.text=@"在此输入您的备注要求";
       _titleTip.font=[UIFont systemFontOfSize:14];
       _titleTip.backgroundColor=[UIColor clearColor];
       _titleTip.textColor=[CommHelp toUIColorByStr:@"#999999"];
       _titleTip.numberOfLines = 1;
       _titleTip.textAlignment = UIControlContentHorizontalAlignmentCenter;
       _titleTip.lineBreakMode = NSLineBreakByWordWrapping;
       [_noteTextview addSubview:_titleTip];

       [_titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(title.mas_bottom).offset(8);
           make.left.equalTo(_noteTextview).offset(7);
           make.width.equalTo(_noteTextview);
       }];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [_titleTip setHidden:NO];
    }else{
        [_titleTip setHidden:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
