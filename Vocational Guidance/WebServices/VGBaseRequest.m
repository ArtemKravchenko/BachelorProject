//
//  VGBaseRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGRequestQueue.h"

@implementation VGBaseRequest

- (id)initWithDelegate:(id<VGBaseRequestDelegate>)target
{
    self = [super init];
    if (self) {
        self.delegate = target;
    }
    return self;
}

-(void)main
{
    NSString *tmpRequestURL = VG_BASE_URL;
    tmpRequestURL = [[NSString stringWithFormat:@"%@/%@", tmpRequestURL, self.params] stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    DLog(@"%@", tmpRequestURL);
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tmpRequestURL]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[VGRequestQueue queue].operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
         if (self.delegate != nil)
         {
             if (error != nil)
             {
                 [self.delegate requestDidFinishFail:error];
             }
             else
             {
                 [self.delegate requestDidFinishSuccessful:data];
             }
         }
    }];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end