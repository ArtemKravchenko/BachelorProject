//
//  VGReachability.h
//  Vitality Global
//
//  Created by Iurii Khvorost on 2012/12/29.
//  Copyright (c) 2012 Productive Edge. All rights reserved.
//

typedef enum {
	eReachableNo,
	eReachableViaWiFi,
	eReachableViaWWAN,
	eReachableNum
}
ReachableState;

@interface VGReachability: NSObject

+ (VGReachability*)reachability;

@property(nonatomic, assign) id target;
@property (assign, readonly) ReachableState state;

- (BOOL)isReachable;
- (BOOL)isReachable3G;

@end
