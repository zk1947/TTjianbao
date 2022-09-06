//
//  JHAppraisalReportView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAppraisalContentView.h"
#import "TTjianbaoHeader.h"
#import "AppraisalDetailMode.h"
#import "NSString+AttributedString.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"

@interface JHAppraisalContentView ()
{
    UIButton *careBtn;
    UILabel * priceTitle;
}
@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UIButton *likeImage;
@property (strong, nonatomic)  UILabel* desc;
@property (strong, nonatomic)  UILabel *profession;
@property (strong, nonatomic)  UILabel *price;
@property (strong, nonatomic)  UILabel *likeCount;
@property (strong, nonatomic)  UILabel *commentCount;
@end


@implementation JHAppraisalContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
      return self;
}

- (void)setupSubviews {
    
    _contentView=[[UIView alloc]init];
    _contentView.backgroundColor=[UIColor whiteColor];
    _contentView.userInteractionEnabled=YES;
     [self addSubview:_contentView];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];

    _name=[[UILabel alloc]init];
    _name.text=@"";
    _name.font=[UIFont boldSystemFontOfSize:16];
    _name.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _name.numberOfLines = 1;
    _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _name.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_name];

    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(15);
        make.top.equalTo(_contentView).offset(20);
    }];

    UIImageView *professionLogo=[[UIImageView alloc]init];
    professionLogo.image=[UIImage imageNamed:@"appraisal_video_auth"];
    professionLogo.contentMode=UIViewContentModeScaleAspectFit;
    [_contentView addSubview:professionLogo];

    [professionLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(_name);
        make.left.equalTo(_name.mas_right).offset(10);
    }];

    _profession=[[UILabel alloc]init];
    _profession.text=@"";
    _profession.font=[UIFont systemFontOfSize:14];
    _profession.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _profession.numberOfLines = 1;
    _profession.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _profession.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_profession];

    [_profession mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(professionLogo);
        make.left.equalTo(professionLogo.mas_right).offset(5);
       
    }];
    
    careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [careBtn setImage:[UIImage imageNamed:@"appraisal_video_care_select"] forState:UIControlStateNormal];
    [careBtn setImage:[UIImage imageNamed:@"appraisal_video_care"] forState:UIControlStateSelected];
    careBtn.contentMode=UIViewContentModeScaleAspectFit;
    [careBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    careBtn.userInteractionEnabled=YES;
    [_contentView addSubview:careBtn];
    [careBtn setSelected:NO];

     [careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(professionLogo);
        make.right.equalTo(_contentView).offset(-10);
     
    }];
    
    _desc=[[UILabel alloc]init];
    _desc.text=@"暂无鉴定报告";
    _desc.font=[UIFont systemFontOfSize:14];
    _desc.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _desc.numberOfLines = 0;
    //  _desc.backgroundColor=[UIColor yellowColor];
    _desc.preferredMaxLayoutWidth = ScreenW-35;
    _desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _desc.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_desc];

    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name.mas_bottom).offset(13);
        make.left.equalTo(_contentView).offset(15);
        make.right.equalTo(_contentView).offset(-20);
    }];

    priceTitle=[[UILabel alloc]init];
  //  priceTitle.backgroundColor=[UIColor redColor];
    priceTitle.font=[UIFont systemFontOfSize:12];
    priceTitle.textColor=[CommHelp toUIColorByStr:@"#666666"];
    priceTitle.numberOfLines = 1;
    priceTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    priceTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:priceTitle];

    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_desc.mas_bottom).offset(10);
        make.left.equalTo(_name);

    }];

    _price=[[UILabel alloc]init];
    _price.text=@"";
   //   _price.backgroundColor=[UIColor yellowColor];
     _price.font = [UIFont fontWithName:kFontBoldDIN size:30.f];
    _price.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    _price.numberOfLines = 1;
    _price.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _price.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_price];

    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceTitle.mas_bottom).offset(8);
        make.left.equalTo(_name);
    }];

    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"appraisal_content_zan"] forState:UIControlStateNormal];
    likeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_contentView addSubview:likeBtn];

    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price.mas_bottom).offset(12);
        make.left.equalTo(_name);

    }];

    _likeCount=[[UILabel alloc]init];
    _likeCount.text=@"赞";
    _likeCount.font=[UIFont systemFontOfSize:15];
    _likeCount.textColor=[CommHelp toUIColorByStr:@"333333"];
    _likeCount.numberOfLines = 1;
    _likeCount.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _likeCount.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_likeCount];

    [_likeCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeBtn);
        make.left.equalTo(likeBtn.mas_right).offset(7);
    }];

    UIButton * commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"appraisal_content_message"] forState:UIControlStateNormal];
    commentBtn.contentMode=UIViewContentModeScaleAspectFit;
    [_contentView addSubview:commentBtn];

    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeBtn);
        make.left.equalTo(_likeCount.mas_right).offset(30);
      
    }];

    _commentCount=[[UILabel alloc]init];
    _commentCount.text=@"评论";
    _commentCount.font=[UIFont systemFontOfSize:15];
    _commentCount.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _commentCount.numberOfLines = 1;
    _commentCount.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _commentCount.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentView addSubview:_commentCount];

    [_commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentBtn);
        make.left.equalTo(commentBtn.mas_right).offset(7);
    }];
    
    UIView *bottomView =[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [_contentView addSubview:bottomView];

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentBtn.mas_bottom).offset(20);
        make.left.right.equalTo(_contentView);
        make.height.offset(10);
        make.bottom.equalTo(_contentView);
    }];
    
}
-(void)onClickBtnAction:(UIButton*)sender{
    
    if (self.delegate) {
        [self.delegate pressCare:sender];
    }
}
-(void)setAppraisalDetail:(AppraisalDetailMode *)appraisalDetail{
    
    _appraisalDetail=appraisalDetail;
    _name.text=_appraisalDetail.appraiser.nick;
    _profession.text=_appraisalDetail.appraiser.authInfo;
  
    if (_appraisalDetail.assessmentReport ) {
          _desc.text=_appraisalDetail.assessmentReport;
         [UILabel changeLineSpaceForLabel:_desc WithSpace:5.0];
    }
    if (_appraisalDetail.price ) {
        
         priceTitle.text=@"天天鉴宝估价";
       _price.attributedText=[[NSString stringWithFormat:@"¥ %@",_appraisalDetail.priceStr] formatePriceFontSize:30 color:HEXCOLOR(0xFF4200)];
    }
    else{
        [priceTitle setHidden:YES];
        [_price setHidden:YES];
        
    }
    _likeCount.text=[NSString stringWithFormat:@"%@  赞",_appraisalDetail.lauds];
    _commentCount.text=[NSString stringWithFormat:@"%@  评论",_appraisalDetail.comments];
    
    if (_appraisalDetail.isFollow) {
        [careBtn setSelected:YES];
    }
    else{
        [careBtn setSelected:NO];
    }
   
    
}
-(void)setIsCare:(BOOL)isCare{
    
    _isCare=isCare;
    if (isCare) {
        [careBtn setSelected:YES];
    }
    else{
        [careBtn setSelected:NO];
    }
}
@end

