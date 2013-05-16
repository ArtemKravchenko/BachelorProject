//
//  VGChangeCellRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChangeCellRequest.h"

static NSString* const kChangeCellUrlRoute =              @"";

@implementation VGChangeCellRequest

- (id)initWithPersonId:(NSString*)personId andTransactionList:(NSDictionary*)transactionList {
    NSString *tmpRequestURL = [NSString stringWithFormat:@"%@/%@", VG_BASE_URL, kChangeCellUrlRoute];
    DLog(@"%@", tmpRequestURL);
    self = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:tmpRequestURL]] retain];
    if (self) {
        self.requestMethod = @"POST";
        [self setPostValue:transactionList forKey: @"transactions"];
        [self setPostValue:[NSNumber numberWithInt:[personId intValue]] forKey:@"personId"];
    }
    return self;
}

@end
