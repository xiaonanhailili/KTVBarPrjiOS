//
//  KTVBariOSTests.m
//  KTVBariOSTests
//
//  Created by pingjun lin on 2017/6/28.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KTVMainService.h"
#import "KTVUtil.h"

@interface KTVBariOSTests : XCTestCase

@end

@implementation KTVBariOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    [self getStoreActivitors];
    [self getOneWeekFilter];
    [self getCalculateWeek];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

// 获取门店的暖场人
- (void)getStoreActivitors {
    [KTVMainService getStoreActivitors:@"4" result:^(NSDictionary *result) {
        NSLog(@"-->> %@", result);
    }];
}

- (void)getOneWeekFilter {
    [KTVUtil getFiltertimeByDay:7];
}

- (void)getCalculateWeek {
    [KTVUtil calculateWeek:[NSDate date]];
}

@end
