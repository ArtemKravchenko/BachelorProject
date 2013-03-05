//
//  VGScreenNavigator.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VGScreenNavigator : NSObject

+ (void) initStartScreenMapping;

+ (void) navigateToScreen : (NSString*)name;

+ (NSMutableDictionary*) screenMapping;

@end
