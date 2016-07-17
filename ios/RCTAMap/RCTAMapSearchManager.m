//
// Created by chenjunsheng on 16/7/1.
// Copyright (c) 2016 starlight36. All rights reserved.
//


#import "RCTEventDispatcher.h"
#import "RCTAMapSearchManager.h"
#import <AMapFoundationKit/AMapURLSearchType.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AMapSearchObject+RequestId.h"

@implementation RCTAMapSearchManager
{
	AMapSearchAPI *_search;
}

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (instancetype)init
{
	self = [super init];
	if (self) {
		_search = [[AMapSearchAPI alloc] init];
		_search.delegate = self;
	}
	
	return self;
}

RCT_EXPORT_METHOD(inputTipsSearch:(NSString *)requestId keys:(NSString *) keys city:(NSString *)city)
{
    AMapInputTipsSearchRequest *_tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    _tipsRequest.keywords = keys;
    _tipsRequest.city = city;
    _tipsRequest.requestId = requestId;
    [_search AMapInputTipsSearch:_tipsRequest];
}

RCT_EXPORT_METHOD(geocodeSearch:(NSString *)requestId address:(NSString *)address city:(NSString *)city)
{
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
    request.address = address;
    request.city = city;
    request.requestId = requestId;
    [_search AMapGeocodeSearch:request];
}

RCT_EXPORT_METHOD(regeocodeSearch:(NSString *)requestId location:(AMapGeoPoint *)location radius:(NSInteger)radius)
{
	AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
	request.location = location;
	request.radius = radius ? radius: 1000;
	request.requireExtension = NO;
	request.requestId = requestId;
	[_search AMapReGoecodeSearch:request];
}

#pragma mark - AMapSearchDelegate

-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
	AMapSearchObject *search = (AMapSearchObject *)request;
	[self.bridge.eventDispatcher sendAppEventWithName:@"ReceiveAMapSearchResult"
		body:@{ @"requestId":search.requestId,
				@"error":@{ @"domain": error.domain,
							@"userInfo": error.userInfo
							}
				}
	 ];
}

-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if (response.tips.count != 0) {
        for (AMapTip *p in response.tips)
        {
            NSDictionary *n = [self amapTipToJson: p];
            [arr addObject:n];
        }
    }

    [self.bridge.eventDispatcher sendAppEventWithName:@"ReceiveAMapSearchResult" body:@{
                                                                                     @"requestId":request.requestId, @"data":arr}];
}

-(NSDictionary *)amapTipToJson:(AMapTip *)tip
{
    return @{@"name":tip.name,
             @"location":@{@"latitude":@(tip.location.latitude), @"longitude":@(tip.location.longitude)},
             @"district":tip.district
             };
}

-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if(response.geocodes.count != 0)
    {
        for (AMapGeocode *gc in response.geocodes)
        {
            NSDictionary *n = @{@"formattedAddress": gc.formattedAddress,
                                @"province": gc.province,
                                @"city": gc.city,
                                @"cityCode": gc.citycode,
                                @"district": gc.district,
                                @"township": gc.township,
                                @"neighborhood": gc.neighborhood,
                                @"building": gc.building,
                                @"adcode": gc.adcode,
                                @"location": @{@"latitude": @(gc.location.latitude), @"longitude": @(gc.location.longitude)},
                                @"level": gc.level
                                };
            [arr addObject:n];
        }
    }

    [self.bridge.eventDispatcher sendAppEventWithName:@"ReceiveAMapSearchResult" body:@{
                                                                                        @"requestId":request.requestId, @"data":arr}];
}

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	if(response.regeocode != nil)
	{
		//通过AMapReGeocodeSearchResponse对象处理搜索结果
		NSDictionary *n = @{
							@"formattedAddress":response.regeocode.formattedAddress,
							@"province": response.regeocode.addressComponent.province,
							@"city": response.regeocode.addressComponent.city,
							@"cityCode": response.regeocode.addressComponent.citycode,
							@"township": response.regeocode.addressComponent.township,
							@"neighborhood": response.regeocode.addressComponent.neighborhood,
							@"building": response.regeocode.addressComponent.building,
							@"district": response.regeocode.addressComponent.district
							};
		[arr addObject:n];
	}
	
	[self.bridge.eventDispatcher
		sendAppEventWithName:@"ReceiveAMapSearchResult"
		body:@{ @"requestId":request.requestId, @"data":arr}];
}

@end
