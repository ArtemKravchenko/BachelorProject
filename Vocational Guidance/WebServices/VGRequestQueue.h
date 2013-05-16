//
//  VGRequestQueue.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 15.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGBaseRequest.h"

@interface VGRequestQueue : NSObject

@property (nonatomic, retain) NSOperationQueue *operationQueue;

+ (VGRequestQueue*)queue;

- (void)addRequest:(NSOperation*)request;
- (void)cancelRequst;


@end
