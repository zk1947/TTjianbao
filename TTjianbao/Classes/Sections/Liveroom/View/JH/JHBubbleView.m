//
//  JHBubbleView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/5/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBubbleView.h"
#import "CommHelp.h"

@interface JHBubbleView ()
{
    JHActionBlock activeClick;
}
@property(strong,nonatomic)UILabel * titleLabel;
@property(strong,nonatomic)  UIImageView * bubbleImage;
@property(strong,nonatomic)  UIImageView * bubbleArrowImage;
@property(strong,nonatomic)  UIButton * cancleBtn;
@end
@implementation JHBubbleView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubbleImage=[[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"live_newpaopao_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5,0,35) resizingMode:UIImageResizingModeStretch]];
        _bubbleImage.contentMode=UIViewContentModeScaleToFill;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
        [_bubbleImage addGestureRecognizer:tapGesture];
        _bubbleImage.userInteractionEnabled=YES;
        [self addSubview:_bubbleImage];
        
        [_bubbleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.offset(23);
            make.width.greaterThanOrEqualTo(@50);
        }];
        
        _bubbleArrowImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bubble_jiao"]];
//        _bubbleArrowImage.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:_bubbleArrowImage];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont systemFontOfSize:11];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _titleLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_bubbleImage addSubview:_titleLabel];
        
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setBackgroundImage:[UIImage imageNamed:@"bubule_cancle"] forState:UIControlStateNormal ];
        // _cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
        //  [_cancleBtn addTarget:self action:@selector(diss:) forControlEvents:UIControlEventTouchUpInside];
        [_bubbleImage addSubview:_cancleBtn];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bubbleImage).offset(0);
            make.right.equalTo(_bubbleImage).offset(0);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bubbleImage).offset(0);
            make.left.equalTo(_bubbleImage).offset(10);
            make.right.equalTo(_cancleBtn.mas_left).offset(-10);
        }];
    }
    return self;
}

- (void)setTitle:(NSString*)title andArrowDirection:(JHBubbleViewArrowDirection)direction click:(JHActionBlock)action
{
    activeClick = action;
    
    _titleLabel.font=[UIFont systemFontOfSize:13];
    [self setTitle:title andArrowDirection:direction];

    [_bubbleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.bottom.left.right.equalTo(self);
           make.height.offset(33);
           make.width.greaterThanOrEqualTo(@70);
       }];
}

-(void)setTitle:(NSString*)title andArrowDirection:(JHBubbleViewArrowDirection)direction{
    
    self.titleLabel.text=title;
    switch (direction) {
        case JHBubbleViewArrowDirectionenBottomRight:
        {
            [_bubbleArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bubbleImage.mas_bottom).offset(-1);
                make.right.equalTo(_bubbleImage).offset(-20);
                make.bottom.equalTo(self);
            }];
        }
            break;
        case JHBubbleViewArrowDirectionenBottomCenter:
        {
            [_bubbleArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bubbleImage.mas_bottom).offset(-1);
                make.centerX.equalTo(_bubbleImage);
                make.size.mas_equalTo(CGSizeMake(11, 4));
                make.bottom.equalTo(self);
            }];
        }
            break;
        case JHBubbleViewArrowDirectionenTopCenter:
        {
            
            _bubbleArrowImage.image = [UIImage imageNamed:@"icon_bubule_top"];
            [_bubbleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self);
                make.height.offset(23);
                make.width.greaterThanOrEqualTo(@80);
            }];
            [_bubbleArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_bubbleImage.mas_top).offset(1);
                make.centerX.equalTo(_bubbleImage);
                make.top.equalTo(self);
            }];
        }
            break;
        case JHBubbleViewArrowDirectionenTopRight:
        {
            
            _bubbleArrowImage.image = [UIImage imageNamed:@"icon_bubule_top"];
            [_bubbleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self);
                make.height.offset(23);
                make.width.greaterThanOrEqualTo(@80);
            }];
            [_bubbleArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_bubbleImage.mas_top).offset(1);
                make.right.equalTo(_bubbleImage).offset(-20);
                make.top.equalTo(self);
            }];
        }
            break;
            
        default:
            break;
    }
    
}
-(void)setShowCancleBtn:(BOOL)showCancleBtn{
    
    _showCancleBtn=showCancleBtn;
    if (showCancleBtn) {
        
        [_cancleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bubbleImage).offset(0);
            make.right.equalTo(_bubbleImage).offset(-10);
            make.size.mas_equalTo(CGSizeMake(7, 7));
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bubbleImage).offset(0);
            make.left.equalTo(_bubbleImage).offset(10);
            make.right.equalTo(_cancleBtn.mas_left).offset(-5);
        }];
        
    }
    
    
}
-(void)setBubbleUserInteractionEnabled:(BOOL)bubbleUserInteractionEnabled{
    
    _bubbleImage.userInteractionEnabled=bubbleUserInteractionEnabled;
}
-(void)imageTap{
    if(activeClick)
    {
        activeClick(nil);
    }
    else
        [self removeFromSuperview];
}
@end
