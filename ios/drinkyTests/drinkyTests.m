//
//  drinkyTests.m
//  drinkyTests
//
//  Created by kodam on 2014/02/22.
//  Copyright (c) 2014年 kodam. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DrunkDetector.h"

@interface drinkyTests : XCTestCase

@end

@implementation drinkyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
	DrunkDetector *detector = [[DrunkDetector alloc] init];
	XCTAssertNotNil(detector,"DrunkDetector allocate test");
}

@end
