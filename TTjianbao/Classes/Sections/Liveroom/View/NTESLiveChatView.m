//
//  NTESLiveChatView.m
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveChatView.h"
#import "UIView+NTES.h"
#import "NTESMessageModel.h"
#import "NTESLiveChatTextCell.h"
#import "NTESLiveManager.h"
#import "JHSystemMsgAttachment.h"
#import "TTjianbaoHeader.h"
#import "NSString+Common.h"

@interface NTESLiveChatView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray<NTESMessageModel *> *messages;

@property (nonatomic,strong) NSMutableArray *pendingMessages;   //缓存的插入消息,聊天室需要在另外个线程计算高度,减少UI刷新

@property (nonatomic, strong)UIButton *showNewMsgBtn;
@property (nonatomic, assign)NSInteger noreadCount;
@property (nonatomic, assign)BOOL currentIsInBottom;

@property (nonatomic, strong) NTESLiveChatTextCellView *commonComeinView;

@property (nonatomic, assign) float commonHeight;
@end

@implementation NTESLiveChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _messages = [[NSMutableArray alloc] init];
        _pendingMessages = [[NSMutableArray alloc] init];
        [self addSubview:self.tableView];
        [self addSubview:self.commonComeinView];
        [self.commonComeinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(35.f);
        }];
        self.commonHeight = 35;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        [self addSubview:self.showNewMsgBtn];
        self.currentIsInBottom = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = frame;
        gradient.colors = [NSArray arrayWithObjects:
                (__bridge id)UIColor.clearColor.CGColor,
                UIColor.whiteColor.CGColor,
                nil];
        gradient.locations = [NSArray arrayWithObjects:
                [NSNumber numberWithFloat:0],
                [NSNumber numberWithFloat:10.0/50],
                nil];
        self.layer.mask = gradient;

    }
    return self;
}
-(void)cleanMessage{
    
    self.messages = [[NSMutableArray alloc] init];
    self.pendingMessages = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
}
-(void)doTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSString *str = NSStringFromClass([touch.view class]);
    if ([str isEqualToString:@"NTESLiveChatTextCellView"]) {
        return NO;//关闭手势
    }
    return YES;
}

- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    if (messages.count) {
        [self caculateHeight:messages];
    }
}

-(void)addCommonComeInMessages:(NIMMessage *)message{
    
    if(message){
        NTESMessageModel *model = [[NTESMessageModel alloc] init];
        model.isAnchorRecv = self.isAnchor;
        model.message = message;
        CGFloat avatarW = 30;
        if (model.message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
            JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
    
            if (attachment.type == JHSystemMsgTypeNotification) {
                avatarW = 0;
            }
        }

        [model caculate:self.width-(avatarWidth+oXspaceWidth+2*spaceWidth+(avatarW>0.0?spaceWidth:0))];
        if (model.height>35) {
            [self.commonComeinView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(48.f);
            }];
            self.commonHeight = 48;
        }else{
            [self.commonComeinView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(35.f);
            }];
            self.commonHeight = 35;
        }
        [self changeInsets:nil];
        [self.commonComeinView refresh:model];
        
    }
    
        
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTESMessageModel *model = self.messages[indexPath.row];
    CGFloat height = model.height+spaceWidth+spaceHeight*2;
    return height<35?35:height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTESLiveChatTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat"];
    NTESMessageModel *model = self.messages[indexPath.row];
    [cell refresh:model];
    JH_WEAK(self)
    cell.refreshCell = ^(id sender) {
        JH_STRONG(self)
        [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//发送订单
    NTESMessageModel *model = self.messages[indexPath.row];
    [self delegateMethodWithModel:model];
}

-(void)clickCominView{
    NTESMessageModel *model = self.commonComeinView.model;
    if (model.customerId && model.customerId.length > 0){
        [self delegateMethodWithModel:model];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(onClickeAnonymityUser)]) {
            [_delegate onClickeAnonymityUser];
        }
    }
}

-(void)delegateMethodWithModel:(NTESMessageModel *)model{
    if ([model.nick isEqualToString:@""]&&[model.avatar isEqualToString:@""] && model.customerId == nil) {
        return;
    }

        if (_delegate && [_delegate respondsToSelector:@selector(onClickeCellWithModel:)]) {
            [_delegate onClickeCellWithModel:model];
        }
}

#pragma mark - Get

- (UIButton *)showNewMsgBtn {
    if (!_showNewMsgBtn) {
        
        _showNewMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showNewMsgBtn setBackgroundImage:[UIImage imageNamed:@"bg_new_msg_orange"] forState:UIControlStateNormal];
        [_showNewMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showNewMsgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showNewMsgBtn setTitle:@"新消息" forState:UIControlStateNormal];
        _showNewMsgBtn.hidden = YES;
        _showNewMsgBtn.frame = CGRectMake(self.width-75, self.height-25, 75, 25);
        [_showNewMsgBtn addTarget:self action:@selector(clickNewMsg) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showNewMsgBtn;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = self.bounds;
//        frame.size.height = frame.size.height - 35;
//        frame.origin.y = frame.origin.y - 35;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [_tableView registerClass:[NTESLiveChatTextCell class] forCellReuseIdentifier:@"chat"];
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

-(NTESLiveChatTextCellView *)commonComeinView{
    if(!_commonComeinView){
        _commonComeinView = [NTESLiveChatTextCellView new];
        [_commonComeinView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCominView)]];
    }
    return _commonComeinView;
}

#pragma mark - Private

- (void)clickNewMsg {
    [self scrollToBottom];
    self.showNewMsgBtn.hidden = YES;
    self.noreadCount = 0;
    self.currentIsInBottom = YES;

}

- (void)caculateHeight:(NSArray<NIMMessage *> *)messages
{
    
//    dispatch_async(NTESMessageDataPrepareQueue(), ^{
        //后台线程处理宽度计算，处理完之后同步抛到主线程插入
        BOOL noPendingMessage = self.pendingMessages.count == 0;
        [self.pendingMessages addObjectsFromArray:messages];
        if (noPendingMessage)
        {
            [self processPendingMessages];
        }
//    });
}

- (void)processPendingMessages
{
    __weak typeof(self) weakSelf = self;
    NSUInteger pendingMessageCount = self.pendingMessages.count;
    if (!weakSelf || pendingMessageCount== 0) {
        return;
    }
    
    if (weakSelf.tableView.isDecelerating || weakSelf.tableView.isDragging)
    {
        //滑动的时候为保证流畅，暂停插入
        NSTimeInterval delay = 1;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), NTESMessageDataPrepareQueue(), ^{
//            [weakSelf processPendingMessages];
//        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf processPendingMessages];

        });
        return;
    }

    //获取一定量的消息计算高度，并扔回到主线程
    static NSInteger NTESMaxInsert = 2;
    NSArray *insert = nil;
    NSRange range;
    if (pendingMessageCount > NTESMaxInsert)
    {
        range = NSMakeRange(0, NTESMaxInsert);
    }
    else
    {
        range = NSMakeRange(0, pendingMessageCount);
    }
    insert = [self.pendingMessages subarrayWithRange:range];
    [self.pendingMessages removeObjectsInRange:range];
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NIMMessage *message in insert)
    {
        NTESMessageModel *model = [[NTESMessageModel alloc] init];
        model.isAnchorRecv = self.isAnchor;
        model.message = message;
        if (model.message.messageType == NIMMessageTypeText && [NSString isEmpty:model.nick]&&([NSString isEmpty:model.customerId]||[model.customerId isEqualToString:@"0"])) {
            continue;
        }
        CGFloat avatarW = 30;
            if (model.message.messageType == NIMMessageTypeCustom) {
                NIMCustomObject *object = (NIMCustomObject *)model.message.messageObject;
                JHSystemMsgAttachment<NIMCustomAttachment> *attachment = (JHSystemMsgAttachment<NIMCustomAttachment> *)object.attachment;
        
                if (attachment.type == JHSystemMsgTypeNotification) {
                    avatarW = 0;
                }
        
            }

        [model caculate:self.width-(avatarWidth+oXspaceWidth+2*spaceWidth+(avatarW>0.0?spaceWidth:0))];
        [models addObject:model];
        NSLog(@"收到消息：%@, %@ ,%@",model.nick, model.avatar,model.message.text);
     //   NSLog(@"===model===%@", model.message);

    }
    
    NSUInteger leftPendingMessageCount = self.pendingMessages.count;
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [weakSelf addModels:models];
//    });
    [weakSelf addModels:models];

    if (leftPendingMessageCount)
    {
        NSTimeInterval delay = 0.1;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), NTESMessageDataPrepareQueue(), ^{
//            [weakSelf processPendingMessages];
//        });
//
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf processPendingMessages];

        });
    }
}

- (void)addModels:(NSArray<NTESMessageModel *> *)models
{
    NSInteger count = self.messages.count;
    BOOL currentIsInBottom = self.currentIsInBottom;
    if ((!currentIsInBottom) && [JHRootController isLogin]) { //如果是自己发送消息 不在最后 也都往上滚
        if ([models.firstObject.message.from isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
            currentIsInBottom = YES;
        }
    }
    
    
    if (!currentIsInBottom) {
        self.noreadCount = self.noreadCount + models.count;
        self.showNewMsgBtn.hidden = NO;
        [self.showNewMsgBtn setTitle:[NSString stringWithFormat:@"%ld条新消息",(long)self.noreadCount] forState:UIControlStateNormal];
    }
    [self.messages addObjectsFromArray:models];
    
    NSMutableArray *insert = [[NSMutableArray alloc] init];
    for (NSInteger index = count; index < count+models.count; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insert addObject:indexPath];
    }
    NSLog(@"contentsize1====%@",NSStringFromCGSize(self.tableView.contentSize));
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

    [self.tableView reloadRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationFade];
    
    NSLog(@"contentsize2====%@",NSStringFromCGSize(self.tableView.contentSize));

    [self.tableView layoutIfNeeded];
    NSLog(@"contentsize3====%@",NSStringFromCGSize(self.tableView.contentSize));

    if (currentIsInBottom) {
        [self scrollToBottom];
    }

    [self changeInsets:models];
}

- (void)changeInsets:(NSArray<NTESMessageModel *> *)newModels
{
    CGFloat height = self.mj_h - self.commonHeight;
    CGFloat contentH = self.tableView.contentSize.height;
    if (self.messages.count) {
        NTESMessageModel *model = self.messages.lastObject;
        contentH += model.height+3*spaceWidth;
    }
    if (contentH<height) {
        self.tableView.frame = CGRectMake(0, height-contentH, self.mj_w, contentH);
    }else {
        CGRect frame = self.bounds;
        frame.size.height = frame.size.height - self.commonHeight;
        self.tableView.frame = frame;
    }
    
    /*
    CGFloat height = 0;
    for (NTESMessageModel *model in newModels) {
        height += model.height;
    }
    UIEdgeInsets insets = self.tableView.contentInset;
    CGFloat contentHeight = self.tableView.contentSize.height - insets.top;
    contentHeight += height;
    CGFloat top = contentHeight > self.tableView.height? 0 : self.tableView.height - contentHeight;
    insets.top = top;
    self.tableView.contentInset = insets;*/
}

- (void)scrollToBottom
{
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.messages.count!=0) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
                [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            self.showNewMsgBtn.hidden = YES;
            self.noreadCount = 0;
                  }
            
        });

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self isBottom]) {
        self.showNewMsgBtn.hidden = YES;
        self.noreadCount = 0;
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self isBottom]) {
        self.showNewMsgBtn.hidden = YES;
        self.noreadCount = 0;
    }

}
- (BOOL)isBottom {
    
    NSInteger count = self.messages.count;
    if (count == 0) {
        self.currentIsInBottom = YES;
        return YES;
    }
    
    if (self.tableView.visibleCells) {
        UITableViewCell *showcell = self.tableView.visibleCells.lastObject;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0]];
        if (showcell == cell) {
            self.currentIsInBottom = YES;
            return YES;
        }
        
    }
    self.currentIsInBottom = NO;
    return NO;
}

static const void * const NTESDispatchMessageDataPrepareSpecificKey = &NTESDispatchMessageDataPrepareSpecificKey;
dispatch_queue_t NTESMessageDataPrepareQueue()
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("nim.live.demo.message.queue", 0);
        dispatch_queue_set_specific(queue, NTESDispatchMessageDataPrepareSpecificKey, (void *)NTESDispatchMessageDataPrepareSpecificKey, NULL);
    });
    return queue;
}
- (void)dealloc
{
    NSLog(@"chat dealloc");
}

@end



