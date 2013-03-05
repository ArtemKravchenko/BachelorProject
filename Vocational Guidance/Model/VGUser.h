//
//  VGUser.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGAppDelegate.h"

typedef enum
{
    VGCredentilasTypeManager = 1,
    VGCredentilasTypeExpert = 2,
    VGCredentilasTypeSecretar = 3
} VGCredentilasType;

@interface VGUser : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSString* side;
@property (nonatomic, retain) NSString* login;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* user_id;
@property (nonatomic, retain) NSString* dataSet;
@property (nonatomic, assign) VGCredentilasType credential;

@end