//
//  KTVCommon.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/9/5.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVCommon.h"


@implementation KTVCommon

+ (KTVUser *)userInfo {
    NSDictionary *userInfo = [KTVUtil objectForKey:@"ktvUserInfo"];
    KTVUser *user = [KTVUser yy_modelWithDictionary:userInfo];
    return user;
}

+ (void)setUserInfoKey:(NSString *)infoKey infoValue:(NSString *)infoValue {
    NSDictionary *info = [KTVUtil objectForKey:@"ktvUserInfo"];
    if (!info) {
        info = [NSDictionary dictionary];
    }
    NSMutableDictionary *muUserInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    if (!infoKey) {
        [muUserInfo removeObjectForKey:infoKey];
    }
    if (infoValue) {
        [muUserInfo setObject:infoValue forKey:infoKey];
    }
    if ([info[infoKey] isEqualToString:infoValue]) {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:muUserInfo];
    [KTVUtil setObject:userInfo forKey:@"ktvUserInfo"];
}

@end