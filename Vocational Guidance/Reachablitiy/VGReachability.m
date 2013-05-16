//
//  VGReachability.m
//  Vitality Global
//
//  Created by Iurii Khvorost on 2012/12/29.
//  Copyright (c) 2012 Productive Edge. All rights reserved.
//

#import "VGReachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>

static VGReachability* instance = nil;

@interface VGReachability () {
	SCNetworkReachabilityRef reachabilityRef;
}

@property (assign, readwrite) ReachableState state;

@end

@implementation VGReachability

- (void)dealloc {
	SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	CFRelease(reachabilityRef);
	[super dealloc];
}

+ (void)initialize {
	if(self == [VGReachability class])
		instance = [VGReachability new];
}

+ (VGReachability*)reachability {
	return instance;
}

static ReachableState reachableState(SCNetworkReachabilityFlags flags) {
	if(!(flags & kSCNetworkReachabilityFlagsReachable))
		return eReachableNo;
	
	if(!(flags & kSCNetworkReachabilityFlagsConnectionRequired))
		return eReachableViaWiFi;

	if((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)){
		if(!(flags & kSCNetworkReachabilityFlagsInterventionRequired))
			return eReachableViaWiFi;
	}

	if(flags & kSCNetworkReachabilityFlagsIsWWAN)
		return eReachableViaWWAN;
	
	return eReachableNo;
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info){
	
	AssertC(info && [(NSObject*)info isKindOfClass:[VGReachability class]]);
	VGReachability* reachability = (VGReachability*)info;
	reachability.state = reachableState(flags);
	
	static NSString* states[eReachableNum] = {@"NO", @"WiFi", @"3G"}; 
	DLog(@"Reachability: %@", states[reachability.state]);
	
	AssertC([reachability.target respondsToSelector:@selector(reachabilityDidChange:)]);
	[reachability.target performSelector:@selector(reachabilityDidChange:) withObject:@([reachability isReachable])];
}

- (id)init {
	if(self = [super init]){
		struct sockaddr_in zeroAddress;
		bzero(&zeroAddress, sizeof(zeroAddress));
		zeroAddress.sin_len = sizeof(zeroAddress);
		zeroAddress.sin_family = AF_INET;
		//zeroAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
		reachabilityRef = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
		Assert(reachabilityRef);
		
		SCNetworkReachabilityFlags flags = 0;
		Verify(SCNetworkReachabilityGetFlags(reachabilityRef, &flags));
		self.state = reachableState(flags);
	
		SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
		Verify(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context));
		Verify(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode));
	}
	return self;
}

- (BOOL)isReachable {
	return self.state != eReachableNo;
}

- (BOOL)isReachable3G {
	return self.state == eReachableViaWWAN;
}

@end