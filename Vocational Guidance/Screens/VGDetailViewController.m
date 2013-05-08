//
//  VGDetailViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGDetailViewController.h"
#import "VGFieldsListViewController.h"
#import "VGTableViewController.h"

static NSString* const kSave = @"Save";
static NSString* const kAdd = @"Add";
static NSString* const kChoose = @"Choose";
static NSString* const kSaveChanges = @"Save changes";

@interface VGDetailViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *imgIcon;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;
@property (retain, nonatomic) IBOutlet UIButton *btnViewTable;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
@property (retain, nonatomic) IBOutlet UIButton *btnAdd;

@property (retain, nonatomic) VGFieldsListViewController* fieldsViewController;
@property (retain, nonatomic) VGTableViewController* tableViewController;
@property (nonatomic, assign) SEL initMethod;

@end

@implementation VGDetailViewController

#pragma mark - Init Functions

- (id)init
{
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(initForCurrentUserState);
    }
    return self;
}

- (id) initWithChooseState:(Class) classValue {
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(initForChooseState);
        self.classValue = classValue;
    }
    return self;
}

- (id) initWithEditState:(Class)classValue {
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(intitForEditState);
        self.classValue = classValue;
    }
    return self;
}

- (id) initWithViewState:(Class)classValue {
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(initForViewState);
        self.classValue = classValue;
    }
    return self;
}

- (void) initForViewState {
    self.btnAdd.hidden = YES;
    self.btnEdit.hidden = YES;
    self.btnBack.hidden = NO;
}

- (void) intitForEditState {
    self.btnViewTable.hidden = YES;
    
    self.btnAdd.hidden = (self.object != nil);
    if (self.object != nil)  {
        [self.btnAdd setTitle:kSaveChanges forState:UIControlStateNormal];
    }
    self.btnBack.hidden = NO;
    self.btnEdit.hidden = NO;
}

- (void) initBase {
    self.btnViewTable.hidden = NO;
    self.btnEdit.hidden = YES;
    [self.btnAdd setTitle:kChoose forState:UIControlStateNormal];
}

- (void) initForCurrentUserState {
    [self initBase];
    self.btnBack.hidden = YES;
}

- (void) initForChooseState {
    [self initBase];
    self.btnBack.hidden = NO;
}

- (void) initFieldsListViewController {
    self.fieldsViewController = [[VGFieldsListViewController new] autorelease];
    self.fieldsViewController.fields = self.fields;
    if (self.object != nil) {
        self.fieldsViewController.object = self.object;
    } else {
        self.fieldsViewController.classValue = self.classValue;
    }
    self.fieldsViewController.cellWidth = self.fieldsView.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.fieldsView.frame.size.width, self.fieldsView.frame.size.height);
    [self.fieldsViewController initFieldsWithFrame:frame];
    [self.fieldsView addSubview:self.fieldsViewController.view];
}

#pragma mark - View's cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // init self view
    
    [self performSelector:self.initMethod];
    self.imgIcon.image = [UIImage imageNamed:self.imageName];
    [self initFieldsListViewController];
}

- (void)dealloc {
    self.fields = nil;
    self.object = nil;
    self.imgIcon = nil;
    self.fieldsView = nil;
    self.btnViewTable = nil;
    self.btnEdit = nil;
    self.btnBack = nil;
    self.btnAdd = nil;
    self.fieldsViewController = nil;
    self.tableViewController = nil;
    self.classValue = nil;
    self.imageName = nil;
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)clickViewTable:(id)sender {
    self.tableViewController = [[[VGTableViewController alloc] initWithUser:(VGUser*)self.object andEditMode:(self.initMethod == @selector(intitForEditState))] autorelease];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

- (void) setEditModeForFields:(BOOL)editMode {
    for (UIView* view in self.fieldsViewController.fieldsView.subviews) {
        for (UIView* field in view.subviews) {
            if ([field isKindOfClass:[UITextField class]]) {
                ((UITextField*)field).enabled = editMode;
            } else if ([field isKindOfClass:[UIButton class]]) {
                ((UIButton*)field).enabled = editMode;
            }
            field.backgroundColor = (editMode) ? [UIColor whiteColor] : [UIColor yellowColor];
        }
    }
    [self.btnEdit setTitle: (editMode) ? kSave : kEdit forState:UIControlStateNormal];
    self.btnAdd.hidden = editMode;
}

- (IBAction)clickEdit:(id)sender {
    [self setEditModeForFields:[((UIButton*)sender).titleLabel.text isEqualToString:kEdit]];
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickAdd:(id)sender {
    if ([self.btnAdd.titleLabel.text isEqualToString:kAdd]) {
        if ([self.fieldsViewController saveDataToObject]) {
            VGTableViewController* parentViewController = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2];
            if ([parentViewController.tableView respondsToSelector:@selector(addToTableMethod:)]) {
                [parentViewController.tableView performSelector:@selector(addToTableMethod:) withObject:self.fieldsViewController.object];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error: parentViewController can't respond selector(addToTableMethod:)");
            }
        } else {
            NSLog(@"(VGDetailViewContoller) Error: object is nill");
        }
    } else if ([self.btnAdd.titleLabel.text isEqualToString:kChoose]) {
        if ([self.object isKindOfClass:[VGUser class]]) {
            if (((VGUser*)self.object).credential == VGCredentilasTypeExpert) {
                [VGAppDelegate getInstance].currentExpert = (VGUser*)self.object;
            } else if (((VGUser*)self.object).credential == VGCredentilasTypeEmployer) {
                [VGAppDelegate getInstance].currentEmployer = (VGUser*)self.object; 
            } else {
                NSLog(@"VGDetailViewContoller) Error: incorect credential type of object : %u", ((VGUser*)self.object).credential);
            }
        } else if ([self.object isKindOfClass:[VGStudent class]]) {
            [VGAppDelegate getInstance].currentStudent = (VGStudent*)self.object;
        } else {
            NSLog(@"VGDetailViewContoller) Error: incorect type of object : %@", [self.object class]);
        }
        [[VGAppDelegate getInstance] checkoutSession];
    } else if ([self.btnAdd.titleLabel.text isEqualToString:kSaveChanges]) {
        if ([self.fieldsViewController saveDataToObject]) {
            VGTableViewController* parentViewController = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2];
            if ([parentViewController.tableView respondsToSelector:@selector(editObjectInTableMethod:)]) {
                [parentViewController.tableView performSelector:@selector(editObjectInTableMethod:) withObject:self.fieldsViewController.object];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error: parentViewController can't respond selector(editObjectInTableMethod:)");
            }
        } else {
            NSLog(@"(VGDetailViewContoller) Error: object is nill");
        }
    } else {
        NSLog(@"VGDetailViewContoller) Error: wrong button name : '%@' (should be 'Add' or 'Choose' or '')", self.btnAdd.titleLabel.text);
    }
}
@end