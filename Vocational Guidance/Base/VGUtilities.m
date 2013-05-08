//
//  VGUtilities.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUtilities.h"
#import "VGAppDelegate.h"

@implementation VGUtilities

+ (VGUser*)userFromJsonData:(NSData*)data {
    NSDictionary* jsonInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    VGUser* user = [[VGUser new] autorelease];
    
    return user;
}

+ (NSMutableDictionary*) fieldsForCredentialType:(VGCredentilasType)credentialType{
    
    NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionary];
    
    NSArray* fields = nil;
    NSArray* emptyFields = nil;
    NSDictionary* contentDictionary = nil;
    
    NSString* credentialName = nil;
    if (credentialType == VGCredentilasTypeStudent) {
        credentialName = kStudent;
    } else {
        credentialName = kUser;
    }
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:credentialName ofType:@"plist"];
    contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    fields = [contentDictionary objectForKey:kFields];
    [returnDictionary setObject:fields forKey:kFields];
    
    NSDictionary* iconDictionary = [contentDictionary objectForKey:kIcons];
    [returnDictionary setObject:iconDictionary forKey:kIcons];
    
    emptyFields = [contentDictionary objectForKey:@"Can be empty"];
    [returnDictionary setObject:emptyFields forKey:kEmptyFields];
    
    return returnDictionary;
}

+ (NSMutableDictionary*) fieldsFromPlistNameWithName:(NSString*) name {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSMutableDictionary* contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return contentDictionary;
}

@end
