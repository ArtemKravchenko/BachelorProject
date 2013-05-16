//
//  VGUtilities.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGUser.h"
#import "VGBaseDataModel.h"

@interface VGUtilities : NSObject

+ (VGUser*)userFromJsonData:(NSDictionary*)data;
+ (NSMutableDictionary*) fieldsForCredentialType:(VGCredentilasType)credentialType;
+ (NSMutableDictionary*) fieldsFromPlistNameWithName:(NSString*) name;
+ (UILabel*) changeTitleNameWithText:(NSString*) text;
+ (VGBaseDataModel*) baseDataModelFromJsonData:(NSDictionary*)jsonInfo withCredentialType:(VGCredentilasType)credentialType;
+ (id<VGTableVariable>) tableVariableFromJsonData:(NSDictionary*)jsonInfo withClassType:(Class)type;
+ (NSMutableArray*) arrayUsersFromResultData:(NSDictionary*)jsonInfo;

@end
