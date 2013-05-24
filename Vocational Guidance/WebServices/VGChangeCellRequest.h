//
//  VGChangeCellRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGAppDelegate.h"

@interface VGChangeCellRequest : VGBaseRequest <VGBaseRequestDelegate>

- (id)initWithPersonId:(NSString*)personId andDelegate:(id<VGBaseRequestDelegate>)target;

@end
