//
//  JHDataDebuger.m
//  TTjianbao
//
//  Created by jesee on 22/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDataDebuger.h"
#import "JHPurchaseStoneModel.h"
#import "JHConfirmBreakPaperView.h"
#import "JHMyPriceListModel.h"
#import "JHBuyerPriceListModel.h"
#import "JHBePushPriceView.h"
#import "JHBePushStoneSaledView.h"
#import "JHLastSaleGoodsModel.h"
#import "JHPublishTopicModel.h"

#import "JHDraftBoxModel.h"

//关闭调试时,需要注释掉
//#define DATA_DEBUG_OPEN

typedef NS_ENUM(NSUInteger, JHDebugDataType)
{
    JHDebugDataTypeDefault, //<0>
    JHDebugDataTypePublish, //发布话题相关数据<1>
    JHDebugDataTypePublishCatePlate, //发布版块相关数据<2>
    JHDebugDataTypeDraftBox, //草稿箱相关数据<3>
    /*新增,继续在此行以上添加*/
    JHDebugDataTypeEnd
};

@implementation JHDataDebuger

+ (instancetype)shareInstance
{
    static JHDataDebuger* debugExt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        debugExt = [JHDataDebuger new];
    });
    
#if defined(DEBUG) && defined(DATA_DEBUG_OPEN)
    return debugExt;
#else
    return nil;
#endif
}

#pragma mark - 通用数据填充接口,避免多次修改头文件
- (void)dataArrayOfCommon:(NSArray*_Nonnull*_Nonnull)dataArray dataType:(NSInteger)dataType
{
    switch (dataType)
    {
        case JHDebugDataTypePublish:
        {
            *dataArray = [self publishDataArray];
        }
            break;
            
        case JHDebugDataTypePublishCatePlate:
        {
            *dataArray = [self publishCatePlateDataArray];
        }
            break;
            
        case JHDebugDataTypeDraftBox:
        {
            *dataArray = [self draftDataArray];
        }
            break;
            
        default:
            break;
    }
}

- (NSArray*)draftDataArray
{
    NSTimeInterval dateTime = [[NSDate date] timeIntervalSince1970];
    JHDraftBoxModel* model11 = [JHDraftBoxModel new];
    //image
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"publish_create_topic_img"]);
    model11.editSelected = YES;
    model11.content = @"玉佛不能随便带，mage-test.oss-cn-beijing.aliyuncs.co要选择自己的本命佛。你知道吗?";
    model11.time = (dateTime - 322);
    model11.imageDataArray = @[data,data,data].mutableCopy;
    model11.imageCount = @"4";
    model11.style = JHDraftBoxStyleIcons;
    
    JHDraftBoxModel* model12 = [JHDraftBoxModel new];
    model12.time = (dateTime - 926);
    model12.imageData = data;
    model12.imageCount = @"6";
    model12.style = JHDraftBoxStyleIcons;
    model12.imageDataArray = @[data,data,data].mutableCopy;
    
    //video
    JHDraftBoxModel* model21 = [JHDraftBoxModel new];
    model21.content = @"玉佛不能道吗？";
    model21.time = (dateTime - 29);
    model21.imageData = data;
    model21.imageCount = @"5";
    model21.duration = @"5:10";
    model21.style = JHDraftBoxStyleVideo;
    
    JHDraftBoxModel* model22 = [JHDraftBoxModel new];
    model22.time = (dateTime - 29);
    model22.imageData = data;
    model22.imageCount = @"5";
    model22.duration = @"5:10";
    model22.style = JHDraftBoxStyleVideo;
    
    //image+text
    JHDraftBoxModel* model31 = [JHDraftBoxModel new];
    model31.title = @"111all玉佛。你知道吗？,2333232玉佛不能随便带，要选择自己的本命佛";
    model31.content = @"玉佛不能随便带，要选,2333232玉佛不能随便带，要选择自己的本命佛择自己的本命佛。你知道吗？";
    model31.time = dateTime;
    model31.imageData = data;
    model31.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model32 = [JHDraftBoxModel new];
    model32.title = @"222title+content的本命佛。你知道吗,2333232玉佛不能随便带，要选择自己的本命佛？";
    model32.content = @"玉佛不能随便带，mage-test.oss-cn-beiji,2333232玉佛不能随便带，要选择自己的本命佛ng.aliyuncs.co要选择自己的本命佛。你知道吗？";
    model32.time = (dateTime - 2030);
    model32.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model33 = [JHDraftBoxModel new];
    model33.title = @"333title+image玉佛。你知道吗？,2333232玉佛不能随便带，要选择自己的本命佛";
    model33.time = dateTime;
    model33.imageData = data;
    model33.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model34 = [JHDraftBoxModel new];
    model34.content = @"444content+image玉佛不能随便带，要选择自己的本命佛,2333232玉佛不能随便带，要选择自己的本命佛。你知道吗？";
    model34.time = dateTime;
    model34.imageData = data;
    model34.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model35 = [JHDraftBoxModel new];
    model35.title = @"555only title的本命佛。你知道吗？,2333232玉佛不能随便带，要选择自己的本命佛";
    model35.time = (dateTime - 2030);
    model35.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model36 = [JHDraftBoxModel new];
    model36.content = @"666 only content玉佛不能随便带，mage-test.oss-cn-beijing.aliyun,2333232玉佛不能随便带，要选择自己的本命佛cs.co要选择自己的本命佛。你知道吗？";
    model36.time = (dateTime - 2030);
    model36.style = JHDraftBoxStyleImageText;
    
    JHDraftBoxModel* model37 = [JHDraftBoxModel new];
    model37.imageData = data;
    model37.time = (dateTime - 2030);
    model37.style = JHDraftBoxStyleImageText;
    
    NSArray* dataArray = [NSArray arrayWithObjects:model11, model12, model21, model22, model31, model32, model33, model34, model35, model36, model37, nil];
    return dataArray;
}

- (NSArray*)publishCatePlateDataArray
{
    return @[];
}

- (NSArray*)publishDataArray
{
    JHPublishTopicModel* topic = [JHPublishTopicModel new];
    JHPublishTopicRecordModel* newTopic1 = [JHPublishTopicRecordModel new];
    newTopic1.isSelectedTopic = YES;
    newTopic1.itemId = @"11";
    newTopic1.title = @"您看新1";
    newTopic1.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicRecordModel* newTopic2 = [JHPublishTopicRecordModel new];
    newTopic2.isSelectedTopic = YES;
    newTopic2.itemId = @"22";
    newTopic2.title = @"您看新2";
    newTopic2.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicRecordModel* newTopic3 = [JHPublishTopicRecordModel new];
    newTopic3.isSelectedTopic = YES;
    newTopic3.itemId = @"33";
    newTopic3.title = @"您看新3";
    newTopic3.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicRecordModel* record = [JHPublishTopicRecordModel new];
    record.title = @"话题需要创";
    record.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicDetailModel* m =[JHPublishTopicDetailModel new];
    m.isNewTopic = YES;
    m.title = @"新话题需要创建";
    
    JHPublishTopicDetailModel* m1 =[JHPublishTopicDetailModel new];
    m1.isNewTopic = NO;
    m1.title = @"天天鉴宝邀您看新剧1";
    m1.subtitle = @"3938万阅读·8172评论·837篇内";
    m1.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicDetailModel* m2 =[JHPublishTopicDetailModel new];
    m2.isNewTopic = NO;
    m2.title = @"天天鉴宝邀您看新剧2";
    m2.subtitle = @"3938万阅读·8172评论·837篇内";
    m2.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    JHPublishTopicDetailModel* m3 =[JHPublishTopicDetailModel new];
    m3.isNewTopic = NO;
    m3.title = @"天天鉴宝邀您看新剧3";
    m3.subtitle = @"3938万阅读·8172评论·837篇内";
    m3.image = @"http://cdnnos.ttjianbao.com/res/default_icon.png";
    
    topic.selectedArray = [NSMutableArray arrayWithObjects:newTopic1, newTopic2, newTopic3,nil];
    topic.recordArray = [NSArray arrayWithObjects:record, record, record, record, record, nil];
    topic.detailArray = [NSArray arrayWithObjects:m, m2, m3, m1, nil];
    NSArray* dataArray = [NSArray arrayWithObject:topic];
    return dataArray;
}

#pragma mark - 买家出价/有人出价
- (void)dataArrayOfOfferPrice:(NSArray**)dataArray
{
    if(1)
    {//买家出价111
        JHBuyerPriceModel* price = [JHBuyerPriceModel new];
        price.goodsUrl  = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        
        JHBuyerPriceDetailModel* mDetail = [JHBuyerPriceDetailModel new];
        mDetail.offerCustomerStatus = @"3";
        price.customerOfferList = [NSArray arrayWithObjects:mDetail, nil];
        //222
        JHBuyerPriceModel* price2 =[JHBuyerPriceModel new];
        price2.seekCount = @"2";
        
        JHBuyerPriceDetailModel* mDetail2 = [JHBuyerPriceDetailModel new];
        mDetail2.offerCustomerStatus = @"2";
        price2.customerOfferList = [NSArray arrayWithObjects:mDetail2, nil];
        
        *dataArray = [NSMutableArray arrayWithObjects:price, price2, nil];
    }
    else
    {//我的/有人出价
        JHMyPriceListModel* m =[JHMyPriceListModel new];
        m.offerDetail = [JHMyPriceDetailModel new];
        m.offerDetail.offerState = 1;
        JHMyPriceListModel* m2 =[JHMyPriceListModel new];
        m2.offerDetail = [JHMyPriceDetailModel new];
        m2.offerDetail.offerState = 2;
        JHMyPriceListModel* m3 =[JHMyPriceListModel new];
        m3.offerDetail = [JHMyPriceDetailModel new];
        m3.offerDetail.offerState = 4;
        JHMyPriceListModel* m4 =[JHMyPriceListModel new];
        m4.offerDetail = [JHMyPriceDetailModel new];
        m4.offerDetail.offerState = 8;
        
        *dataArray = [NSMutableArray arrayWithObjects:m, m2, m3, m4, nil];
    }
}

#pragma mark - 买入原石数据源
- (void)dataArrayOfPurchaseStone:(NSArray**)dataArray
{
    JHSendOrderListModel* sendModel = [JHSendOrderListModel new];
    {//one
        sendModel.goodsUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        sendModel.transitionState = @"4";
        sendModel.resaleButtonText = @"转售";
        sendModel.resaleFlag = 1;
        sendModel.resaleStatus = 3;
        JHPurchaseStoneListAttachmentModel* sendModelChildAttach1 = [JHPurchaseStoneListAttachmentModel new];
        sendModelChildAttach1.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        JHPurchaseStoneListAttachmentModel* sendModelChildAttach2 = [JHPurchaseStoneListAttachmentModel new];
        sendModelChildAttach2.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        JHPurchaseStoneListModel* sendModelChild1 = [JHPurchaseStoneListModel new];
        sendModelChild1.attachmentList = [NSArray arrayWithObjects:sendModelChildAttach1,sendModelChildAttach2, nil];
        sendModelChild1.resaleButtonText = @"转售";
        sendModelChild1.resaleFlag = 1;
        sendModelChild1.resaleStatus = 3;
        JHPurchaseStoneListModel* sendModelChild2 = [JHPurchaseStoneListModel new];
        sendModelChild2.resaleButtonText = @"转售中";
        sendModelChild2.resaleFlag = 1;
        sendModelChild2.resaleStatus = 2;
        sendModelChild2.attachmentList = [NSArray arrayWithObjects:sendModelChildAttach1, sendModelChildAttach2, nil];
        sendModel.children = [NSArray arrayWithObjects:sendModelChild1, sendModelChild2, nil];
    }
    JHSendOrderListModel* sendModel2 = [JHSendOrderListModel new];
    {//two
        sendModel2.goodsUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        sendModel2.transitionState = @"2";
        sendModel2.resaleButtonText = @"转售中";
        sendModel2.resaleFlag = 0;
        sendModel2.resaleStatus = 2;
        JHPurchaseStoneListAttachmentModel* sendModel2ChildAttach = [JHPurchaseStoneListAttachmentModel new];
        sendModel2ChildAttach.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        
        JHSendOrderListModel* sendModel2Child = [JHSendOrderListModel new];
        sendModel2Child.attachmentList = [NSArray arrayWithObjects:sendModel2ChildAttach, nil];
        
        sendModel2.children = [NSArray arrayWithObjects:sendModel2Child, nil];
    }
    JHSendOrderListModel* sendModel3 = [JHSendOrderListModel new];
    {//three
        sendModel3.goodsUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        sendModel3.transitionState = @"3";
        sendModel3.resaleButtonText = @"转售";
        sendModel3.resaleFlag = 0;
        sendModel3.resaleStatus = 3;
    }
    JHSendOrderListModel* sendModel4 = [JHSendOrderListModel new];
    {//four
        sendModel4.goodsUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        sendModel4.transitionState = @"2";
        sendModel4.resaleButtonText = @"转售中";
        sendModel4.resaleFlag = 1;
        sendModel4.resaleStatus = 2;
        JHPurchaseStoneListAttachmentModel* sendModel4ChildAttach = [JHPurchaseStoneListAttachmentModel new];
        sendModel4ChildAttach.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        
        JHPurchaseStoneListModel* sendModel4Child = [JHPurchaseStoneListModel new];
        sendModel4Child.attachmentList = [NSArray arrayWithObjects:sendModel4ChildAttach, nil];
        sendModel4Child.resaleButtonText = @"转售中";
        sendModel4Child.resaleFlag = 0;
        sendModel4Child.resaleStatus = 2;
        sendModel4.children = [NSArray arrayWithObjects:sendModel4Child, nil];
    }
    *dataArray = [NSArray arrayWithObjects:sendModel4, sendModel3, sendModel2, sendModel, nil];
}
#pragma mark - 直播间弹框
- (void)liveRoomPopview
{
//    JHNimNotificationModel* model = [JHNimNotificationModel new];
//    [[NSNotificationCenter defaultCenter] postNotificationName:JHNIMNotifaction object:model];
    CGRect rect = [UIScreen mainScreen].bounds;
    if(0)
    {//买家/有人出价
        JHBePushPriceView *view = [[JHBePushPriceView alloc] initWithFrame:rect];
        view.isAgree = NO; //同意出价
        JHStoneMessageModel* m = [JHStoneMessageModel new];
        m.stoneRestoreOfferId = @"9838932";
//        m.goodsCode = @"32983484";
        m.msgType = @"stoneResale";
        m.goodsTitle = @"titleTaodangpuAuction[19607:273625] -";
        m.purchasePrice = @"2121.1";
        m.offerPrice = @"98.90";
        m.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        view.model = m;
        [view showAlert];
    }
    else if(1)
    {//出价被拒绝或者
        JHBePushStoneSaledView *view = [[JHBePushStoneSaledView alloc] initWithFrame:rect];
        [view showAlert];
        JHStoneMessageModel* m = [JHStoneMessageModel new];
        m.tips = @"3903209";
//        m.goodsCode = @"32983484";
        m.goodsTitle = @"titleTaodangpuAuction[19607:273625ticleBrowse]";
        m.purchasePrice = @"2121.1";
        m.offerPrice = @"98.90";
        m.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        
        static int i = 0;i++;
        if(i%2==0)
        {
            m.goodsCode = @"32983484";
            view.model = m;
            [view sellerRejectPrice];
        }
        //原石已售出
        else
        {
            m.msgType = @"stoneResale";
            view.model = m;
            [view sellerRecvSaled];
        }
    }
    else
    {//拆单
        JHConfirmBreakPaperView *view = [[JHConfirmBreakPaperView alloc] initWithFrame:rect];
        view.channelCategory = @"9";//self.channel.channelCategory;

        JHStoneMessageModel* m = [JHStoneMessageModel new];
        m.goodsCode = @"32983484";
        m.goodsTitle = @"titleTaodangpuAuction[19607:273625wingArticleBrowse]";
        m.purchasePrice = @"2121.1";
        m.offerPrice = @"98.90";
        m.coverUrl = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
        view.model = m;
        JHMainLiveSplitDetailModel* detail = [JHMainLiveSplitDetailModel new];
        detail.splitModeName = @"123";
        detail.purchasePrice = @"$80.99";
        ((JHStoneMessageModel*)(view.model)).splitStoneList = [NSArray arrayWithObjects:detail, nil];
        
        [view showAlert];
    }
}

@end
