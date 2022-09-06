//
//  JHReplyMessageView.m
//  TTjianbao
//
//  Created by apple on 2020/2/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import <SVProgressHUD.h>
#import "JHReplyMessageView.h"
#import "JHReplyMessageCell.h"
#import "ChannelMode.h"
#import "JHGrowingIO.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionMsgConverter.h"
#import "UserInfoRequestManager.h"
#import "JHTrackingAudienceLiveRoomModel.h"

@interface JHReplyMessageView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, strong) UIView * footView;
@property (nonatomic, strong) UIImageView *bottomImage;
@end

@implementation JHReplyMessageView

-(void)dealloc
{
    NSLog(@"🔥");
}

-(instancetype)initWithChannelModel:(ChannelMode *)channel
{
    self = [super init];
    if(self){
        self.channel = channel;
        [self creatbgViwe];
        [self requestData];
    }
    return self;
}
-(void)moveArrowsLocation:(UIButton * )sender{
    
    [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(10, 5));
    }];
    
    CGRect rect=[sender convertRect: sender.bounds toView:self.superview];
    [self.bottomImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(rect.origin.x + 13 -60);
    }];
}
- (void)creatbgViwe{
    self.backgroundColor = [UIColor clearColor];
    
    [self creatBottomViwe];
    
    self.bottomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quickArrows"]];
    [self addSubview:self.bottomImage];
}
- (void)creatBottomViwe{
    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 38)];
    NSArray * btnTitleArray = [NSArray arrayWithObjects:@"1",@"6",@"8",@"9", nil];
    NSMutableArray * btnArray = [NSMutableArray arrayWithCapacity:4];
    for (NSString *title in btnTitleArray) {
        UIButton * btn = [UIButton jh_buttonWithTarget:self action:@selector(footBtnAction:) addToSuperView:self.footView];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(12);
        [btnArray addObject:btn];
        if (![btnTitleArray.lastObject isEqualToString:title]) {
            UIView * leftView = [[UIView alloc] init];
            leftView.backgroundColor = HEXCOLORA(0x6F6F6F, 1);
            [btn addSubview:leftView];
            [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(btn);
                make.centerY.equalTo(btn);
                make.size.mas_equalTo(CGSizeMake(0.5, 8));
            }];
        }
    }
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(38);
    }];
    [self addSubview:self.tableview];
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 3, 0));
    }];
    
}

-(UITableView *)tableview{
    if(_tableview == nil){
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.layer.cornerRadius = 8;
        _tableview.clipsToBounds = YES;
        _tableview.backgroundColor = HEXCOLORA(0x363838, .9);
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.tableHeaderView = self.footView;
    }
    return _tableview;
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHReplyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHReplyMessageCell"];
    if (cell == nil){
        cell = [[JHReplyMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JHReplyMessageCell"];
    }
    if (indexPath.item < self.dataArray.count) {
        NSString *words = self.dataArray[indexPath.row];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",words];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArray.count ) {
        NSString *words = self.dataArray[indexPath.row];
        [self checkMessage:words];
        [Growing track:JHtrackBusinessliveQuickSpeakItemClick withVariable:@{@"quick_speak_name":(words?words:@"")}];
    }
}
- (void)footBtnAction:(UIButton *)sender{
    [self checkMessage:sender.currentTitle];
}

-(void)checkMessage:(NSString *)message
{
    NIMLocalAntiSpamCheckOption *option = [[NIMLocalAntiSpamCheckOption alloc] init];
    option.content = message;
    option.replacement = @"***";
    
    NSError *errer;
    NIMLocalAntiSpamCheckResult *result = [[NIMSDK sharedSDK].antispamManager checkLocalAntispam:option error: &errer];
    if (result.type == NIMAntiSpamResultLocalForbidden) {
        [SVProgressHUD showInfoWithStatus:@"包含敏感词汇"];
        return;
    }
    if (result.type == NIMAntiSpamResultLocalReplace) {
        NSLog(@" ======== %@",result.content);
        message = result.content;
    }
    [self didSendText:message];
}

- (void)didSendText:(NSString *)text
{
    [self.viewController.view endEditing:YES];
    [JHGrowingIO trackEventId:JHTracklive_sendmsg_sendbtn variables:[[JHGrowingIO liveExtendModelChannel:self.channel] mj_keyValues]];
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    ext.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
    ext.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
    
    if ([JHRootController isLogin]){
    
        NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
        if(self.roomRole){
            dic[@"roomRole"] = self.roomRole;
        }
        ext.roomExt = [dic mj_JSONString];
    }
    
    message.messageExt = ext;
    
    NIMSession *session = [NIMSession session:self.channel.roomId type:NIMSessionTypeChatroom];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    self.hidden = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:self.channel.channelLocalId forKey:@"room_id"];
    if([self.channel.channelCategory isEqualToString:@"restoreStone"])
    {
        [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSpeak params:params];
    }
    else if ([self.channel.channelType isEqualToString:@"sell"])
    {
        [params setValue:self.groupId forKey:@"group1_id"];
        [JHUserStatistics noteEventType:kUPEventTypeShoppingLiveRoomSpeak params:params];
    }
    else if([self.channel.channelType isEqualToString:@"appraise"])
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomSpeak params:params];
    }
    
    ///369神策埋点:直播间互动_用户评论
    [self sa_tracking:@"zbjhdComment" content:text];
}

//神策埋点
- (void)sa_tracking:(NSString *)event content:(NSString *)content {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = event;
    model.comment_content = content;
    model.operation_type = @"快捷发言";
    [model transitionWithModel:self.channel needFollowStatus:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([model.event isEqualToString:@"zbjhdComment"]) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
        if([params valueForKey:@"is_follow_anchor"]) {
            [params removeObjectForKey:@"is_follow_anchor"];
        }
    }
    if (params.count <= 0) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdComment" params:params type:JHStatisticsTypeSensors];
}

+(CGFloat)viewHeight
{
    return 154;
}

/// type 0-源头直播     1-在线直播
-(void)requestData
{
    
    NSInteger type = [self.channel.channelType isEqualToString:@"appraise"] ? 1 : 0;
    NSString *urlStr = FILE_BASE_STRING(@"/anon/shortcut/page-shortcut");
    [HttpRequestTool postWithURL:urlStr Parameters:@{@"pageIndex" : @0 , @"type" : @(type)} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (IS_ARRAY(respondObject.data)) {
            self.dataArray = respondObject.data;
            self.isShow = (self.dataArray.count>0);
            [self.tableview reloadData];
            
        }
        else
        {
            self.isShow = NO;
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        self.isShow = NO;
        [self removeFromSuperview];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
