//
//  VGFieldsListViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGFieldsListViewController.h"
#import "VGDetailViewController.h"
#import "VGAppDelegate.h"

static const NSInteger cellHeight               = 44;
static const NSInteger cellLabelWidth           = 130;
static const NSInteger cellLabelOriginX         = 0;
static const NSInteger cellValueFieldWidth      = 226;
static const NSInteger cellValueFieldOriginX    = 131;
static const NSInteger cellValueTag             = 300;

@interface VGFieldsListViewController ()

@property (nonatomic, retain) UIPopoverController* popover;
@property (nonatomic, retain) UITableView* tableValues;
@property (nonatomic, retain) VGSide* userSide;

@end

@implementation VGFieldsListViewController

#pragma mark - View life's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    self.popover = nil;
    self.tableValues = nil;
    self.emptyFields = nil;
    self.fieldsView = nil;
    self.fields  = nil;
    self.cellValueButton = nil;
    self.userSide = nil;
    [super dealloc];
}


#pragma mark - Initialize function

- (void) clearFieldsView {
    for (UIView* view in self.fieldsView.subviews) {
        [view removeFromSuperview];
    }
}

- (void) initFieldsWithFrame:(CGRect)frame {
    
    if (self.fieldsView != nil) {
        [self clearFieldsView];
    } else {
        self.fieldsView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
        self.view.frame = frame;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBackground2.png"]]];
    [self.fieldsView setContentSize:CGSizeMake(frame.size.width, frame.size.height+1)];
    [self.fieldsView setBounces:YES];
    
    NSInteger originY = 0;
    for (NSInteger i = 0; i < self.fields.count; i++) {
        originY = cellHeight * i;
        NSString* property = ((NSString*)[((NSDictionary*)[self.fields objectAtIndex:i]) objectForKey:@"property name"]);
        NSString* field = ((NSString*)[((NSDictionary*)[self.fields objectAtIndex:i]) objectForKey:@"field name"]);
        
        if (![self isFieldCanBeEmpty:property]) {
            NSArray* propertyArray = [property componentsSeparatedByString:@"."];
            // Create cell view
            UIView* cellView = [self cellViewWithWidth:self.cellWidth andOriginY:originY + 2 * i];
            cellView.tag = 100 + i;
            // Create cell label
            UILabel* cellPropertyLabel = [self cellLabelWithValue:field andWidth:cellLabelWidth andOriginX:cellLabelOriginX andOriginY:0];
            cellPropertyLabel.tag  = 200 + i;
            // Create cell value
            UITextField* cellValue = nil;
            if (self.object != nil) {
                if(propertyArray.count == 1) {
                    if ([self.object respondsToSelector:NSSelectorFromString(property)]) {
                        if ([property isEqualToString:@"credential"]) {
                            property = [NSString stringWithFormat:@"%@ToString",property];
                            cellValue = [self cellTextFieldWithOriginY:0 withValue:[self.object performSelector:NSSelectorFromString(property)]];
                        } else {
                            cellValue = [self cellTextFieldWithOriginY:0 withValue:[self.object performSelector:NSSelectorFromString(property)]];
                        }
                    }
                } else {
                    NSObject* firstObject = [self.object performSelector:NSSelectorFromString(propertyArray[0])];
                    NSObject* lastObject = firstObject;
                    for (int i =  1; i < propertyArray.count; i++) {
                        lastObject = [lastObject performSelector:NSSelectorFromString(propertyArray[i])];
                    }
                    self.cellValueButton = [self cellButtonWithOriginy:0 withValue:((NSString*)lastObject)];
                    if ([((NSString*)propertyArray[0]) isEqualToString: @"side"]) {
                        [self.cellValueButton addTarget:self action:@selector(sideClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            } else {
                if(propertyArray.count == 1) {
                    cellValue = [self cellTextFieldWithOriginY:0 withValue:nil];
                } else {
                    self.cellValueButton = [self cellButtonWithOriginy:0 withValue: nil];
                    [self.cellValueButton addTarget:self action:@selector(sideClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            self.cellValueButton.enabled = self.editMode;
            cellValue.enabled = self.editMode;
            cellValue.tag = cellValueTag + i;
            [cellView addSubview: (propertyArray.count == 1) ? cellValue : self.cellValueButton];
            [cellView addSubview:cellPropertyLabel];
            [self.fieldsView addSubview:cellView];
        } else {
            NSLog(@"%@ is can be empty", property);
        }
    }
    [self.view addSubview:self.fieldsView];
}

- (BOOL) isFieldCanBeEmpty:(NSString*)field{
    if (self.emptyFields != nil) {
        for (NSString* key in self.emptyFields) {
            if ([key isEqualToString:field]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSDictionary*) fieldsForSearch {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < self.fields.count; i++) {
        NSString* property = [NSString stringWithString:([((NSDictionary*)self.fields[i]) objectForKey:@"property name"])];
        NSString* clearProperty = [NSString stringWithString:property];
        NSArray* propertyArray = [property componentsSeparatedByString:@"."];
        if (propertyArray.count == 1) {
            NSString* firstCapitalString = [[property substringToIndex:1] uppercaseString];
            property = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapitalString];
            property = [NSString stringWithFormat:@"set%@:", property];
            NSString* value = ((UITextField*)[self.fieldsView viewWithTag:cellValueTag + i]).text;
            if (![value isEqualToString:@""] && (value != nil)) {
                [dictionary setObject:value forKey:clearProperty];
            }
        } else {
            NSObject* firstObject = [self.object performSelector:NSSelectorFromString(propertyArray[0])];
            NSObject* lastObject = firstObject;
            for (int i =  1; i < propertyArray.count; i++) {
                lastObject = [lastObject performSelector:NSSelectorFromString(propertyArray[i])];
            }
            if (lastObject != nil) {
                [dictionary setObject:[NSString stringWithFormat:@"%@", lastObject] forKey:clearProperty];
            }
        }
    }
    
    return dictionary;
}

- (BOOL) saveDataToObject {
    
    if (self.object == nil) {
        self.object = [[self.classValue new] autorelease];
        if ([self.object isKindOfClass:[VGStudent class]]) {
            ((VGStudent*)self.object).side = self.userSide;
        }
    }
    
    for (NSInteger i = 0; i < self.fields.count; i++) {
        NSString* property = [NSString stringWithString:([((NSDictionary*)self.fields[i]) objectForKey:@"property name"])];
        NSArray* propertyArray = [property componentsSeparatedByString:@"."];
        if (propertyArray.count == 1) {
            NSString* firstCapitalString = [[property substringToIndex:1] uppercaseString];
            property = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapitalString];
            property = [NSString stringWithFormat:@"set%@:", property];
            NSString* value = ((UITextField*)[self.fieldsView viewWithTag:cellValueTag + i]).text;
            if (![value isEqualToString:@""] && (value != nil)) {
                if ([self.object respondsToSelector:NSSelectorFromString(property)]) {
                    [self.object performSelector:NSSelectorFromString(property) withObject: value];
                } else {
                    [VGAlertView showError:[NSString stringWithFormat:@"(VGFieldsListViewController) Error: can't response selector (%@)", property]];
                    NSLog(@"(VGFieldsListViewController) Error: can't response selector (%@)", property);
                    return NO;
                }
            } else {
                if (![property isEqualToString:@"setDescription:"]) {
                    [VGAlertView showError:[NSString stringWithFormat:@"(VGFieldsListViewController) Error: property %@ value is nil", property]];
                    NSLog(@"(VGFieldsListViewController) Error: property %@ value is nil", property);
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - complex fields

- (void) sideClick:(UITextField*)sender {
    // init table view
    self.tableValues = [[UITableView new] autorelease];
    self.tableValues.delegate = self;
    self.tableValues.dataSource = self;
    self.tableValues.frame = CGRectMake(0, 0, 300, 300);
    
    // init controller for table view
    UIViewController* viewController = [[UIViewController new] autorelease];
    viewController.view = self.tableValues;
    
    // init popover view controller
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController: viewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(320, 480)];
    [self.popover presentPopoverFromRect: CGRectMake(100, 100, 1, 1)
                                  inView: self.view
                permittedArrowDirections: ([self.parentViewController isKindOfClass:[VGDetailViewController class]]) ? UIPopoverArrowDirectionLeft : UIPopoverArrowDirectionRight
                                animated: YES];
}

#pragma mark - table data source delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [VGAppDelegate getInstance].allSides.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellValue = ((VGSide*)[VGAppDelegate getInstance].allSides[indexPath.row]).name;
    cell.textLabel.text = cellValue;
    return cell;
}

#pragma mark - table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.object == nil) {
        self.userSide = [VGAppDelegate getInstance].allSides[indexPath.row];
    } else {
        [self.object performSelector:@selector(setSide:) withObject:[VGAppDelegate getInstance].allSides[indexPath.row]];
    }
    [self.popover dismissPopoverAnimated:YES];
    [self.cellValueButton setTitle:((VGSide*)[VGAppDelegate getInstance].allSides[indexPath.row]).name forState:UIControlStateNormal];
}

#pragma mark - "get" view functions

- (UIView*) cellViewWithWidth:(NSInteger)cellWidth andOriginY:(NSInteger)originY {
    UIView* newCellView = [[UIView new] autorelease];
    [newCellView setFrame:CGRectMake(0, originY, cellWidth, cellHeight)];
    [newCellView setBackgroundColor:[UIColor clearColor]];
    return newCellView;
}

- (UILabel*) cellLabelWithValue:(NSString*)value andWidth:(NSInteger)width andOriginX:(NSInteger)originX andOriginY:(NSInteger)originY {
    UILabel* newCellLabel = [[UILabel new] autorelease];
    [newCellLabel setFrame:CGRectMake(originX, originY, width, cellHeight)];
    [newCellLabel setText:value];
    [newCellLabel setFont:[UIFont systemFontOfSize:17]];
    [newCellLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ListLabelCell.png"]]];
    return newCellLabel;
}

- (UITextField*) cellTextFieldWithOriginY:(NSInteger)originY withValue:(NSString*)value{
    UITextField* newCellEmptyTextField = [[UITextField new] autorelease];
    [newCellEmptyTextField setFrame:CGRectMake(cellLabelWidth, originY, self.cellWidth - cellLabelWidth, cellHeight)];
    [newCellEmptyTextField setBackgroundColor:[UIColor yellowColor]];
    [newCellEmptyTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [newCellEmptyTextField setTextAlignment:NSTextAlignmentCenter];
    if (value != nil) {
        [newCellEmptyTextField setText:value];
    }
    return newCellEmptyTextField;
}

- (UIButton*) cellButtonWithOriginy: (NSInteger)originY withValue:(NSString*)value {
    UIButton* newCellButton = [[UIButton new] autorelease];
    [newCellButton setFrame:CGRectMake(cellLabelWidth, originY, self.cellWidth - cellLabelWidth, cellHeight)];
    [newCellButton setTitle: (value != nil) ? value : @"" forState:UIControlStateNormal];
    [newCellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newCellButton setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    [newCellButton setBackgroundColor:[UIColor yellowColor]];
    return  newCellButton;
}

@end