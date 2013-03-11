//
//  VGUser.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGAppDelegate.h"
#import "VGObject.h"

typedef enum
{
    VGCredentilasTypeManager = 1,
    VGCredentilasTypeExpert = 2,
    VGCredentilasTypeSecretar = 3,
    VGCredentilasTypeEmployer = 4,
    VGCredentilasTypeStudent = 5
} VGCredentilasType;

@interface VGUser : VGObject

@property (nonatomic, retain) NSString* user_id;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSString* side;
@property (nonatomic, retain) NSString* login;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, assign) VGCredentilasType credential;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSMutableArray* dataSet;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *columns;

@property (readonly, retain) NSString* credentialToString;
@end