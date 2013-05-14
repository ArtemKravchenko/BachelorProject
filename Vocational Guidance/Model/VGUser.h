//
//  VGUser.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGSide.h"

typedef enum
{
    VGCredentilasTypeManager = 1,
    VGCredentilasTypeExpert = 2,
    VGCredentilasTypeSecretar = 3,
    VGCredentilasTypeEmployer = 4,
    VGCredentilasTypeStudent = 5
} VGCredentilasType;

@protocol VGPerson <NSObject, VGTableVariable>

@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* secondName;
@property (nonatomic, retain) NSString* age;
@property (nonatomic, retain) VGSide*   side;
@property (nonatomic, retain) NSMutableArray* dataSet;
@property (nonatomic, retain) NSMutableArray* rows;
@property (nonatomic, retain) NSMutableArray* columns;
@property (nonatomic, assign) VGCredentilasType credential;
@property (readonly, retain) NSString* credentialToString;

@end

@interface VGUser : NSObject <VGPerson>

@property (nonatomic, retain) NSString*         login;
@property (nonatomic, retain) NSString*         password;

@end