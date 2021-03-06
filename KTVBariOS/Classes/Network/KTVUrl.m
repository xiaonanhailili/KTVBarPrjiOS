//
//  KTVUrl.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/8/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVUrl.h"

// cer: com.weixinzhifu.jiuba
// cer: com.vhs.gongyuntong

@implementation KTVUrl

+ (NSString *)getDomainUrl {
    return @"http://119.23.148.104";
//    return @"http://humdeef.imwork.net";
}

#pragma mark - 用户

+ (NSString *)getUserInfoUrl {
    return @"/api/login/user/";
}

+ (NSString *)getSaveUserDetailUrl {
    return @"/api/login/saveUserDetail";
}

+ (NSString *)getUploadUserPictureUrl {
    return @"/api/login/uploadUserPicture";
}

/// 用户上传头像，背景图   0: 头像 1: 背景图
+ (NSString *)getUploadHeaderUrl {
    return @"/api/login/uploadPicture/0";
}

+ (NSString *)getUploadHeaderBgUrl {
    return @"/api/login/uploadPicture/1";
}

+ (NSString *)getEditNicknameUrl {
    return @"/api/login/user/editNickname";
}

/// 获取附近的普通用户
+ (NSString *)getCommonNearUserUrl {
    return @"/api/login/user/near";
}

/// 上传视频
+ (NSString *)getUploadVideoUrl {
    return @"/api/login/uploadVideo";
}

/// 删除用户图片
+ (NSString *)getDeletePictureUrl {
    return @"/api/login/picture/deletePicture";
}

/// 删除视频
+ (NSString *)getDeleteVideoUrl {
    return @"/api/login/video/deleteVideo";
}

/// 获取用户融云的token
+ (NSString *)getRongCloudTokenUrl {
    return @"/api/rongcloud/getToken";
}

/// 添加好友
+ (NSString *)getAddFriendUrl {
    return @"/api/friend/add";
}

/// 我的好友
+ (NSString *)getMyFriendUrl {
    return @"/api/friend/";
}

/// 及时更新用户的地址
+ (NSString *)getRecentUserAddressUrl {
    return @"/api/login/user/recentStatus";
}

/// 附近的人
+ (NSString *)getNearWarmerUserUrl {
    return @"/api/warmerUser/near";
}

/// 获取用户的余额
+ (NSString *)getUserBalanceUrl {
    return @"/api/login//user/getMoney/";
}

#pragma mark - 用户动态

+ (NSString *)getUserDynamicStatementUrl {
    return @"/api/dynamicStatement";
}

+ (NSString *)getUserDynamicStatementListUrl {
    return @"/api/dynamicStatement/18939865772?currentPage=0&size=2";
}

#pragma mark - 登陆

+ (NSString *)getIdentifyingCodeUrl {
    return @"/api/login/user/getIdentifyingCode";
}

+ (NSString *)getCheckIndentifyCodeUrl {
    return @"/api/login/user/checkIdentifyingCode";
}

+ (NSString *)getCommonLoginUrl {
    return @"/api/login/user/commonLogin";
}

+ (NSString *)getPhoneLoginUrl {
    return @"/api/login/user/phoneLogin";
}

+ (NSString *)getQQLoginUrl {
    return @"/api/login/user/qq/login";
}

+ (NSString *)getWeChatLoginUrl {
    return @"/api/login/user/wx/checkLogin";
}

+ (NSString *)getRegisterUrl {
    return @"/api/login/user/register";
}

+ (NSString *)getRegisterDetailUrl {
    return @"/api/login/user/registerDetail";
}

+ (NSString *)getChangePasswordUrl {
    return @"/api/password/user/changePassword";
}

+ (NSString *)getExitUrl {
    return @"/api/login/user/logout";
}

+ (NSString *)getUpdateThirdLoginUserUrl {
    return @"/api/login/user/updateThirdLoginUser";
}

#pragma mark -- 支付 订单

+ (NSString *)getPingPayUrl {
    return @"/api/pay";
}

+ (NSString *)getRefundUrl {
    return @"/api/refund";
}

+ (NSString *)getMainUrl {
    return @"/api/main/data";
}

+ (NSString *)getMainBannerUrl {
    return @"/api/store/banner";
}

+ (NSString *)getAtivitorsUrl {
    return @"/api/store/activitors/";
}

+ (NSString *)getAtivitorsByPageUrl {
    return @"/api/store/activitors";
}

+ (NSString *)getStoreGoodsUrl {
    return @"/api/store/goods/";
}

+ (NSString *)getStoreUrl {
    return @"/api/store/";
}

+ (NSString *)getStoreInvitatorsUrl {
    return @"/api/store/invitators/";
}

+ (NSString *)getStoreNearActivityUrl {
    return @"/api/nearActivity";
}

+ (NSString *)getStoreLikeUrl {
    return @"/api/store/like";
}

+ (NSString *)getGroupBuyUrl {
    return @"/api/groupBuy/";
}

+ (NSString *)getCreateOrderUrl {
    return @"/api/order/createOrder";
}

+ (NSString *)getOrderUrl {
    return @"/api/order/";
}

+ (NSString *)getOrderUpdateStatusUrl {
    return @"/api/store/updateStatus";
}

+ (NSString *)getSearchOrderUrl {
    return @"/api/order/searchOrder";
}

+ (NSString *)getLocalOrderUrl {
    return @"/api/userInvite/store";
}

+ (NSString *)getCreateWarmerOrderUrl {
    return @"/api/order/createWarmerOrder";
}

+ (NSString *)getStoreActivityUrl {
    return @"/api/store/storeActivity/";
}

+ (NSString *)getOrderCancelUrl {
    return @"/api/order/orderCancel";
}

#pragma mark - 评论

+ (NSString *)getRecentStatusUrl {
    return @"/api/user/recentStatus";
}

+ (NSString *)getCommentUrl {
    return @"/api/store/comment";
}

+ (NSString *)getActorUserCreatUrl {
    return @"/api/actoruser/create";
}

+ (NSString *)getActorUserQueryAllUrl {
    return @"/api/actoruser/queryAll";
}

#pragma mark - 拼桌

+ (NSString *)getCreatShareTableUrl {
    return @"/api/shareTable";
}

+ (NSString *)getShareTableAddressUrl {
    return @"/api/shareTable/address";
}

+ (NSString *)getShareTableDetailUrl {
    return @"/api/shareTable/";
}

+ (NSString *)getShareTableEnrollUrl {
    return @"/api/shareTable/enroll";
}

+ (NSString *)getStoreSearchUrl {
    return @"/api/store/search";
}

/// 创建邀约
+ (NSString *)getCreateInviteUrl {
    return @"/api/userInvite";
}

/// 获取单个邀约
+ (NSString *)getSingleInviteUrl {
    return @"/api/userInvite/";
}

/// 邀约大厅数据
+ (NSString *)getNearInviteUrl {
    return @"/api/userInvite/near";
}

#pragma mark - 用户入驻

/// 用户申请入驻
+ (NSString *)getUserEnterUrl {
    return @"/api/userEnter";
}

/// 同意用户入驻
+ (NSString *)getAgreeUserEnterUrl {
    return @"/api/agreeUserEnter";
}

#pragma mark - 收藏

/// 添加收藏
+ (NSString *)getUserCollectUrl {
    return @"/api/userCollect";
}

/// 获取收藏
+ (NSString *)getAlreadyCollectUrl {
    return @"/api/userCollect/";
}

/// 取消店铺收藏
+ (NSString *)getCancelCollectUrl {
    return @"/api/userCollect/cancel";
}

#pragma mark - 版本号管理

/// 获取最新的版本号
+ (NSString *)getAppVersionUrl {
    return @"/api/version";
}

#pragma mark - 暖场人

+ (NSString *)getApplyWarmerUrl {
    return @"/api/warmerUser";
}

+ (NSString *)getPayAfterWarmerUrl {
    return @"/api/warmerUser/orderAfter";
}

/// 修改暖场人兼职的时间
+ (NSString *)getUpdateWarmerTimeUrl {
    return @"/api/warmerUser/update";
}

/// 获取兼职暖场人的订单
+ (NSString *)getWarmerUserOrderUrl {
    return @"/api/warmerUser/warmerUserOrder";
}

/// 兼职暖场人接受和是拒绝
+ (NSString *)getUpdateRejectRecordOrderUrl {
    return @"/api/warmerUser/updateRejectRecordOrder";
}

/// 查询兼职暖场人的拒绝和接受订单
+ (NSString *)getQueryRejectRecordOrderUrl {
    return @"/api/warmerUser/queryRejectRecordOrder";
}

#pragma mark - 百度推送，上传channelid

+ (NSString *)getUpdateBPushChannelIdUrl {
    return @"/api/push/updateChannelId";
}

@end
