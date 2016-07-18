//
// Created by chenjunsheng on 16/7/1.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import <RCTBridgeModule.h>
#import "RCTEventEmitter.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface RCTAMapSearchManager : RCTEventEmitter <RCTBridgeModule, AMapSearchDelegate>

@end
