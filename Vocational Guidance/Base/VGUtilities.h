//
//  VGUtilities.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGUser.h"

@interface VGUtilities : NSObject

+ (VGUser*)userFromJsonData:(NSData*)data;
+ (NSMutableDictionary*) fieldsForCredentialType:(VGCredentilasType)credentialType;
+ (NSMutableDictionary*) fieldsFromPlistNameWithName:(NSString*) name;

@end
