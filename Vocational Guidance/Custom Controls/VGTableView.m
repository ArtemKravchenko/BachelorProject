//
//  VGTableView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableView.h"
#import "VGAddToTableViewController.h"

static const NSInteger cellWidth        = 95;
static const NSInteger cellHeight       = 59;
static const NSInteger keyHeight        = 352;
static const NSInteger viewFrameOffsetY = 61;
static const NSInteger viewBoundY       = 488;

@interface VGTableView () {
    VGAddToTableViewController *insideViewController;
    VGButtonClickedType buttonClickedType;
    UIButton *btnAddRow;
    UIButton *btnAddCol;
    BOOL canEdit;
}

@property (nonatomic, retain) UIPopoverController *popover;

@end

@implementation VGTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        canEdit = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    NSInteger offsetX = 2;
    NSInteger offsetY = 2;
    
    btnAddRow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAddRow addTarget:self action:@selector(clickAddRow) forControlEvents:UIControlEventTouchUpInside];
    btnAddRow.enabled = NO;
    [btnAddRow setTitle:@"+" forState:UIControlStateNormal];
    //btnAddRow.titleLabel.backgroundColor = [UIColor grayColor];
    btnAddRow.frame = CGRectMake(1, cellHeight / 2 , cellWidth / 2, cellHeight / 2);
    [self addSubview:btnAddRow];
    
    btnAddCol = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAddCol addTarget:self action:@selector(clickAddCol) forControlEvents:UIControlEventTouchUpInside];
    btnAddCol.enabled = NO;
    //btnAddCol.titleLabel.backgroundColor = [UIColor grayColor];
    [btnAddCol setTitle:@"+" forState:UIControlStateNormal];
    btnAddCol.frame = CGRectMake(cellWidth / 2 , 1 , cellWidth / 2, cellHeight / 2);
    [self addSubview:btnAddCol];
    
    // init columns headers
    for (int i  = 0; i < [VGAppDelegate getInstance].columns.count; i++) {
        // Init label
        UILabel *lblColumnHeader = [[[UILabel alloc] initWithFrame:CGRectMake(cellWidth + cellWidth * i + offsetX, 0, cellWidth, cellHeight)] autorelease];
        lblColumnHeader.backgroundColor = [UIColor yellowColor];
        lblColumnHeader.textAlignment = NSTextAlignmentCenter;
        [lblColumnHeader setNumberOfLines:10];
        lblColumnHeader.text = [NSString stringWithFormat:@"%@", [VGAppDelegate getInstance].columns[i]];
        [self addSubview:lblColumnHeader];
        offsetX += 2;
    }
    
    // init rows headers
    for (int i = 0; i < [VGAppDelegate getInstance].rows.count; i++) {
        UILabel *lblRowHeader = [[[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight)] autorelease];
        lblRowHeader.backgroundColor = [UIColor yellowColor];
        lblRowHeader.textAlignment = NSTextAlignmentCenter;
        [lblRowHeader setNumberOfLines:10];
        lblRowHeader.text = [NSString stringWithFormat:@"%@", [VGAppDelegate getInstance].rows[i]];
        [self addSubview:lblRowHeader];
        offsetX = 2;
        for (NSInteger j = 0; j < [VGAppDelegate getInstance].columns.count; j++) {
            UITextField *cell = [[[UITextField alloc] initWithFrame:CGRectMake(cellWidth + cellWidth * j + offsetX, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight)] autorelease];
            cell.backgroundColor = (canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
            cell.textAlignment = NSTextAlignmentCenter;
            cell.enabled = canEdit;
            cell.tag = i * [VGAppDelegate getInstance].columns.count + j;
            cell.delegate = nil;
            cell.delegate = self;
            cell.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d", @"rowIndex", i, @"colIndex", j];
            NSMutableArray *tmpValue = [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].values];
            [tmpValue filterUsingPredicate:predicate];
            if (tmpValue.count) {
                cell.text = [NSString stringWithFormat:@"%@", ((VGTableCell*)tmpValue[0]).value];
            } else {
                cell.text = [NSString stringWithFormat:@"%d", 0];
                VGTableCell *tmpCell = [[VGTableCell new] autorelease];
                tmpCell.colIndex = j;
                tmpCell.rowIndex = i;
                tmpCell.value = [NSString stringWithFormat:@"%d", 0];
                [[VGAppDelegate getInstance].values addObject:tmpCell];
            }
            [self addSubview:cell];
            offsetX += 2;
        }
        offsetY += 2;
    }
    self.contentSize = CGSizeMake(cellWidth + cellWidth * [VGAppDelegate getInstance].columns.count + offsetX , cellHeight * [VGAppDelegate getInstance].rows.count + offsetY + cellHeight);
    
}

- (void)dealloc
{
    btnAddCol = nil;
    btnAddRow = nil;
    self.popover = nil;
    [super dealloc];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger differece = (textField.frame.origin.y - viewFrameOffsetY > viewBoundY) ? textField.frame.origin.y - viewFrameOffsetY - viewBoundY : 0;
    
    NSInteger tmpvalue = keyHeight - (textField.frame.origin.y + textField.frame.size.height) + differece;
    if (tmpvalue < 0) {
        [self animateChangeOriginYView:self forValue: (tmpvalue - textField.frame.size.height)];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSInteger differece = (textField.frame.origin.y - viewFrameOffsetY > viewBoundY) ? textField.frame.origin.y - viewFrameOffsetY - viewBoundY: 0;
    
    NSInteger tmpvalue = keyHeight - (textField.frame.origin.y + textField.frame.size.height) + differece;
    if (tmpvalue < 0) {
        [self animateChangeOriginYView:self forValue: -(tmpvalue - textField.frame.size.height)];
    }
    if (self.tableDetegate != nil) {
        NSInteger rowIndex = textField.tag / [VGAppDelegate getInstance].columns.count;
        NSInteger colIndex = textField.tag % [VGAppDelegate getInstance].columns.count;
        [self.tableDetegate cellDidChangedAtRow:rowIndex andColIndex:colIndex withValue:textField.text];
        
    }
    return YES;
}

- (void)animateChangeOriginYView:(UIView*)view forValue:(NSInteger)value {
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut)
                     animations:^(void)
     {
         CGRect frame = view.frame;
         frame.origin.y += value;
         view.frame = frame;
     }
                     completion:nil];
}

#pragma mark - Edit mode 

- (void) edtiMode:(BOOL)value {
    canEdit = value;
    for (UIView * textField in self.subviews) {
        if ([textField isKindOfClass: [UITextField class]]) {
            ((UITextField*)textField).enabled = canEdit;
            ((UITextField*)textField).backgroundColor = (canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
        }
    }
    btnAddCol.enabled = canEdit;
    //btnAddCol.titleLabel.backgroundColor = (canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
    btnAddRow.enabled = canEdit;
    //btnAddRow.titleLabel.backgroundColor = (canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
}

#pragma mark - Actions

- (void) addToTableMethod:(NSString*)name {
    if (buttonClickedType == VGButtonClickedTypeRow) {
        [[VGAppDelegate getInstance].rows addObject:name];
        if (self.tableDetegate != nil) {
            [self.tableDetegate rowDidAddWithName:name];
        }
    } else {
        [[VGAppDelegate getInstance].columns addObject:name];
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

@end
