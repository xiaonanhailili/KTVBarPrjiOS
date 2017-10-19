//
//  KTVFriendCell.h
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/7.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KTVUser.h"

typedef NS_ENUM(NSUInteger, FriendType) {
    FriendChatType,
    FriendAddType
};

@interface KTVFriendCell : UITableViewCell

@property (nonatomic, assign) FriendType friendType;
@property (nonatomic, strong) KTVUser *user;

@property (nonatomic, copy) void (^pinzuoCallback)(KTVUser *user);

@end
