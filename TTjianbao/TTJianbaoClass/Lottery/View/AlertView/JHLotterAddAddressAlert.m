//
//  JHLotterAddAddressAlert.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotterAddAddressAlert.h"

@interface JHLotterAddAddressAlert ()

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *praiceLabel;

@property (nonatomic, weak) UIButton *addressBtn;

///中奖
@property (nonatomic, weak) UILabel *successLabel;

@property (nonatomic, copy) dispatch_block_t clickBlock;

@end

@implementation JHLotterAddAddressAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(320);
        }];

        UILabel *titleLabel = [UILabel jh_labelWithBoldFont:15 textColor:UIColor.blackColor addToSuperView:self.whiteView];
        titleLabel.text = @"恭喜您！中奖啦";
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteView).offset(57);
            make.centerX.equalTo(self.whiteView);
        }];
        _successLabel = titleLabel;
        
        _imageView = [UIImageView jh_imageViewAddToSuperview:self.whiteView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.whiteView);
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(82, 82));
        }];
        
        _titleLabel = [UILabel jh_labelWithFont:13 textColor:UIColor.blackColor textAlignment:1 addToSuperView:self.whiteView];
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.centerX.equalTo(self.whiteView);
            make.width.mas_equalTo(230);
        }];
        
        _praiceLabel = [UILabel jh_labelWithFont:13 textColor:RGB153153153 textAlignment:1 addToSuperView:self.whiteView];
        [_praiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
            make.centerX.width.equalTo(self.titleLabel);
        }];

        _addressBtn = [UIButton jh_buttonWithTitle:@"去填写收货地址" fontSize:13 textColor:UIColor.blackColor target:self action:@selector(addAddressMethod) addToSuperView:self.whiteView];
        _addressBtn.backgroundColor = RGB(255,194,66);
        [_addressBtn jh_cornerRadius:19];
        [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.whiteView).offset(-27);
            make.left.equalTo(self.whiteView).offset(27);
            make.height.mas_equalTo(38);
            make.bottom.equalTo(self.whiteView).offset(-35);
        }];
    }
    return self;
}

- (void)addAddressMethod
{
    if(_clickBlock)
    {
        _clickBlock();
    }
    [self removeFromSuperview];
}

+ (void)showLotterAddAddressAlertWithImageUrl:(NSString *)url
                                        title:(NSString *)title
                                     btnTitle:(NSString *)btnTitle
                                        price:(NSString *)price
                                    prizeName:(NSString *)prizeName
                              blockClickBlock:(dispatch_block_t)clickBlock;
{
    JHLotterAddAddressAlert *alert = [[JHLotterAddAddressAlert alloc] initWithFrame:JHKeyWindow.bounds];
    [JHKeyWindow addSubview:alert];
    
    alert.clickBlock = clickBlock;
    alert.titleLabel.text = prizeName;
    alert.successLabel.text = title;
    [alert.imageView jh_setImageWithUrl:url];
    alert.praiceLabel.text = [NSString stringWithFormat:@"%@", price];
    [alert.addressBtn setTitle:btnTitle forState:UIControlStateNormal];
}

@end
