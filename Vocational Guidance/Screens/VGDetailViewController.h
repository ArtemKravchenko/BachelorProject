//
//  VGDetailViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"
#import "VGObject.h"

@interface VGDetailViewController : VGBaseViewController

@property (nonatomic, retain) VGObject* object;
@property (nonatomic, retain) NSMutableArray* fields;

@end
