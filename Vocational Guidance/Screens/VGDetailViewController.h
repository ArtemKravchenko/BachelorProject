//
//  VGDetailViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"

@interface VGDetailViewController : VGBaseViewController

@property (nonatomic, retain) id<VGTableVariable> object;
@property (nonatomic, retain) NSMutableArray* fields;
@property (retain, nonatomic) Class classValue;
@property (nonatomic, retain) NSString* imageName;

// Factory methods

- (id) initWithChooseState:(Class) classValue;
- (id) initWithEditState:(Class)classValue;
- (id) initWithViewState:(Class)classValue;
- (id) initWithAddState:(Class)classValue;

@end
