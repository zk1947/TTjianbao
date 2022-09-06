//
//  JHRoomUserCardView.m
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHRoomUserCardView.h"
#import "TTjianbaoHeader.h"
#import "NTESMessageModel.h"

#import "UIView+NTES.h"
#import "JHPickerView.h"
#import "JHSendOrderModel.h"
#import "JHForbidAccountViewController.h"
#import "ChannelMode.h"
#import "UserInfoRequestManager.h"
#import "JHAntiFraud.h"
#import "LEEAlert.h"
#import "JHVoucherSelectListView.h"


@interface JHRoomUserCardView () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, STPickerSingleDelegate>

@property (strong, nonatomic) UIImageView *avatarImage;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIButton *muteBtn;
@property (strong, nonatomic) UIButton *sendOrderBtn;
@property (strong, nonatomic) UIButton *sendWishBtn;
@property (strong, nonatomic) UIButton *blackBtn;
@property (strong, nonatomic) UIView *actionBackView;

@property (strong, nonatomic) UIView *orderBackView;
@property (strong, nonatomic) JHPickerView *picker;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSMutableArray *pickerSecondArray;

@property (assign, nonatomic) BOOL canSendCustomOrder;

@end

@implementation JHRoomUserCardView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isAssistant = NO;
        [self makeUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forbidSuccess:) name:ForbidSuccessNotifaction object:nil];

    }
    return self;
}
- (instancetype)initFromCustomize{
    self = [super init];
    if (self) {
        [self makeCustomizeUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forbidSuccess:) name:ForbidSuccessNotifaction object:nil];

    }
    return self;
}
- (void)makeBaseUI{
    [super awakeFromNib];
    [self.backView addSubview:self.avatarImage];
    [self.backView addSubview:self.nickLabel];
    
    self.actionBackView = [UIView new];
    [self.backView addSubview:self.actionBackView];
    
    [self.backView addSubview:self.orderBackView];

    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(@270);
    }];
    
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.width.height.equalTo(@50);
        make.centerX.equalTo(self.backView);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(5);
        make.centerX.equalTo(self.backView);
    }];
}
- (void)makeUI {
    
    [self makeBaseUI];
    
    [self.actionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.height.offset(44);
        make.top.equalTo(self.nickLabel.mas_bottom);
    }];
    [self.orderBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBackView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-10);
        make.height.equalTo(@0);
    }];
    
}
- (void)makeCustomizeUI{
    [self makeBaseUI];
    [self.actionBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.height.offset(44);
        make.top.equalTo(self.nickLabel.mas_bottom);
    }];
    [self.orderBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionBackView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-10);
        make.height.equalTo(@0);
    }];
}
- (void)makeActionBtnExt {
    NSArray *titles = @[@"禁言", @"心愿单"];
    NSArray *images = @[@"icon_card_mute",@"icon_card_wish"];
    //isAppraise 是what？？
    if (self.model.isAppraise || self.cardType == RoomUserCardViewTypeCustomize) {
        titles = @[@"  禁言"];
        images = @[@"icon_card_mute"];
    }
    if (self.model.isAppraise || self.cardType == RoomUserCardViewTypeRecycle) {
        titles = @[@"  禁言"];
        images = @[@"icon_card_mute"];
    }
    CGFloat ww = (270.)/titles.count;
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(cardAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        btn.tag = i;
    
        if (i == 0) {
            [btn setTitle:@"取消禁言" forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateSelected];

            self.muteBtn = btn;
        }else {
            self.sendWishBtn = btn;
        }
        [self.actionBackView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.actionBackView).offset(ww*i);
            make.width.equalTo(@(ww));
            make.height.top.equalTo(self.actionBackView);
        }];
        
        if (i == 1 || i == 2) {
            UIView *line = [UIView new];
            line.backgroundColor = HEXCOLOR(0xeeeeee);
            [btn addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.centerY.equalTo(btn);
                make.height.offset(20);
                make.width.offset(1);
            }];
        }
    }
}

- (void)makeActionBtn {
    NSArray *titles = @[@"禁言", @"冻结", @"心愿单"];
    NSArray *images = @[@"icon_card_mute",@"icon_card_black",@"icon_card_wish"];
    //isAppraise 是what？？
    if (self.model.isAppraise) {
        titles = @[@"禁言", @"冻结"];
        images = @[@"icon_card_mute",@"icon_card_black"];
    }
    CGFloat ww = (270.)/titles.count;
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(cardAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        btn.tag = i;
    
        if (i == 0) {
            [btn setTitle:@"取消禁言" forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateSelected];

            self.muteBtn = btn;
        }else if (i == 1) {
            self.blackBtn = btn;
        }else {
            self.sendWishBtn = btn;
        }
        [self.actionBackView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.actionBackView).offset(ww*i);
            make.width.equalTo(@(ww));
            make.height.top.equalTo(self.actionBackView);
        }];
        
        if (i == 1 || i == 2) {
            UIView *line = [UIView new];
            line.backgroundColor = HEXCOLOR(0xeeeeee);
            [btn addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.centerY.equalTo(btn);
                make.height.offset(20);
                make.width.offset(1);
            }];
        }
    }
}

- (UIView *)orderBackView {
    if (!_orderBackView) {
        _orderBackView = [UIView new];
    }
    return _orderBackView;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIImageView new];
        _avatarImage.layer.cornerRadius = 25;
        _avatarImage.layer.masksToBounds = YES;
    }
    
    return _avatarImage;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [UILabel new];
        _nickLabel.textColor = HEXCOLOR(0x333333);
        _nickLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _nickLabel;
}

- (void)cardAction:(UIButton *)btn {
    //去掉主播和助理的<冻结功能>
    if(1)
    {
        if (btn.tag == 0) {
            self.muteBtn = btn;
            [self muteAction:btn];
        }else {
            self.sendWishBtn = btn;
            if (self.sendWish) {
                self.sendWish(self.model.customerId);
            }
            [self hiddenAlert];
        }
    }
    else
    {
        if (btn.tag == 0) {
            self.muteBtn = btn;
            [self muteAction:btn];
        }else if (btn.tag == 1) {
            self.blackBtn = btn;
            [self blackAction:btn];
        }else {
            self.sendWishBtn = btn;
            if (self.sendWish) {
                self.sendWish(self.model.customerId);
            }
            [self hiddenAlert];
        }
    }
}


- (void)clickSendOrder:(UIButton *)btn {
    
    [self hiddenAlert];
    
    //if (btn.tag == self.tagArray.count -1) { //哄场单
    if ([btn.titleLabel.text isEqualToString:@"哄场单"]) {
        JHSendOrderModel *order = [[JHSendOrderModel alloc] init];
        order.anchorId = self.anchorId;
        order.orderType = @2;
        order.orderPrice = @"0";
        order.goodsImg = @"img";
        order.viewerId = self.model.customerId;
        [self requestDataWithModel:order];

    } else if ([btn.titleLabel.text isEqualToString:@"代金券"]) {
        [self showVoucherList];
        
    } else if (self.orderAction) {
        self.orderAction(self.model, self.tagArray[btn.tag]);
    }
}

- (void)setOrderButton {
    if (self.model.isAppraise) {
        return;
    }
    if (self.cardType == RoomUserCardViewTypeCustomize) {
        OrderTypeModel *coupon = [[OrderTypeModel alloc] init];
        coupon.name = @"代金券";
        coupon.Id = @"";
        [self.tagArray addObject:coupon];
    } else if (self.cardType == RoomUserCardViewTypeNormal) {
        OrderTypeModel *laugh = [[OrderTypeModel alloc] init];
        laugh.name = @"哄场单";
        laugh.Id = @"";
        
        OrderTypeModel *coupon = [[OrderTypeModel alloc] init];
        coupon.name = @"代金券";
        coupon.Id = @"";
        
        [self.tagArray addObject:laugh];
        [self.tagArray addObject:coupon];
    }

    [self.orderBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.tagArray.count*50));
    }];
    
    CGFloat oy = 0;

    for (int i = 0; i<self.tagArray.count; i++) {
        OrderTypeModel *model = self.tagArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(clickSendOrder:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];

        if (self.cardType == RoomUserCardViewTypeCustomize) {
            if (!self.isAssistant) {
                if (i == 0 || i == 1) {
                    btn.backgroundColor = kGlobalThemeColor;
                    if ([model.Id isEqualToString:@"connect"]) {
                        [btn setImage:[UIImage imageNamed:@"customizeConnectUser"] forState:UIControlStateNormal];
                        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
                    }
                }else{
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
                }
            } else {
                if (i == 0) {
                    btn.backgroundColor = kGlobalThemeColor;
                    if ([model.Id isEqualToString:@"connect"]) {
                        [btn setImage:[UIImage imageNamed:@"customizeConnectUser"] forState:UIControlStateNormal];
                        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
                    }
                } else {
                    btn.layer.borderWidth = 0.5;
                    btn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
                }
            }
        }else{
            if (i == 0) {
                btn.backgroundColor = kGlobalThemeColor;
            }else{
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
            }
        }
        
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [self.orderBackView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(oy);
            make.leading.offset(40);
            make.trailing.offset(-40);
            make.height.offset(40);
        }];
        
        oy += 50;
        
    }
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
        _picker.arrayData = self.pickerArray;
    }
    return _picker;
}

- (NSMutableArray *)pickerArray {
    if (!_pickerArray) {
        _pickerArray = [NSMutableArray array];
        for (NSDictionary *dic in [UserInfoRequestManager sharedInstance].temporaryMuteTimes) {
            [_pickerArray addObject:dic[@"label"]];
        }
    }
    return _pickerArray;
}
- (NSMutableArray *)pickerSecondArray {
    if (!_pickerSecondArray) {
        _pickerSecondArray = [NSMutableArray array];
        for (NSDictionary *dic in [UserInfoRequestManager sharedInstance].temporaryMuteTimes) {
            [_pickerSecondArray addObject:dic[@"seconds"]];
        }
    }
    return _pickerSecondArray;
}


- (void)setModel:(NTESMessageModel *)model {
    _model = model;
    [_avatarImage jhSetImageWithURL:[NSURL URLWithString:model.avatar] placeholder:kDefaultAvatarImage];
    _nickLabel.text = model.nick;
    self.muteBtn.selected = NO;
    self.blackBtn.selected = NO;

    [self setMuteWithAccid:model.message.from];
    if (model.isAppraise) {
        self.sendOrderBtn.hidden = YES;
    }
}
- (void)sendWishAction:(UIButton *)sender{
    //发送心愿单
    if (self.sendWish) {
        self.sendWish(self.model.customerId);

    }
}



//封号
- (void)blackAction:(UIButton *)sender {
    if (!sender.selected) {
        [self requestCloseAcount];

    }
    
}

- (void)muteAction:(UIButton *)sender {
    if (sender.selected) {
        [self requestSetMute:@0];
    }else {
        [self.picker show];
    }

}

- (void)setMuteWithAccid:(NSString *)accid {
    
    if (!accid){
        return;
    }
    
    NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
    requst.roomId = self.roomId;
    requst.userIds = @[accid];
    MJWeakSelf
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        
        if (members.count) {
        
            NIMChatroomMember *mem = members.firstObject;
            weakSelf.muteBtn.selected = mem.isTempMuted;
//            weakSelf.blackBtn.selected = mem.isInBlackList;
            NSLog(@"accid %@  === %@ %zd",accid, mem.userId, (NSInteger)mem.isTempMuted);


        }else {
            NSLog(@"accid %@  =========",accid);

            weakSelf.muteBtn.selected = NO;

//            weakSelf.muteBtn.hidden = YES;
//            weakSelf.blackBtn.hidden = YES;
        }
        
    }];
}

- (void)requestSetMute:(NSNumber *)sesond {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":self.model.message.from, @"muteDuration":sesond} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if ([sesond integerValue]>0) {
            [SVProgressHUD showSuccessWithStatus:@"禁言成功"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"解除禁言成功"];

        }
        self.muteBtn.selected = !self.muteBtn.selected;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (void)requestCloseAcount{
    
    if (self.blackBtn.selected) {
        NSInteger ban = !self.blackBtn.selected;
        NSString *string = ban?@"冻结":@"解冻";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否将该用户%@",string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/ban") Parameters:@{@"banCustomerId":self.model.customerId, @"banFlag":@(ban)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@成功",string]];
                self.blackBtn.selected = !self.blackBtn.selected;
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD showErrorWithStatus:respondObject.message];
            }];
            
        }]];
        
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }else {
        
        JHForbidAccountViewController *vc = [[JHForbidAccountViewController alloc] init];
        vc.customerId = self.model.customerId;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestSetBlack{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否将该用户拉黑" message:@"拉黑后将不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/blacklist") Parameters:@{@"viewerAccId":self.model.message.from} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showSuccessWithStatus:@"拉黑成功"];
            self.blackBtn.selected = !self.muteBtn.selected;
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];    }]];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)forbidSuccess:(NSNotification *)noti {
    self.blackBtn.selected = YES;
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    
    NSInteger index = pickerSingle.selectedIndex;
    [self requestSetMute:self.pickerSecondArray[index]];
}

- (void)setShowStyle {
    if (!self.model.customerId || [self.model.customerId isEqualToString:self.anchorId] || [self.model.customerId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        
        self.actionBackView.hidden = YES;
        self.orderBackView.hidden = YES;
        
        [self.orderBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];

        return;
    }
    
    if (self.model.isAppraise) {
        self.orderBackView.hidden = YES;
        self.actionBackView.hidden = NO;
        [self makeActionBtnExt]; //这里是怎么执行到的？

        [self.orderBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(0));
        }];
    } else { //助理&主播
        self.orderBackView.hidden = NO;
        self.actionBackView.hidden = NO;
        [self makeActionBtnExt]; //冻结功能去掉
        [self setOrderButton];
        [self.orderBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(50*self.tagArray.count));
        }];
    }
}

- (void)showAlert {
    [super showAlert];
    [self setShowStyle];
}

- (void)requestDataWithModel:(JHSendOrderModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
         [SVProgressHUD dismiss];
         [SVProgressHUD showSuccessWithStatus:@"发送成功"];
         [self hiddenAlert];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
    [SVProgressHUD show];
}

#pragma mark - 显示可发送代金券列表
- (void)showVoucherList {
    JHVoucherSelectListView *view = [JHVoucherSelectListView voucherWithSellerId:self.anchorId customerId:self.model.customerId];
    
    view.closeBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
    };
    
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeBackgroundStyleTranslucent(0)
    .LeeMaxWidth(kScreenWidth)
    .LeeShow();
}

//是否可以发定制单:意向单&服务单
- (void)canSendCustomizeOrder:(NTESMicConnector*)connector {
    self.canSendCustomOrder = NO;
}

@end
