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
#import "VGScreenNavigator.h"
#import "VGSearchViewController.h"
#import "VGEditObjectRequest.h"
#import "VGRequestQueue.h"
#import "VGSubject.h"
#import "VGSkill.h"
#import "VGJob.h"
#import "VGAddNewObjectRequest.h"

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
        self.initMethod = ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] isKindOfClass:[VGSearchViewController class]]) ? @selector(initForCurrentUserState) : @selector(initForChooseState);
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
    self.btnAdd.hidden = NO;
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
    
    if ([VGAlertView isShowing]) {
        [VGAlertView hidePleaseWaitState];
    }
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
    self.tableViewController = [[[VGTableViewController alloc] initWithUser:(id<VGPerson>)self.object andEditMode:(self.initMethod == @selector(intitForEditState))] autorelease];
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
    if ([self.navigationController viewControllers][[self.navigationController viewControllers].count - 2] && [VGAppDelegate getInstance].currentStudent != nil) {
        //[VGScreenNavigator fillSearchScreenWithCredentialType:((id<VGPerson>)self.object).credential forKey: (((id<VGPerson>)self.object).credential == VGCredentilasTypeStudent) ? kStudentList : (((id<VGPerson>)self.object).credential == VGCredentilasTypeExpert) ? kExpertList: kEmployerList];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickAdd:(id)sender {
    if ([self.btnAdd.titleLabel.text isEqualToString:kAdd]) {
        if ([self.fieldsViewController saveDataToObject]) {
            VGTableViewController* parentViewController = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2];
            if ([parentViewController.tableView respondsToSelector:@selector(addToTableMethod:)]) {
                
                [parentViewController.tableView performSelector:@selector(addToTableMethod:) withObject:self.fieldsViewController.object];
                [self.navigationController popViewControllerAnimated:YES];
                /*
                 VGAddNewObjectRequest* request = nil;
                 
                 if (self.object != nil) {
                 if ([self.object isKindOfClass:[VGStudent class]]) {
                 request = [[[VGAddNewObjectRequest alloc] initWithExistSubjectToSecretarData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else if ([self.object isKindOfClass:[VGSubject class]]) {
                 request = ([VGAppDelegate getInstance].currentUser.credential == VGCredentilasTypeSecretar) ?
                 [[[VGAddNewObjectRequest alloc] initWithExistSubjectToSecretarData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease] : [[[VGAddNewObjectRequest alloc] initWithExistSubjectToExpertData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else if ([self.object isKindOfClass:[VGSkill class]]) {
                 request = ([VGAppDelegate getInstance].currentUser.credential == VGCredentilasTypeExpert) ?
                 [[[VGAddNewObjectRequest alloc] initWithExistSkillToExpertData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease] : [[[VGAddNewObjectRequest alloc] initWithExistSkillToEmployerData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else if ([self.object isKindOfClass:[VGJob class]]) {
                 request = [[[VGAddNewObjectRequest alloc] initWithExistVacancyToEmployerData:self.object.objectId andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else {
                 [VGAlertView showError:[NSString stringWithFormat: @"(VGDetailViewController) Error: wrong type of object : %@", [self.object class]]];
                 NSLog(@"(VGDetailViewController) Error: wrong type of object : %@", [self.object class]);
                 }
                 } else {
                 if ([self.object isKindOfClass:[VGStudent class]]) {
                 request = [[[VGAddNewObjectRequest alloc] initWithNewStudentToSecretarData:((VGStudent*)self.fieldsViewController.object).objectId
                 firstName:((VGStudent*)self.fieldsViewController.object).firstName secondName:((VGStudent*)self.fieldsViewController.object).secondName side:((VGStudent*)self.fieldsViewController.object).side.objectId age:((VGStudent*)self.fieldsViewController.object).age andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else if ([self.object isKindOfClass:[VGSubject class]]) {
                 request = ([VGAppDelegate getInstance].currentUser.credential == VGCredentilasTypeSecretar) ?
                 [[VGAddNewObjectRequest alloc] initWithNewSubjectToSecretarData:self.object.name description:self.object.description andPersonId:[VGAppDelegate getInstance].currentUser.objectId] :
                 [[VGAddNewObjectRequest alloc] initWithNewSubjectToExpertData:self.object.name description:self.object.description andPersonId:[VGAppDelegate getInstance].currentUser.objectId];
                 } else if ([self.object isKindOfClass:[VGSkill class]]) {
                 request = ([VGAppDelegate getInstance].currentUser.credential == VGCredentilasTypeExpert) ?
                 [[[VGAddNewObjectRequest alloc] initWithNewSkillToExpertData:self.object.name description:self.object.description andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease] :
                 [[[VGAddNewObjectRequest alloc] initWithNewSkillToEmployerData:self.object.name description:self.object.description andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else if ([self.object isKindOfClass:[VGJob class]]) {
                 request = [[[VGAddNewObjectRequest alloc] initWithNewSkillToExpertData:self.object.name description:self.object.description andPersonId:[VGAppDelegate getInstance].currentUser.objectId] autorelease];
                 } else {
                 [VGAlertView showError:[NSString stringWithFormat: @"(VGDetailViewController) Error: wrong type of object : %@", [self.object class]]];
                 NSLog(@"(VGDetailViewController) Error: wrong type of object : %@", [self.object class]);
                 }
                 }
                 
                 [[VGRequestQueue queue] addRequest: request];
                 */
            } else {
                [VGAlertView showError:@"Error: parentViewController can't respond selector(addToTableMethod:)"];
                NSLog(@"Error: parentViewController can't respond selector(addToTableMethod:)");
            }
        } else {
            [VGAlertView showError:@"(VGDetailViewContoller) Error: object is nill"];
            NSLog(@"(VGDetailViewContoller) Error: object is nill");
        }
    } else if ([self.btnAdd.titleLabel.text isEqualToString:kChoose]) {
        if ([self.object isKindOfClass:[VGUser class]]) {
            if (((VGUser*)self.object).credential == VGCredentilasTypeExpert) {
                [VGAppDelegate getInstance].currentExpert = (VGUser*)self.object;
                //[VGScreenNavigator fillDetailsScreenWitCredentialType:VGCredentilasTypeExpert withObject:[VGAppDelegate getInstance].currentExpert forKey:kExpertList];
            } else if (((VGUser*)self.object).credential == VGCredentilasTypeEmployer) {
                [VGAppDelegate getInstance].currentEmployer = (VGUser*)self.object;
                //[VGScreenNavigator fillDetailsScreenWitCredentialType:VGCredentilasTypeEmployer withObject:[VGAppDelegate getInstance].currentEmployer forKey:kEmployerList];
            } else {
                [VGAlertView showError:[NSString stringWithFormat:@"VGDetailViewContoller) Error: incorect credential type of object : %u", ((VGUser*)self.object).credential]];
                NSLog(@"VGDetailViewContoller) Error: incorect credential type of object : %u", ((VGUser*)self.object).credential);
            }
        } else if ([self.object isKindOfClass:[VGStudent class]]) {
            [VGAppDelegate getInstance].currentStudent = (VGStudent*)self.object;
            //[VGScreenNavigator fillDetailsScreenWitCredentialType:VGCredentilasTypeStudent withObject:[VGAppDelegate getInstance].currentStudent forKey:kStudentList];
        } else {
            [VGAlertView showError:[NSString stringWithFormat:@"VGDetailViewContoller) Error: incorect type of object : %@", [self.object class]]];
            NSLog(@"VGDetailViewContoller) Error: incorect type of object : %@", [self.object class]);
        }
        [self initNavigationBar];
        [[VGAppDelegate getInstance] checkoutSession];
    } else if ([self.btnAdd.titleLabel.text isEqualToString:kSaveChanges]) {
        if ([self.fieldsViewController saveDataToObject]) {
            VGTableViewController* parentViewController = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2];
            if ([parentViewController.tableView respondsToSelector:@selector(editObjectInTableMethod:)]) {
                [parentViewController.tableView performSelector:@selector(editObjectInTableMethod:) withObject:self.fieldsViewController.object];
                [self.navigationController popViewControllerAnimated:YES];
                /*
                 VGEditObjectRequest* request = nil;
                 
                 request = ([self.fieldsViewController.object isKindOfClass:[VGStudent class]]) ?
                 [[[VGEditObjectRequest alloc] initWithStudent:((VGStudent*)self.fieldsViewController.object).objectId
                 studentFirstName:((VGStudent*)self.fieldsViewController.object).firstName
                 studentSecondName:((VGStudent*)self.fieldsViewController.object).secondName
                 studentSideId:((VGStudent*)self.fieldsViewController.object).side.objectId
                 studentAge:((VGStudent*)self.fieldsViewController.object).age] autorelease] :
                 [[VGEditObjectRequest alloc] initWithTableObjectId:self.fieldsViewController.object.objectId
                 objectName:self.fieldsViewController.object.name
                 objectDescription:self.fieldsViewController.object.description
                 objectType:[self.fieldsViewController.object class]];
                 
                 
                 [[VGRequestQueue queue] addRequest:request];
                 */
            } else {
                [VGAlertView showError:@"(VGDetailViewContoller) Error: parentViewController can't respond selector(editObjectInTableMethod:)"];
                NSLog(@"(VGDetailViewContoller) Error: parentViewController can't respond selector(editObjectInTableMethod:)");
            }
        } else {
            [VGAlertView showError:@"(VGDetailViewContoller) Error: object is nill"];
            NSLog(@"(VGDetailViewContoller) Error: object is nill");
        }
    } else {
        [VGAlertView showError:[NSString stringWithFormat:@"VGDetailViewContoller) Error: wrong button name : '%@' (should be 'Add' or 'Choose' or '')", self.btnAdd.titleLabel.text]];
        NSLog(@"VGDetailViewContoller) Error: wrong button name : '%@' (should be 'Add' or 'Choose' or '')", self.btnAdd.titleLabel.text);
    }
}

#pragma mark - Request delegate

- (void)requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    //((VGTableViewController*)self.parentViewController).user = [VGUtilities userFromJsonData:jsonData];
    [VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:jsonData];
    [self.navigationController popViewControllerAnimated:YES];
    // TODO
    
    [self reloadInputViews];
}
@end