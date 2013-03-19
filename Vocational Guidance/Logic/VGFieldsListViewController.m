//
//  VGFieldsListViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGFieldsListViewController.h"
#import "VGAppDelegate.h"

static const NSInteger cellHeight               = 44;
static const NSInteger cellLabelWidth           = 130;
static const NSInteger cellLabelOriginX         = 0;
static const NSInteger cellValueFieldWidth      = 226;
static const NSInteger cellValueFieldOriginX    = 131;
static const NSInteger cellValueTag             = 300;

@interface VGFieldsListViewController ()

@end

@implementation VGFieldsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View life's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [_autoBlankFields release];
    [_fieldsView release];
    [_fields release];
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
    
    [self.view setBackgroundColor:[UIColor redColor]];
    [self.fieldsView setContentSize:CGSizeMake(frame.size.width, frame.size.height+1)];
    [self.fieldsView setBounces:YES];
    
    NSInteger originY = 0;
    NSInteger indexConsiderAutoblank = 0;
    for (NSInteger i = 0; i < self.fields.count; i++) {
        originY = cellHeight * indexConsiderAutoblank + 1 * indexConsiderAutoblank;
        NSString* property = ((NSString*)[self.fields objectAtIndex:i]);
        
        if (![self isFieldExistInAutoblantList:property]) {
            // Create cell view
            UIView* cellView = [self cellViewWithWidth:self.cellWidth andOriginY:originY];
            cellView.tag = 100 + i;
            // Create cell label
            UILabel* cellPropertyLabel = [self cellLabelWithValue:property andWidth:cellLabelWidth andOriginX:cellLabelOriginX andOriginY:0];
            cellPropertyLabel.tag  = 200 + i;
            // Create cell value
            UITextField* cellValue = nil;
            if (self.object != nil) {
                if ([self.object respondsToSelector:NSSelectorFromString(property)]) {
                    if ([property isEqualToString:@"credential"]) {
                        property = [NSString stringWithFormat:@"%@ToString",property];
                        cellValue = [self cellTextFieldWithOriginY:0 withValue:[self.object performSelector:NSSelectorFromString(property)]];
                    } else {
                        cellValue = [self cellTextFieldWithOriginY:0 withValue:[self.object performSelector:NSSelectorFromString(property)]];
                    }
                }
            } else {
                cellValue = [self cellTextFieldWithOriginY:0 withValue:nil];
            }
            cellValue.enabled = self.editMode;
            cellValue.tag = cellValueTag + i;
            [cellView addSubview:cellValue];
            [cellView addSubview:cellPropertyLabel];
            [self.fieldsView addSubview:cellView];
            indexConsiderAutoblank++;
        } else {
            NSLog(@"%@ is autoblank", property);
        }
    }
    [self.view addSubview:self.fieldsView];
}

- (BOOL) isFieldExistInAutoblantList:(NSString*)field {
    for (NSString* key in self.autoBlankFields) {
        if ([key isEqualToString:field]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) saveDataToObject {
    if (self.object == nil) {
        self.object = [[self.classValue new] autorelease];
        self.object.object_id = [NSString stringWithFormat:@"tmp%d", ++[VGAppDelegate getInstance].tmpGlobalId];
    }
    
    for (NSInteger i = 0; i < self.fields.count; i++) {
        NSString* property = [NSString stringWithString:self.fields[i]];
        NSString* firstCapitalString = [[property substringToIndex:1] uppercaseString];
        property = [property stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapitalString];
        property = [NSString stringWithFormat:@"set%@:", property];
        NSString* value = ((UITextField*)[self.fieldsView viewWithTag:cellValueTag + i]).text;
        if (![value isEqualToString:@""] && (value != nil)) {
            if ([self.object respondsToSelector:NSSelectorFromString(property)]) {
                [self.object performSelector:NSSelectorFromString(property) withObject:value];
            } else {
                NSLog(@"Error: can't response selector (%@)", property);
                return NO;
            }
        } else {
            if (![property isEqualToString:@"setDescription:"]) {
                NSLog(@"Error: value is nil");
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - get view functions

- (UIView*) cellViewWithWidth:(NSInteger)cellWidth andOriginY:(NSInteger)originY {
    UIView* newCellView = [[UIView new] autorelease];
    [newCellView setFrame:CGRectMake(0, originY, cellWidth, cellHeight)];
    [newCellView setBackgroundColor:[UIColor blackColor]];
    return newCellView;
}

- (UILabel*) cellLabelWithValue:(NSString*)value andWidth:(NSInteger)width andOriginX:(NSInteger)originX andOriginY:(NSInteger)originY {
    UILabel* newCellLabel = [[UILabel new] autorelease];
    [newCellLabel setFrame:CGRectMake(originX, originY, width, cellHeight)];
    [newCellLabel setText:value];
    [newCellLabel setFont:[UIFont systemFontOfSize:17]];
    return newCellLabel;
}

- (UITextField*) cellTextFieldWithOriginY:(NSInteger)originY withValue:(NSString*)value{
    UITextField* newCellEmptyTextField = [[UITextField new] autorelease];
    [newCellEmptyTextField setFrame:CGRectMake(cellLabelWidth, originY, self.cellWidth - cellLabelWidth, cellHeight)];
    [newCellEmptyTextField setBackgroundColor:[UIColor yellowColor]];
    [newCellEmptyTextField setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
    if (value != nil) {
        [newCellEmptyTextField setText:value];
    }
    return newCellEmptyTextField;
}

@end