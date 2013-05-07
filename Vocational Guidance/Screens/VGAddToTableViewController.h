//
//  VGAddToTableViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGAddToTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL method;
@property (nonatomic, retain) NSMutableArray* allRows;
@property (nonatomic, retain) NSMutableArray* allColumns;

- (id)initWithExistArray:(NSMutableArray*) existArray andFlag:(BOOL)isRow andGlobalArray:(NSMutableArray*)globalArray;

@end
