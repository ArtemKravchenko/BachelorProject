//
//  VGFieldsListViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGStudent.h"

@interface VGFieldsListViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) id<VGTableVariable> object;
@property (nonatomic, retain) NSMutableArray* fields;
@property (nonatomic, retain) UIScrollView* fieldsView;
@property (nonatomic, retain) NSMutableArray* emptyFields;
@property (nonatomic, retain) UIButton* cellValueButton;
@property (nonatomic, assign) NSInteger cellWidth;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, assign) Class classValue;

- (void) initFieldsWithFrame:(CGRect)frame;
- (BOOL) saveDataToObject;

@end
