//
//  JHPalteAboutTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPalteAboutTableViewCell.h"
#import "NSString+LNExtension.h"
#import "JHFoucsPlateModel.h"
#import "UserFriendApiManager.h"
#import "JHPlateDetailModel.h"

@interface JHPalteAboutTableViewCell()

@property (nonatomic, strong) UIImageView *avatorImage;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end
@implementation JHPalteAboutTableViewCell
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
        make.top.equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(70);
    }];
    
    _nickNameLabel = [UILabel jh_labelWithFont:20 textColor:HEXCOLOR(0x333333) addToSuperView:self.contentView];
    _nickNameLabel.font = JHMediumFont(20);
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatorImage.mas_right).offset(10.f);
        make.top.equalTo(_avatorImage).offset(9);
        make.width.mas_lessThanOrEqualTo(ScreenW-100.f);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0x999999) addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(5);
        make.width.mas_lessThanOrEqualTo(ScreenW-100.f);
    }];
}
-(void)setDataWithCell:(JHPlateDetailModel *)model{
    _descLabel.text = [NSString stringWithFormat:@"%@阅读·%@评论·%@篇内容",model.scan_num,model.comment_num,model.content_num];
    
    _nickNameLabel.text = model.name;
    
    [_avatorImage jh_setImageWithUrl:model.image];
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

@interface JHPalteAboutDescTableViewCell ()
@property (nonatomic, strong) UILabel *descLabel;
@end
@implementation JHPalteAboutDescTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUICell];
    }
    return self;
}

- (void)creatUICell{
    _descLabel = [UILabel jh_labelWithFont:15 textColor:RGB102102102 addToSuperView:self.contentView];
    _descLabel.numberOfLines = 0;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(0);
        
    }];
}

- (void)updateUI:(NSString *)str{
    if (str.length == 0) {
        return;
    }
    NSMutableParagraphStyle * pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.lineSpacing = 7;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:pstyle};
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    _descLabel.attributedText = attStr;
}

+ (CGSize)cellHeight:(NSString*)str{
    
    NSMutableParagraphStyle * pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.lineSpacing = 7;
    CGSize size = [NSString sizeWithStringWithParagraphStyle:str font:JHFont(15) paragraphStyle:pstyle WithSize:CGSizeMake(ScreenW-20, MAXFLOAT)];
    return size;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end

@interface JHPalteAboutModerTableViewCell ()
@property (nonatomic, strong) UIImageView *avatorImage;
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *foucsButton;
@property (nonatomic, strong) JHPublisher* model;
@end
@implementation JHPalteAboutModerTableViewCell

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
    [_avatorImage jh_cornerRadius:20];
    [_avatorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(14);
        make.width.height.mas_equalTo(40);
    }];
    
    _nickNameLabel = [UILabel jh_labelWithFont:18 textColor:HEXCOLOR(0x333333) addToSuperView:self.contentView];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatorImage.mas_right).offset(10.f);
        make.centerY.mas_equalTo(self.avatorImage.mas_centerY);
        make.width.mas_lessThanOrEqualTo(ScreenW-150.f);
    }];
    
    _foucsButton = [UIButton jh_buttonWithTitle:@"已关注" fontSize:12 textColor:HEXCOLOR(0xBDBFC2) target:self action:@selector(foucsMethod) addToSuperView:self.contentView];
    [_foucsButton jh_cornerRadius:15 borderColor:RGB(153, 153, 153) borderWidth:1];
    [_foucsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatorImage);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(56, 30));
    }];
    
    _lineview = [[UIView alloc] init];
    _lineview.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self.contentView addSubview:_lineview];
    [_lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(_nickNameLabel.mas_left);
        make.height.mas_equalTo(1);

    }];
}

- (void)updateFollowBtnStatus {
    [_foucsButton setTitle:self.model.is_follow ? @"已关注" : @"关注" forState:UIControlStateNormal];
    UIImage *bgImage =  self.model.is_follow ? [UIImage imageWithColor:[UIColor whiteColor]] : JHImageNamed(@"jh_img_link_bg");
    UIColor *titleColor = self.model.is_follow ? kColor999 : kColor333;
    UIColor *titleHLColor = self.model.is_follow ? kColor999 : kColor333;
    UIColor *borderColor = self.model.is_follow ? HEXCOLOR(0xBDBFC2) : [UIColor clearColor];
    CGFloat borderWidth = self.model.is_follow ? 0.5 : 0;
    
    [_foucsButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_foucsButton setBackgroundImage:bgImage forState:UIControlStateDisabled];
    
    [_foucsButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_foucsButton setTitleColor:titleHLColor forState:UIControlStateHighlighted];
    
    _foucsButton.layer.borderWidth = borderWidth;
    _foucsButton.layer.borderColor = borderColor.CGColor;
}

- (void)foucsMethod {
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.foucsButton.activityView.transform = transform;
    [self.foucsButton startQueryAnimate];


    @weakify(self);
    if (self.model.is_follow) {
        //发起取消关注请求
        [UserFriendApiManager cancelFollowWithUserId:[self.model.user_id integerValue] fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            @strongify(self);
            if(!hasError){
                [self.foucsButton stopQueryAnimate];
                self.model.is_follow = !self.model.is_follow;
                [self updateFollowBtnStatus];
            }
            
        }];
    
    } else {
        //发起关注请求
        [UserFriendApiManager followWithUserId:[self.model.user_id integerValue] fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            @strongify(self);
            if(!hasError){
                [self.foucsButton stopQueryAnimate];
                self.model.is_follow = !self.model.is_follow;
                [self updateFollowBtnStatus];
            }
            
        }];
    }
    
    
}
//JHPlateDetailModel
-(void)resetCellDataWithModel:(JHPublisher*)model
{
    if (!model) {
        return;
    }
    self.model = model;
    _nickNameLabel.text = model.user_name;
   
    [_avatorImage jh_setImageWithUrl:model.avatar];

    [self updateFollowBtnStatus];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
