//
//  KTVUrl.m
//  KTVBariOS
//
//  Created by pingjun lin on 2017/8/20.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "KTVUrl.h"

@implementation KTVUrl

+ (NSString *)getDomainUrl {
    return @"http://119.23.148.104";
}

+ (NSString *)getIdentifyingCodeUrl {
    return @"/api/login/user/getIdentifyingCode";
}

+ (NSString *)getCheckIndentifyCodeUrl {
    return @"/api/login/user/checkIdentifyingCode";
}

+ (NSString *)getCommonLoginUrl {
    return @"/api/login/user/commonLogin";
}

+ (NSString *)getQQLoginUrl {
    return @"/api/login/user/qq/login";
}

+ (NSString *)getWeChatLoginUrl {
    return @"/api/login/user/wx/login";
}

+ (NSString *)getRegisterUrl {
    return @"/api/login/user/register";
}

@end
