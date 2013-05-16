//
//  VGRequestQueue.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 15.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGRequestQueue.h"
#import "VGReachability.h"
#import "VGAlertView.h"

static VGRequestQueue *requestsQueue = nil;

@interface VGRequestQueue ()

@property (nonatomic, retain) NSOperation *currentRequest;

@end


@implementation VGRequestQueue

+ (void)initialize
{
	if(self == [VGRequestQueue class])
		requestsQueue = [VGRequestQueue new];
}

+ (VGRequestQueue*)queue
{
    return requestsQueue;
}

- (id)init
{
    if(self = [super init])
    {
        self.operationQueue = [[NSOperationQueue new] autorelease];
    }
    return self;
}

- (void)addRequest:(NSOperation*)request
{
    if(![[VGReachability reachability] isReachable])
    {
        [VGAlertView showError:@"There is no Internet connection detected!"];
		return;
	}
    self.currentRequest = request;
	[self.operationQueue addOperation:self.currentRequest];
}

- (void)cancelRequst
{
    if(self.currentRequest)
    {
        [self.currentRequest cancel];
    }
}

-(void)dealloc
{
	[requestsQueue cancelRequst];
    self.currentRequest = nil;
    [super dealloc];
}


@end
