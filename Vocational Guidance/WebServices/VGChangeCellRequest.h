//
//  VGChangeCellRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGAppDelegate.h"

@interface VGChangeCellRequest : VGBaseRequest

- (id)initWithRow:(id<VGTableVariable>)row andColumn:(id<VGTableVariable>)column andValue:(NSString*)value;

@end
