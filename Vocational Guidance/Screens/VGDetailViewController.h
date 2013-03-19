//
//  VGDetailViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"
#import "VGObject.h"
#import "VGAppDelegate.h"

@interface VGDetailViewController : VGBaseViewController

@property (nonatomic, retain) VGObject* object;
@property (nonatomic, retain) NSMutableArray* fields;
@property (retain, nonatomic) IBOutlet UIButton *btnViewTable;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic, assign) SEL initMethod;

// Factory

- (id) initForAddNewObject:(Class)classValue;
- (id) initForChooseExistObject:(Class)classValue;

@end
