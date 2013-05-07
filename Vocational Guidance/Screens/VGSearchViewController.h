//
//  VGSearchViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"

@interface VGSearchViewController : VGBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray* fieldsList;
@property (nonatomic, retain) NSMutableArray* emptyFields;
@property (retain, nonatomic) Class objectsType;

@end
