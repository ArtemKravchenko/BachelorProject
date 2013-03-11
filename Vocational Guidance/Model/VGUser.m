//
//  VGUser.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUser.h"

@implementation VGUser

- (NSString *)credentialToString {
    NSString* stringCredential = nil;
    switch (self.credential) {
        case VGCredentilasTypeEmployer:
            stringCredential = @"Employer";
            break;
            
        case VGCredentilasTypeExpert:
            stringCredential = @"Expert";
            break;
            
        case VGCredentilasTypeManager:
            stringCredential = @"Manager";
            break;
            
        case VGCredentilasTypeSecretar:
            stringCredential = @"Secretar";
            break;
            
        default:
            break;
    }
    return stringCredential;
}

- (void)dealloc
{
    [_dataSet release];
    [_name release];
    [_surname release];
    [_side release];
    [_login release];
    [_password release];
    [_user_id release];
    [super dealloc];
}



@end
