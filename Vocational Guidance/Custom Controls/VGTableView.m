//
//  VGTableView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableView.h"
#import "VGBaseDataModel.h"

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
    NSString *tmpString;
    VGDetailViewController* detailViewController;
    NSString* rowPlistName;
    NSString* colPlistName;
}

@property (nonatomic, retain) UIPopoverController *popover;

@end

@implementation VGTableView

- (id)initWithFrame:(CGRect)frame andUser:(VGUser*) user;
{
    self = [super initWithFrame:frame];
    if (self) {
        canEdit = NO;
        self.user = user;
        
        // init columns plist name
        switch ([VGAppDelegate getInstance].currentUser.credential) {
            case VGCredentilasTypeEmployer:
                colPlistName = @"Skill";
                break;
                
            case VGCredentilasTypeExpert:
                colPlistName = @"Subject";
                break;
                
            case VGCredentilasTypeSecretar:
                colPlistName = @"Student";
                break;
                
            default:
                break;
        }
        
        
        // init rows plist name
        switch ([VGAppDelegate getInstance].currentUser.credential) {
            case VGCredentilasTypeEmployer:
                rowPlistName = @"Job";
                break;
                
            case VGCredentilasTypeExpert:
                rowPlistName = @"Skill";
                break;
                
            case VGCredentilasTypeSecretar:
                rowPlistName = @"Subject";
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (void) removeAllFromView {
    for (UIView* view in self.subviews) {
        if (![view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        } else {
            if (![((UIButton*)view).titleLabel.text isEqualToString:@"+"]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void) reloadData {
    [self removeAllFromView];
    
    self.backgroundColor = [UIColor whiteColor];
    NSInteger offsetX = 2;
    NSInteger offsetY = 2;
    
    if (btnAddRow == nil) {
        btnAddRow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAddRow addTarget:self action:@selector(clickAddRow) forControlEvents:UIControlEventTouchUpInside];
        btnAddRow.enabled = NO;
        [btnAddRow setTitle:@"+" forState:UIControlStateNormal];
        //btnAddRow.titleLabel.backgroundColor = [UIColor grayColor];
        btnAddRow.frame = CGRectMake(1, cellHeight / 2 , cellWidth / 2, cellHeight / 2);
        [self addSubview:btnAddRow];
    }
    
    if (btnAddCol == nil) {
        btnAddCol = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAddCol addTarget:self action:@selector(clickAddCol) forControlEvents:UIControlEventTouchUpInside];
        btnAddCol.enabled = NO;
        //btnAddCol.titleLabel.backgroundColor = [UIColor grayColor];
        [btnAddCol setTitle:@"+" forState:UIControlStateNormal];
        btnAddCol.frame = CGRectMake(cellWidth / 2 , 1 , cellWidth / 2, cellHeight / 2);
        [self addSubview:btnAddCol];
    }
    
    // init columns headers
    for (int i  = 0; i < self.user.columns.count; i++) {
        // Init label
        UIButton* btnColumnHeader = [UIButton buttonWithType:UIButtonTypeCustom];
        btnColumnHeader.frame = CGRectMake(cellWidth + cellWidth * i + offsetX, 0, cellWidth, cellHeight);
        btnColumnHeader.tag = 1000 + i;
        [btnColumnHeader setBackgroundColor:[UIColor yellowColor]];
        [btnColumnHeader setTintColor:[UIColor whiteColor]];
        [btnColumnHeader.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btnColumnHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnColumnHeader setTitle: [NSString stringWithFormat:@"%@", ((VGObject*)self.user.columns[i]).name] forState:UIControlStateNormal];
        [btnColumnHeader addTarget:self action:@selector(clickColumnHeader:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnColumnHeader];
        
        offsetX += 2;
    }
    
    // init rows headers
    for (int i = 0; i < self.user.rows.count; i++) {
        UIButton* btnRowHeader = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRowHeader.frame = CGRectMake(0, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight);
        btnRowHeader.tag = 2000 + i;
        [btnRowHeader setBackgroundColor:[UIColor yellowColor]];
        [btnRowHeader setTintColor:[UIColor whiteColor]];
        [btnRowHeader.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btnRowHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnRowHeader setTitle: [NSString stringWithFormat:@"%@", ((VGObject*)self.user.rows[i]).name] forState:UIControlStateNormal];
        [btnRowHeader addTarget:self action:@selector(clickRowHeader:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRowHeader];
        offsetX = 2;
        for (NSInteger j = 0; j < self.user.columns.count; j++) {
            UITextField *cell = [[[UITextField alloc] initWithFrame:CGRectMake(cellWidth + cellWidth * j + offsetX, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight)] autorelease];
            cell.backgroundColor = (canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
            cell.textAlignment = NSTextAlignmentCenter;
            cell.enabled = canEdit;
            cell.tag = i * self.user.columns.count + j;
            cell.delegate = nil;
            cell.delegate = self;
            cell.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d", @"rowIndex", i, @"colIndex", j];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ AND %K LIKE %@", @"row.object_id", ((VGObject*)self.user.rows[i]).object_id, @"col.object_id", ((VGObject*)self.user.columns[j]).object_id];
            NSMutableArray *tmpValue = [NSMutableArray arrayWithArray:self.user.dataSet];
            [tmpValue filterUsingPredicate:predicate];
            if (tmpValue.count) {
                cell.text = [NSString stringWithFormat:@"%@", ((VGBaseDataModel*)tmpValue[0]).value];
            } else {
                cell.text = [NSString stringWithFormat:@"%d", 0];
                VGBaseDataModel* tmpModel = [[VGBaseDataModel new] autorelease];
                tmpModel.row = self.user.rows[i];
                tmpModel.col = self.user.columns[j];
                tmpModel.value = [NSString stringWithFormat:@"%d", 0];
                tmpModel.dataId = [NSString stringWithFormat:@"tmp%d", ++[VGAppDelegate getInstance].tmpGlobalId];
                [self.user.dataSet addObject:tmpModel];
            }
            [self addSubview:cell];
            offsetX += 2;
        }
        offsetY += 2;
    }
    self.contentSize = CGSizeMake(cellWidth + cellWidth * self.user.columns.count + offsetX , cellHeight * self.user.rows.count + offsetY + cellHeight);
}

- (void)drawRect:(CGRect)rect
{
    [self reloadData];
}

- (void)dealloc
{
    colPlistName = nil;
    rowPlistName = nil;
    self.parentViewController = nil;
    detailViewController = nil;
    self.user = nil;
    tmpString = nil;
    btnAddCol = nil;
    btnAddRow = nil;
    self.popover = nil;
    [super dealloc];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger differece = (textField.frame.origin.y - viewFrameOffsetY > viewBoundY) ? textField.frame.origin.y - viewFrameOffsetY - viewBoundY : 0;
    tmpString = textField.text;
    NSInteger tmpvalue = keyHeight - (textField.frame.origin.y + textField.frame.size.height) + differece;
    if (tmpvalue < 0) {
        [self animateChangeOriginYView:self forValue: (tmpvalue - textField.frame.size.height)];
    }
    if (self.tableDetegate != nil) {
        [self.tableDetegate objectWillAdding];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSInteger differece = (textField.frame.origin.y - viewFrameOffsetY > viewBoundY) ? textField.frame.origin.y - viewFrameOffsetY - viewBoundY: 0;
    
    NSInteger tmpvalue = keyHeight - (textField.frame.origin.y + textField.frame.size.height) + differece;
    if (tmpvalue < 0) {
        [self animateChangeOriginYView:self forValue: -(tmpvalue - textField.frame.size.height)];
    }
    
    if ([textField.text floatValue] > 100) {
        textField.text = tmpString;
    } else if ([textField.text floatValue] >= 0) {
        textField.text = [NSString stringWithFormat:@"%d", [textField.text integerValue]];
    }
    
    if (self.tableDetegate != nil) {
        NSInteger rowIndex = textField.tag / self.user.columns.count;
        NSInteger colIndex = textField.tag % self.user.columns.count;
        [self.tableDetegate cellDidChangedAtRow:self.user.rows[rowIndex] andColIndex:self.user.columns[colIndex] withValue:textField.text andWithOldValue: tmpString];
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
    btnAddRow.enabled = canEdit;
}

#pragma mark - Actions

- (void) clickRowHeader:(UIButton*)sender {
    [self detailWithPushingForExistingRow:self.user.rows[sender.tag - 2000]];
}

- (void) detailWithPushingForExistingRow:(VGObject*) object {
    NSMutableArray* fields = [self fieldsFromPlistNameWithName:rowPlistName];
    detailViewController = [[[VGDetailViewController alloc] initForChooseExistObject] autorelease];
    detailViewController.object = object;
    detailViewController.fields = fields;
    [self.parentViewController.navigationController pushViewController:detailViewController animated:YES];
}

- (void) clickColumnHeader:(UIButton*)sender {
    [self detailWithPushingForExistCol:self.user.columns[sender.tag - 1000]];
}

- (void) detailWithPushingForExistCol:(VGObject*) object {
    NSMutableArray* fields = [self fieldsFromPlistNameWithName:colPlistName];
    detailViewController = [[[VGDetailViewController alloc] initForChooseExistObject] autorelease];
    detailViewController.object = object;
    detailViewController.fields = fields;
    [self.parentViewController.navigationController pushViewController:detailViewController animated:YES];
}

- (NSMutableArray*) fieldsFromPlistNameWithName:(NSString*) name {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSMutableDictionary* contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary* iconDictionary = [contentDictionary objectForKey:@"Icons"];
    [VGAppDelegate getInstance].iconName = [iconDictionary objectForKey:name];
    return [contentDictionary objectForKey:@"Fields"];
}

- (void) addToTableMethod:(VGObject*)object {
    if (buttonClickedType == VGButtonClickedTypeRow) {
        [self.user.rows addObject:object];
        if (self.tableDetegate != nil) {
            [self.tableDetegate rowDidAddWithName:object];
        }
    } else {
        [self.user.columns addObject:object];
        if (self.tableDetegate != nil) {
            [self.tableDetegate colDidAddWithName:object];
        }
    }
    [self reloadData];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void) presentExistingObject:(VGObject*)object {
    [self.popover dismissPopoverAnimated:YES];
    if (buttonClickedType == VGButtonClickedTypeRow) {
        [self detailWithPushingForExistingRow:object];
    } else {
        [self detailWithPushingForExistCol:object];
    }
}

- (void) clickAddRow {
    if (self.tableDetegate != nil) {
        [self.tableDetegate cellWillChanging];
    }
    
    buttonClickedType = VGButtonClickedTypeRow;
    insideViewController = [[[VGAddToTableViewController alloc] initWithExistArray:self.user.rows andFlag:YES] autorelease];
    insideViewController.method = @selector(presentExistingObject:);
    insideViewController.target = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:insideViewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(320, 480)];
    [self.popover presentPopoverFromRect: CGRectMake(25, 55, 1, 1)
                             inView: self
           permittedArrowDirections: UIPopoverArrowDirectionUp
                                animated: YES];
}

- (void) clickAddCol {
    if (self.tableDetegate != nil) {
        [self.tableDetegate cellWillChanging];
    }
    
    buttonClickedType = VGButtonClickedTypeCol;
    insideViewController = [[[VGAddToTableViewController alloc] initWithExistArray:self.user.columns andFlag:NO] autorelease];
    insideViewController.method = @selector(presentExistingObject:);
    insideViewController.target = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:insideViewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(320, 480)];
    [self.popover presentPopoverFromRect: CGRectMake(90, 15, 1, 1)
                                  inView: self
                permittedArrowDirections: UIPopoverArrowDirectionLeft
                                animated: YES];
}

#pragma mark - AddToTableViewController

- (void) createNewObjectWithFlag:(BOOL) isRow {
    [self.popover dismissPopoverAnimated:YES];
    detailViewController = [[[VGDetailViewController alloc] initForAddNewObject] autorelease];
    NSMutableArray* fields = [self fieldsFromPlistNameWithName:(isRow) ? rowPlistName : colPlistName];
    detailViewController.fields = fields;
    [self.parentViewController.navigationController pushViewController:detailViewController animated:YES];
}

@end