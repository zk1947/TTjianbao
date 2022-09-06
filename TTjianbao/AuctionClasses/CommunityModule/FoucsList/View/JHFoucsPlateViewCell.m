//
//  JHFoucsPlateViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsPlateViewCell.h"
#import "JHFoucsPlateModel.h"
#import <YDCategoryKit/YDCategoryKit.h>

@interface JHFoucsPlateViewCell()

@property (nonatomic, strong) UIImageView *avatorImage;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *foucsButton;
@property (nonatomic, strong)JHFoucsPlateModel* model;
@end

@implementation JHFoucsPlateViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUICell];
    }
    return self;
}

-(void)creatUICell
{
    _avatorImage = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_avatorImage jh_cornerRadius:8];
    [_avatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(60);
    }];
    
    _nickNameLabel = [UILabel jh_labelWithFont:18 textColor:HEXCOLOR(0x333333) addToSuperView:self.contentView];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatorImage.mas_right).offset(10.f);
        make.top.equalTo(_avatorImage).offset(6);
        make.width.mas_lessThanOrEqualTo(ScreenW-150.f);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:13 textColor:HEXCOLOR(0x999999) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(5);
        make.width.mas_lessThanOrEqualTo(ScreenW-150.f);
    }];
    
    _foucsButton = [UIButton jh_buttonWithTitle:@"已关注" fontSize:12 textColor:HEXCOLOR(0xBDBFC2) target:self action:@selector(foucsMethod) addToSuperView:self.contentView];
    [_foucsButton jh_cornerRadius:15 borderColor:RGB(153, 153, 153) borderWidth:1];
    [_foucsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorImage);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(56, 30));
    }];
}

- (void)updateFollowBtnStatus {
    [_foucsButton setTitle:self.model.is_follow ? @"已关注" : @"关注" forState:UIControlStateNormal];
    UIColor *bgColor =  self.model.is_follow ? [UIColor whiteColor] : kColorMain;
    UIColor *titleColor = self.model.is_follow ? kColor999 : kColor333;
    UIColor *titleHLColor = self.model.is_follow ? kColor999 : kColor333;
    UIColor *borderColor = self.model.is_follow ? HEXCOLOR(0xBDBFC2) : [UIColor clearColor];
    CGFloat borderWidth = self.model.is_follow ? 0.5 : 0;
    
    [_foucsButton setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    [_foucsButton setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateDisabled];
    
    [_foucsButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_foucsButton setTitleColor:titleHLColor forState:UIControlStateHighlighted];
    
    _foucsButton.layer.borderWidth = borderWidth;
    _foucsButton.layer.borderColor = borderColor.CGColor;
}

- (void)foucsMethod {
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.foucsButton.activityView.transform = transform;
    [self.foucsButton startQueryAnimate];
    //_collectBtn.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    @weakify(self);
    self.foucsButton.enabled = NO;
    //发起关注请求
    [JHFoucsPlateModel foucsPlateWithModel:self.model isCancel:self.model.is_follow completeBlock:^{
        @strongify(self);
        [self.foucsButton stopQueryAnimate];
        self.foucsButton.enabled = YES;
        self.model.is_follow = !self.model.is_follow;
        [self updateFollowBtnStatus];
    }failBlock:^{
        self.foucsButton.enabled = YES;
    }];

}
-(void)resetCellDataWithModel:(JHFoucsPlateModel*)model
{
    if (!model) {
        return;
    }
    self.model = model;
    _descLabel.text = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容",self.model.scan_num,self.model.comment_num,self.model.content_num];
       
    _nickNameLabel.text = model.channel_name;
    NSString * url = [model.image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [_avatorImage jh_setImageWithUrl:url];
    [self updateFollowBtnStatus];
}

-(void)updateUI
{
    _descLabel.text = @"5件商品 | 6个粉丝";
    
    _nickNameLabel.text = @"娃哈哈";
    
    [_avatorImage jh_setAvatorWithUrl:@"http://sq-image.ttjianbao.com/images/b7af4b7fae567711848eb26eea715abc.png?x-oss-process=image/resize,w_100"];
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
