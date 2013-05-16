//
//  VGBaseRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VGBaseRequestDelegate <NSObject>

@optional

- (void) requestDidFinishSuccessful:(NSData*)data;
- (void) requestDidFinishFail:(NSError*)error;

@end

@interface VGBaseRequest : NSOperation

@property (nonatomic, retain) NSString* params;
@property (nonatomic, assign) id<VGBaseRequestDelegate> delegate;

@end
