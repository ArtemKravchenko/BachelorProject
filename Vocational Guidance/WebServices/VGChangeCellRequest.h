//
//  VGChangeCellRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGAppDelegate.h"
#import "ASIFormDataRequest.h"

@interface VGChangeCellRequest : ASIFormDataRequest

- (id)initWithPersonId:(NSString*)personId andTransactionList:(NSDictionary*)transactionList;

@end
