//
//  VGTableView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableView.h"
#import "VGAddToTableViewController.h"

static const NSInteger cellWidth = 95;
static const NSInteger cellHeight = 59;

@interface VGTableView () {
    VGAddToTableViewController *insideViewController;
    VGButtonClickedType buttonClickedType;
}

@property (nonatomic, retain) UIPopoverController *popover;

@end

@implementation VGTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    NSInteger offsetX = 2;
    NSInteger offsetY = 2;
    
    UIButton *addRow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addRow addTarget:self action:@selector(clickAddRow) forControlEvents:UIControlEventTouchUpInside];
    [addRow setTitle:@"+" forState:UIControlStateNormal];
    addRow.frame = CGRectMake(1, cellHeight / 2 , cellWidth / 2, cellHeight / 2);
    [self addSubview:addRow];
    
    UIButton *addCol = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addCol addTarget:self action:@selector(clickAddCol) forControlEvents:UIControlEventTouchUpInside];
    [addCol setTitle:@"+" forState:UIControlStateNormal];
    addCol.frame = CGRectMake(cellWidth / 2 , 1 , cellWidth / 2, cellHeight / 2);
    [self addSubview:addCol];
    
    // init columns headers
    for (int i  = 0; i < self.columns.count; i++) {
        // Init label
        UILabel *lblColumnHeader = [[[UILabel alloc] initWithFrame:CGRectMake(cellWidth + cellWidth * i + offsetX, 0, cellWidth, cellHeight)] autorelease];
        lblColumnHeader.backgroundColor = [UIColor yellowColor];
        lblColumnHeader.textAlignment = NSTextAlignmentCenter;
        [lblColumnHeader setNumberOfLines:10];
        lblColumnHeader.text = [NSString stringWithFormat:@"%@", self.columns[i]];
        [self addSubview:lblColumnHeader];
        offsetX += 2;
    }
    
    // init rows headers
    for (int i = 0; i < self.rows.count; i++) {
        UILabel *lblRowHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight)] autorelease];
        lblRowHeader.backgroundColor = [UIColor yellowColor];
        lblRowHeader.textAlignment = NSTextAlignmentCenter;
        [lblRowHeader setNumberOfLines:10];
        lblRowHeader.text = [NSString stringWithFormat:@"%@", self.rows[i]];
        [self addSubview:lblRowHeader];
        offsetX = 2;
        for (NSInteger j = 0; j < self.columns.count; j++) {
            UITextField *cell = [[[UITextField alloc] initWithFrame:CGRectMake(cellWidth + cellWidth * j + offsetX, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight)] autorelease];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textAlignment = NSTextAlignmentCenter;
            cell.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d", @"rowIndex", i, @"colIndex", j];
            NSMutableArray *tmpValue = [NSMutableArray arrayWithArray:self.values];
            [tmpValue filterUsingPredicate:predicate];
            if (tmpValue.count) {
                cell.text = [NSString stringWithFormat:@"%@", ((VGTableCell*)tmpValue[0]).value];
            } else {
                NSLog(@"%d  %d", i ,j);
            }
            [self addSubview:cell];
            offsetX += 2;
        }
        
        offsetY += 2;
    }
    self.contentSize = CGSizeMake(cellWidth + cellWidth * self.columns.count + offsetX , cellHeight * self.rows.count + offsetY + cellHeight);
    
}

#pragma mark - Actions

- (void) addToTableMethod:(NSString*)name {
    if (buttonClickedType == VGButtonClickedTypeRow) {
        [self.rows addObject:name];
        if (self.tableDetegate != nil) {
            [self.tableDetegate rowDidAddWithName:name];
        }
    } else {
        [self.columns addObject:name];
        if (self.tableDetegate != nil) {
            [self.tableDetegate colDidAddWithName:name];
        }
    }
    [self drawRect:self.frame];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void) clickAddRow {
    buttonClickedType = VGButtonClickedTypeRow;
    insideViewController = [[VGAddToTableViewController new] autorelease];
    insideViewController.method = @selector(addToTableMethod:);
    insideViewController.target = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:insideViewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(292, 56)];
    [self.popover presentPopoverFromRect: CGRectMake(25, 55, 1, 1)
                             inView: self
           permittedArrowDirections: UIPopoverArrowDirectionUp
                                animated: YES];
}

- (void) clickAddCol {
    buttonClickedType = VGButtonClickedTypeCol;
    insideViewController = [[VGAddToTableViewController new] autorelease];
    insideViewController.method = @selector(addToTableMethod:);
    insideViewController.target = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:insideViewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(292, 56)];
    [self.popover presentPopoverFromRect: CGRectMake(90, 15, 1, 1)
                                  inView: self
                permittedArrowDirections: UIPopoverArrowDirectionLeft
                                animated: YES];
}

- (void)dealloc
{
    self.popover = nil;
    self.rows = nil;
    self.columns = nil;
    self.values = nil;
    [super dealloc];
}

@end

@implementation VGTableCell

@end
