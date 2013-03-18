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

-(void)main
{
    
    NSString *tmpRequestURL = VG_BASE_URL;
    tmpRequestURL = [NSString stringWithFormat:@"%@/%@", tmpRequestURL, self.params];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:tmpRequestURL]];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[VGRequestQueue queue].operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (self.delegate != nil)
         {
             if (error != nil)
             {
                 [self.delegate requestDidFinishFail:&error];
             }
             else
             {
                 [self.delegate requestDidFinishSuccessful];
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