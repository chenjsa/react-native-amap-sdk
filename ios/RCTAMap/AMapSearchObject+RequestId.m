//
// Created by yuanmarshal on 16/7/1.
// Copyright (c) 2016 starlight36. All rights reserved.
//

#import "AMapSearchObject+RequestId.h"
#import <objc/runtime.h>

@implementation AMapSearchObject(RequestId)
- (void)setRequestId:(NSString *)requestId
{
	objc_setAssociatedObject(self, @selector(requestId), requestId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)requestId
{
	return  objc_getAssociatedObject(self, @selector(requestId));
}

@end
