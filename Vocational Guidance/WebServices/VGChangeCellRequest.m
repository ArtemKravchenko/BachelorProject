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
    self = [super init];
    if (self) {
        // TODO : special case, needs POST request
    }
    return self;
}

@end
