//
//  VGFieldsListViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGObject.h"

@interface VGFieldsListViewController : UIViewController

@property (nonatomic, retain) VGObject* object;
@property (nonatomic, retain) NSMutableArray* fields;
@property (nonatomic, retain) UIScrollView* fieldsView;
@property (nonatomic, assign) NSInteger cellWidth;

- (void) initFieldsWithFrame:(CGRect)frame ;

@end
