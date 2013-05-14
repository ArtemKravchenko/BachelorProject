//
//  VGScreenNavigator.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGUser.h"
#import "VGSavedScreenInfo.h"

@interface VGScreenNavigator : NSObject

+ (void) initStartScreenMapping;

+ (void) navigateToScreen : (NSString*)name;

+ (NSMutableDictionary*) screenMapping;

+ (void) showResultButton;

+ (void) hideResultButton;

+ (void) fillDetailsScreenWitCredentialType:(VGCredentilasType)credentialType withObject:(id<VGPerson>) person forKey:(NSString*)key;

+ (void) fillSearchScreenWithCredentialType:(VGCredentilasType)credentialType forKey:(NSString*)key;

@end
