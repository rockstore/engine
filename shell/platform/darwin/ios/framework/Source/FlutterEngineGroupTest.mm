// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "flutter/shell/platform/darwin/ios/framework/Headers/FlutterEngineGroup.h"
#import "flutter/shell/platform/darwin/ios/framework/Source/FlutterEngine_Test.h"

FLUTTER_ASSERT_ARC

@interface FlutterEngineGroupTest : XCTestCase
@end

@implementation FlutterEngineGroupTest

- (void)testMake {
  FlutterEngineGroup* group = [[FlutterEngineGroup alloc] initWithName:@"foo" project:nil];
  FlutterEngine* engine = [group makeEngineWithEntrypoint:nil libraryURI:nil];
  XCTAssertNotNil(engine);
}

- (void)testSpawn {
  FlutterEngineGroup* group = [[FlutterEngineGroup alloc] initWithName:@"foo" project:nil];
  FlutterEngine* spawner = [group makeEngineWithEntrypoint:nil libraryURI:nil];
  spawner.isGpuDisabled = YES;
  FlutterEngine* spawnee = [group makeEngineWithEntrypoint:nil libraryURI:nil];
  XCTAssertNotNil(spawner);
  XCTAssertNotNil(spawnee);
  XCTAssertEqual(&spawner.threadHost, &spawnee.threadHost);
  XCTAssertEqual(spawner.isGpuDisabled, spawnee.isGpuDisabled);
}

- (void)testDeleteLastEngine {
  FlutterEngineGroup* group = [[FlutterEngineGroup alloc] initWithName:@"foo" project:nil];
  @autoreleasepool {
    FlutterEngine* spawner = [group makeEngineWithEntrypoint:nil libraryURI:nil];
    XCTAssertNotNil(spawner);
  }
  FlutterEngine* spawnee = [group makeEngineWithEntrypoint:nil libraryURI:nil];
  XCTAssertNotNil(spawnee);
}

- (void)testReleasesProjectOnDealloc {
  __weak FlutterDartProject* weakProject;
  @autoreleasepool {
    FlutterDartProject* mockProject = OCMClassMock([FlutterDartProject class]);
    FlutterEngineGroup* group = [[FlutterEngineGroup alloc] initWithName:@"foo"
                                                                 project:mockProject];
    weakProject = mockProject;
    XCTAssertNotNil(weakProject);
    group = nil;
    mockProject = nil;
  }
  XCTAssertNil(weakProject);
}

@end
