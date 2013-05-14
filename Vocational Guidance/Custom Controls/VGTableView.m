//
//  VGTableView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableView.h"
#import "VGBaseDataModel.h"
#import "VGUtilities.h"

static const NSInteger cellWidth        = 95;
static const NSInteger cellHeight       = 59;
static const NSInteger keyHeight        = 352;
static const NSInteger viewFrameOffsetY = 61;
static const NSInteger viewBoundY       = 488;
static NSString* const kJob             = @"Job";

@interface VGTableView ()

@property (nonatomic, retain) VGAddToTableViewController *insideViewController;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, assign) VGButtonClickedType buttonClickedType;
@property (nonatomic, retain) UIButton *btnAddRow;
@property (nonatomic, retain) UIButton *btnAddCol;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, retain) NSString *temporaryString;
@property (nonatomic, retain) VGDetailViewController* detailViewController;
@property (nonatomic, retain) NSString* rowPlistName;
@property (nonatomic, retain) NSString* colPlistName;

@end

@implementation VGTableView

- (void)dealloc
{
    self.insideViewController = nil;
    self.user = nil;
    self.tableDetegate = nil;
    self.parentViewController = nil;
    self.popover = nil;
    self.btnAddRow = nil;
    self.btnAddCol = nil;
    self.temporaryString = nil;
    self.detailViewController = nil;
    self.rowPlistName = nil;
    self.colPlistName = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame andUser:(VGUser*) user;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canEdit = NO;
        self.user = user;
        
        if (self.user != nil) {
            // init columns plist name
            switch (self.user.credential) {
                case VGCredentilasTypeEmployer:
                    self.colPlistName = kJob;
                    break;
                    
                case VGCredentilasTypeExpert:
                    self.colPlistName = kSubject;
                    break;
                    
                case VGCredentilasTypeSecretar:
                    self.colPlistName = kStudent;
                    break;
                    
                default:
                    break;
            }
            
            // init rows plist name
            switch (self.user.credential) {
                case VGCredentilasTypeEmployer:
                    self.rowPlistName = kSkill;
                    break;
                    
                case VGCredentilasTypeExpert:
                    self.rowPlistName = kSkill;
                    break;
                    
                case VGCredentilasTypeSecretar:
                    self.rowPlistName = kSubject;
                    break;
                    
                default:
                    break;
            }
        } else {
            self.rowPlistName = kJob;
            self.colPlistName = kStudent;
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

- (void) addObjectOnTableWithFrame:(CGRect) frame andTag:(NSInteger) tag andTitle:(NSString*) title andSelector:(SEL)method {
    UIButton* btnObjectHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    btnObjectHeader.frame = frame;
    btnObjectHeader.tag = tag;
    [btnObjectHeader setBackgroundColor:[UIColor yellowColor]];
    [btnObjectHeader setTintColor:[UIColor whiteColor]];
    [btnObjectHeader.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnObjectHeader setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnObjectHeader setTitle: title forState:UIControlStateNormal];
    [btnObjectHeader addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnObjectHeader];
}

- (UIButton*) buttonWithSelector:(SEL)selector andFrame:(CGRect)frame {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    [button setTitle:@"+" forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}

- (UITextField*) textFieldWithFrame:(CGRect)frame andTag:(NSInteger)tag {
    UITextField *cell = [[[UITextField alloc] initWithFrame: frame] autorelease];
    cell.backgroundColor = (self.canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
    cell.textAlignment = NSTextAlignmentCenter;
    cell.enabled = self.canEdit;
    cell.tag = tag;
    cell.delegate = self;
    cell.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return cell;
}

- (void) reloadData {
    [self removeAllFromView];
    
    self.backgroundColor = [UIColor whiteColor];
    NSInteger offsetX = 2;
    NSInteger offsetY = 2;
    
    if (self.btnAddRow == nil) {
        self.btnAddRow = [self buttonWithSelector:@selector(clickAddRow) andFrame: CGRectMake(1, cellHeight / 2 , cellWidth / 2, cellHeight / 2)];
        [self addSubview:self.btnAddRow];
    }
    
    if (self.btnAddCol == nil) {
        self.btnAddCol = [self buttonWithSelector:@selector(clickAddCol) andFrame:CGRectMake(cellWidth / 2 , 1 , cellWidth / 2, cellHeight / 2)];
        [self addSubview:self.btnAddCol];
    }
    
    // init columns headers
    for (int i  = 0; i < self.user.columns.count; i++) {
        // Init label
        [self addObjectOnTableWithFrame:CGRectMake(cellWidth + cellWidth * i + offsetX, 0, cellWidth, cellHeight) andTag:(1000 + i)
                               andTitle:[NSString stringWithFormat:@"%@", ((id<VGTableVariable>)self.user.columns[i]).name] andSelector:@selector(clickColumnHeader:)];
        offsetX += 2;
    }
    
    // init rows headers
    for (int i = 0; i < self.user.rows.count; i++) {
        [self addObjectOnTableWithFrame:CGRectMake(0, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight) andTag:(2000 + i)
                               andTitle:[NSString stringWithFormat:@"%@", ((id<VGTableVariable>)self.user.rows[i]).name] andSelector:@selector(clickRowHeader:)];
        
        offsetX = 2;
        // init cells
        for (NSInteger j = 0; j < self.user.columns.count; j++) {
            UITextField *cell = [self textFieldWithFrame:CGRectMake(cellWidth + cellWidth * j + offsetX, cellHeight * i + offsetY + cellHeight, cellWidth, cellHeight) andTag:i * self.user.columns.count + j];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ AND %K LIKE %@", @"row.objectId", ((id<VGTableVariable>)self.user.rows[i]).objectId, @"col.objectId", ((id<VGTableVariable>)self.user.columns[j]).objectId];
            NSMutableArray *tmpValue = [NSMutableArray arrayWithArray:self.user.dataSet];
            [tmpValue filterUsingPredicate:predicate];
            if (tmpValue.count) {
                cell.text = [NSString stringWithFormat:@"%@", ((VGBaseDataModel*)tmpValue[0]).value];
            } else {
                cell.text = [NSString stringWithFormat:@"%d", 0];
                VGBaseDataModel* tmpModel = [self baseModelWithZeroValueForRow:self.user.rows[i] andColumn:self.user.columns[j] andId:[NSString stringWithFormat:@"tmp%d", ++[VGAppDelegate getInstance].tmpGlobalId]];
                [self.user.dataSet addObject:tmpModel];
            }
            [self addSubview:cell];
            offsetX += 2;
        }
        offsetY += 2;
    }
    self.contentSize = CGSizeMake(cellWidth + cellWidth * self.user.columns.count + offsetX , cellHeight * self.user.rows.count + offsetY + cellHeight);
}

- (void) drawRect:(CGRect)rect
{
    [self reloadData];
}

- (VGBaseDataModel*) baseModelWithZeroValueForRow:(id<VGTableVariable>)row andColumn:(id<VGTableVariable>)column andId:(NSString*)dataId {
    VGBaseDataModel* model = [[VGBaseDataModel new] autorelease];
    model.row = row;
    model.col = column;
    model.value = [NSString stringWithFormat:@"%d", 0];
    model.dataId = dataId;
    return model;
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger differece = (textField.frame.origin.y - viewFrameOffsetY > viewBoundY) ? textField.frame.origin.y - viewFrameOffsetY - viewBoundY : 0;
    self.temporaryString = textField.text;
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
        textField.text = self.temporaryString;
    } else if ([textField.text floatValue] >= 0) {
        textField.text = [NSString stringWithFormat:@"%d", [textField.text integerValue]];
    }
    
    if (self.tableDetegate != nil) {
        NSInteger rowIndex = textField.tag / self.user.columns.count;
        NSInteger colIndex = textField.tag % self.user.columns.count;
        [self.tableDetegate cellDidChangedAtRow:self.user.rows[rowIndex] andColIndex:self.user.columns[colIndex] withValue:textField.text andWithOldValue: self.temporaryString];
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
    self.canEdit = value;
    for (UIView * textField in self.subviews) {
        if ([textField isKindOfClass: [UITextField class]]) {
            ((UITextField*)textField).enabled = self.canEdit;
            ((UITextField*)textField).backgroundColor = (self.canEdit) ? [UIColor whiteColor] : [UIColor grayColor];
        }
    }
    self.btnAddCol.enabled = self.canEdit;
    self.btnAddRow.enabled = self.canEdit;
}

#pragma mark - Actions

- (void) clickRowHeader:(UIButton*)sender {
    self.buttonClickedType = VGButtonClickedTypeRow;
    [self detailWithPushingForExistObject:self.user.rows[sender.tag - 2000]  andPlistName:self.rowPlistName];
}

- (void) clickColumnHeader:(UIButton*)sender {
    self.buttonClickedType = VGButtonClickedTypeCol;
    [self detailWithPushingForExistObject: self.user.columns[sender.tag - 1000] andPlistName: self.colPlistName];
}

- (void) detailWithPushingForExistObject:(id<VGTableVariable>) object andPlistName:(NSString*) name {
    NSMutableDictionary* allFields = [VGUtilities fieldsFromPlistNameWithName: name];
    self.detailViewController = ([self.parentViewController.navigationController.viewControllers[1] isKindOfClass:[VGDetailViewController class]]) ?
                                [[[VGDetailViewController alloc] initWithEditState:[object class]] autorelease] :
                                [[[VGDetailViewController alloc] initWithViewState:[object class]] autorelease];
    self.detailViewController.object = object;
    self.detailViewController.fields = allFields[kFields];
    self.detailViewController.imageName = allFields[kIcons][name];
    [self.parentViewController.navigationController pushViewController:self.detailViewController animated:YES];
}

- (void) addToTableMethod:(id<VGTableVariable>)object {
    if (self.buttonClickedType == VGButtonClickedTypeRow) {
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

- (void) editObjectInTableMethod:(id<VGTableVariable>)object {
    NSMutableArray* tmpArray = (self.buttonClickedType == VGButtonClickedTypeRow) ? self.user.rows: self.user.columns;
    for (id<VGTableVariable> variable in tmpArray) {
        if ([variable.objectId isEqualToString: object.objectId]) {
            variable = object;
            break;
        }
    }
}

- (void) presentExistingObject:(id<VGTableVariable>)object {
    [self.popover dismissPopoverAnimated:YES];
    if (self.buttonClickedType == VGButtonClickedTypeRow) {
        [self detailWithPushingForExistObject:object andPlistName:self.rowPlistName];
    } else {
        [self detailWithPushingForExistObject:object  andPlistName: self.colPlistName];
    }
}

- (void) clickAddRow {
    [self baseAddWithClickedType:VGButtonClickedTypeRow];
}

- (void) clickAddCol {
    [self baseAddWithClickedType:VGButtonClickedTypeCol];
}

- (void) baseAddWithClickedType:(VGButtonClickedType)clickedType {
    if (self.tableDetegate != nil) {
        [self.tableDetegate cellWillChanging];
    }
    
    NSMutableArray* globaleArray = nil;
    self.buttonClickedType = clickedType;
    
    switch (self.user.credential) {
        case VGCredentilasTypeSecretar:
            globaleArray = (self.buttonClickedType == VGButtonClickedTypeRow) ? [NSMutableArray arrayWithArray: [VGAppDelegate getInstance].allSubjects] : [NSMutableArray arrayWithArray: [VGAppDelegate getInstance].allStudents];
            break;
            
        case VGCredentilasTypeExpert:
            globaleArray = (self.buttonClickedType == VGButtonClickedTypeRow) ? [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allSkills] : [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allSubjects];
            break;
            
        case VGCredentilasTypeEmployer:
            globaleArray = (self.buttonClickedType == VGButtonClickedTypeRow) ? [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allVacancies] : [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allSkills];
            break;
            
        default:
            break;
    }
    
    self.insideViewController = [[[VGAddToTableViewController alloc] initWithExistArray:(self.buttonClickedType == VGButtonClickedTypeRow) ? self.user.rows : self.user.columns
                                                                                andFlag:(self.buttonClickedType == VGButtonClickedTypeRow) ? YES : NO andGlobalArray:globaleArray] autorelease];
    self.insideViewController.target = self;
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:self.insideViewController] autorelease];
    [self.popover setPopoverContentSize:CGSizeMake(320, 480)];
    [self.popover presentPopoverFromRect: (self.buttonClickedType == VGButtonClickedTypeRow) ? CGRectMake(25, 55, 1, 1) : CGRectMake(90, 15, 1, 1)
                                  inView: self
                permittedArrowDirections: UIPopoverArrowDirectionUp
                                animated: YES];
}

#pragma mark - AddToTableViewController

- (void) createNewObjectWithFlag:(NSNumber*) isRow {
    [self.popover dismissPopoverAnimated:YES];
    self.detailViewController = [[[VGDetailViewController alloc] initWithEditState:([isRow boolValue]) ? [self.user.rows[0] class] : [self.user.columns[0] class]] autorelease];
    NSMutableDictionary* allFields = [VGUtilities fieldsFromPlistNameWithName:([isRow boolValue]) ? self.rowPlistName : self.colPlistName];
    self.detailViewController.fields = allFields[kFields];
    self.detailViewController.imageName = allFields[kIcons][([isRow boolValue]) ? self.rowPlistName : self.colPlistName];
    [self.parentViewController.navigationController pushViewController:self.detailViewController animated:YES];
}

@end