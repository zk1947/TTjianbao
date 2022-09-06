
. 
├─── 社区结构说明：
├   Community： 一些基类及通用工具、资源等
│   ├─ Macro
│   ├─ Base
│   ├─ manager
│   ├─ Utils
│   │   ├─ ApparallaxHeader     - 头视图拉伸效果
│   │   ├─ HUD                          - 系统消息弹窗
│   │   ├─ UMengShareView     - 自定义分享面板
│   │   ├─ YDActionSheet         - 自定义ActionSheet
│   │   ├─ YDPageController     - 分页切换组件，支持Header（优化卡顿、快速滑动时CPU占用过高等性能问题）
│   │   ├─ YDWaterFlowLayout - 瀑布流布局，支持header、footer
│   └
│   ├─ Resources
│   └
├   CommunityModule：社区所有模块
│   ├─ UserInfo       -   个人主页
│   ├─ UserFriend   -   关注/粉丝列表
│   ├─ Topic            -   话题模块
│   └
├   JHStore：商城
│   ├─ StorePage        -  商城首页
│   │   ├─ Controller
│   │   ├─ View
│   │   ├─ JXPageListView 【滑动标签组件】
│   │   ├─ Layout_xxx 【 布局：1 今日推荐样式，2 专题样式，3特卖商城店铺 】
│   ├─ ShopPage        -  店铺主页
│   ├─ ShopWindow   -  橱窗
│   ├─ GoodsList        -  商品列表（所有页面商品列表共用）
│   ├─ GoodsDetail     -  商品详情
│   ├─ CommentsList  -  商城全部评论列表
│   ├─ GoodsSearch   -  店铺内商品搜索
│   └
├
│── /* Readme end */


首次启动执行顺序：launch、intro、ad、cate

```

### 个人中心
```
JHUserInfoViewController
```

### 统计类 
```
JHBuryPointOperator
```

### 埋点统计参数说明
```
entery_type：
0.图文详情 1首页 2个人中心列表 3.搜索关键词

entry_id：
进入口，0.未定义（包括图文详情） 1个人中心晒宝 2个人中心喜欢 或者首页的channelID
```

### LayoutType 、ItemType
```
//社区帖：layout
typedef NS_ENUM(NSInteger, JHSQLayoutType) {
    JHSQLayoutTypeImageText = 1,//1社区内容天贴-图文详情
    JHSQLayoutTypeVideo = 2,//2社区视频
    JHSQLayoutTypeAppraisalVideo = 3,//3鉴定视频
    JHSQLayoutTypeAD = 4,//4运营广告
    JHSQLayoutTypeLiveStore = 5,//5直播卖场
    JHSQLayoutTypeTopic = 6 // ** 2.1.0新增 - 背景图 + 文字 + 描述 （话题）
};

//社区贴：item_type
typedef NS_ENUM(NSInteger, JHSQItemType) {
    JHSQItemTypeArticle = 1,//PGC、UGC发布的帖子文章
    JHSQItemTypeGoods = 2,//2商品
    JHSQItemTypeAD = 6, //倒流位，运营和产品的广告，eg广告位和卖场直播
    JHSQItemTypeTopic = 7, //话题 ** 2.1.0新增
    JHSQItemTypeVote = 8, //投票帖子 3.0.0
    JHSQItemTypeGuess = 10 //猜价贴 3.1.8
};
```

### 其他
```
//url中文转码
NSString *imgUrl = [thumbURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
```

```
round  如果参数是小数  则求本身的四舍五入.
ceil   如果参数是小数  则求最小的整数但不小于本身.
ceil() / ceilf() / ceill() 向上取整 iOS保留两位小数并且向上取整
floor  如果参数是小数  则求最大的整数但不大于本身.
```

```
评论相关类：

//1. 帖子详情
JHDiscoverDetaileSectionHeaderNomal

1.
JHDiscoverVideoDetailViewController  已删除
JHDiscoverVideoCommentView
JHDiscoverVideoMainCommentSectionHeader
JHDiscoverVideoSubCommentCell

2.
JHAppraiseVideoViewController
JHGoodAppraisalCommentView

```


## v2.2.9 - 社区商户电子签约功能，个人中心待修改文件
```
JHPersonCenterViewController
JHPersonHeaderView
JHUserLevelInfoMode
```

