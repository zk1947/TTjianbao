//
//  JHImageAppraisalFinishedCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageAppraisalFinishedCell.h"
#import "UIView+UIHelp.h"
#import "JHWebViewController.h"
@interface JHImageAppraisalFinishedCell ()
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *headImgV;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UILabel *timeLable;

@property (nonatomic, strong) UILabel *priceLable;

@property (nonatomic, strong) UILabel *priceLable2;

@property (nonatomic, strong) UILabel *contentLable;

@property (nonatomic, strong) UIImageView *reportimage;

@property (nonatomic, strong) UIImageView *contentImgV1;

@property (nonatomic, strong) UIImageView *contentImgV2;

@property (nonatomic, strong) UIImageView *contentImgV3;

@property (nonatomic, strong) UIImageView *contentImgV4;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *causeLable;

@property (nonatomic, strong) UILabel *orderLable;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *imgsArr;

@property (nonatomic, copy) NSString *orderid;
@end

@implementation JHImageAppraisalFinishedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.imgsArr = [NSMutableArray array];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = kColorFFF;
    [_backView jh_cornerRadius:8];
    [self.contentView addSubview:_backView];
    
    _headImgV = [[UIImageView alloc]init];
    [_headImgV jh_cornerRadius:18];
    [_backView addSubview:_headImgV];
    
    _nameLable = [UILabel new];
    _nameLable.font = JHMediumFont(12);
    _nameLable.textColor = HEXCOLOR(0x000000);
    [_backView addSubview:_nameLable];
    
    _timeLable = [UILabel new];
    _timeLable.font = JHFont(11);
    _timeLable.textColor = kColor999;
    [_backView addSubview:_timeLable];
    
    _priceLable = [UILabel new];
    _priceLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:20];
    _priceLable.textColor = kColor333;
    [_backView addSubview:_priceLable];
    
    _priceLable2 = [UILabel new];
    _priceLable2.text = @"￥";
    _priceLable2.font = [UIFont fontWithName:@"DINAlternate-Bold" size:13];
    _priceLable2.textColor = kColor333;
    [_backView addSubview:_priceLable2];
    
    _reportimage = [[UIImageView alloc]init];
    [_reportimage jh_cornerRadius:8];
    [_backView addSubview:_reportimage];
    
    _contentLable = [UILabel new];
    _contentLable.font = JHFont(14);
    _contentLable.textColor = kColor333;
    _contentLable.numberOfLines = 0;
    [_backView addSubview:_contentLable];
    
    _contentImgV1 = [[UIImageView alloc]init];
    [_contentImgV1 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV1];
    
    _contentImgV2 = [[UIImageView alloc]init];
    _contentImgV2.backgroundColor = [UIColor cyanColor];
    [_contentImgV2 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV2];
    
    _contentImgV3 = [[UIImageView alloc]init];
    [_contentImgV3 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV3];
    
    _contentImgV4 = [[UIImageView alloc]init];
    [_contentImgV4 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV4];

    [self.imgsArr addObject:_contentImgV1];
    [self.imgsArr addObject:_contentImgV2];
    [self.imgsArr addObject:_contentImgV3];
    [self.imgsArr addObject:_contentImgV4];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [_backView addSubview:_lineView];
    
    _causeLable = [UILabel new];
    _causeLable.hidden = YES;
    _causeLable.font = JHFont(12);
    _causeLable.textColor = kColor333;
    [_backView addSubview:_causeLable];
    
    _orderLable = [UILabel new];
    _orderLable.text = @"订单编号:3496003234596";
    _orderLable.font = JHFont(12);
    _orderLable.textColor = kColor999;
    [_backView addSubview:_orderLable];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:JHImageNamed(@"c2c_market_btbg") forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(checkReport) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"查看鉴定报告" forState:UIControlStateNormal];
    [_button setTitleColor:kColor333 forState:UIControlStateNormal];
    _button.titleLabel.font = JHFont(13);
    [_backView addSubview:_button];
    
    [self viewmakeConstraint];
}

- (void)checkReport{
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&orderCode=%@"),customerId, self.orderid];
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}

- (void)viewmakeConstraint{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(36);
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_right).offset(8);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLable.mas_left);
        make.top.mas_equalTo(_nameLable.mas_bottom).offset(2);
        make.height.mas_equalTo(16);
    }];
    
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(23);
        make.height.mas_equalTo(20);
    }];
    
    [_priceLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLable.mas_left);
        make.top.mas_equalTo(28);
        make.height.mas_equalTo(15);
    }];
    
    
    [_reportimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLable2.mas_left).offset(-6);
        make.top.mas_equalTo(4);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_headImgV.mas_bottom).offset(14);
    }];
    
    [_contentImgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV1.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV2.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV3.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-54);
        make.height.mas_equalTo(1);
    }];
    
    [_orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-18);
        make.height.mas_equalTo(17);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(30);
    }];
}

- (void)setCellModelData:(JHImageAppraisalRecordInfoModel *)model withType:(NSInteger)type{
    
    if (type == 3 || type == 2) {
        _button.hidden = YES;
        _reportimage.hidden = YES;
    }
    if(type == 2){
        _causeLable.hidden = NO;
        [_orderLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-8);
        }];
        [_lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-57);
        }];
        [_causeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(self.orderLable.mas_top).offset(-6);
            make.height.mas_equalTo(17);
        }];
        
        
    }
    self.orderid = [NSString stringWithFormat:@"%@",model.orderCode];
    [self.headImgV jh_setAvatorWithUrl:model.img];
    self.nameLable.text = model.name;
    self.timeLable.text = model.appraisalPayTime;
    self.priceLable.text = model.appraisalFeeYuan;
    self.contentLable.text = model.productDesc;
    //订单编号
    self.orderLable.text = [NSString stringWithFormat:@"订单编号：%@",model.orderCode];
    self.causeLable.text = [NSString stringWithFormat:@"原因：%@",model.doubtStatusName];
//    switch (model.doubtStatus) {////存疑原因 1 品类不符 2 图片不清晰 3 数量不符 4 其他
//        case 1:
//            self.causeLable.text = @"原因：品类不符";
//            break;
//        case 2:
//            self.causeLable.text = @"原因：图片不清晰";
//            break;
//        case 3:
//            self.causeLable.text = @"原因：数量不符";
//            break;
//        default:
//            self.causeLable.text = @"其他";
//            break;
//    }
    
    switch (model.appraisalResult) {//鉴定结果 0 真 1 仿品 2 存疑 3 现代工艺品
        case 0:
            _reportimage.image = [UIImage imageNamed:@"report_tureIcon"];
            break;
        case 1:
            _reportimage.image = [UIImage imageNamed:@"report_falseIcon"];
            break;
        case 3:
            _reportimage.image = [UIImage imageNamed:@"report_technologyIcon"];
            break;
        default:
            _reportimage.image = nil;
            break;
    }
//
    //图片组
    for (int index = 0; index < self.imgsArr.count; index++) {
        UIImageView *imgv = self.imgsArr[index];
        if (model.images.count > index) {
            imgv.hidden = NO;
            JHBaseImageModel *imgModel = model.images[index];
            [imgv jh_setImageWithUrl:imgModel.small];
        }else{
            imgv.hidden = YES;
        }
    }
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
