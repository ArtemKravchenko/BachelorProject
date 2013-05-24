//
//  VGSearchViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSearchViewController.h"
#import "VGFieldsListViewController.h"
#import "VGStudentsCell.h"
#import "VGPersonsCell.h"
#import "VGUser.h"
#import "VGDetailViewController.h"
#import "VGGetPersonRequest.h"
#import "VGSearchPersonsRequest.h"
#import "VGRequestQueue.h"

static NSString* const kFirstNameLabel = @"lblFirstName";
static NSString* const kSecondNameLabel = @"lblSecondName";
static NSString* const kSideLabel = @"lblSide";
static NSString* const kAgeLabel = @"lblAge";
static NSString* const kCardNumberLabel = @"lblCardNumber";
static NSString* const kStudentCellIdentifier = @"Students_Cell";
static NSString* const kPersonCellIdentifier = @"Persons_Cell";

@interface VGSearchViewController ()

@property (nonatomic, retain) VGDetailViewController* objecectDetailController;
@property (nonatomic, retain) VGFieldsListViewController* fieldsViewController;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;
@property (retain, nonatomic) IBOutlet UIView *headersView;
@property (retain, nonatomic) IBOutlet UIView *personsHeadersView;
@property (retain, nonatomic) IBOutlet UIView *studentsHeadersView;
@property (retain, nonatomic) IBOutlet VGStudentsCell *studentViewCell;
@property (retain, nonatomic) IBOutlet VGPersonsCell *personViewCell;
@property (retain, nonatomic) NSMutableArray* objectsList;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VGSearchViewController

- (id)init
{
    self = [super initWithNibName:@"VGSearchViewController" bundle:[NSBundle mainBundle]];
    if (self) {
    }
    return self;
}

- (void) cleanHeadersView {
    for (UIView* view in self.headersView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark View's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // init headres
    [self cleanHeadersView];
    if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
        [self.headersView addSubview: self.studentsHeadersView];
    } else if ([self.objectsType isSubclassOfClass:[VGUser class]]) {
        [self.headersView addSubview: self.personsHeadersView];
    } else {
        [VGAlertView showError:@"(SearchViewConrtroller) Error: Wrong object type"];
        NSLog(@"(SearchViewConrtroller) Error: Wrong object type");
    }
    // init fields view controller
    self.fieldsViewController = [[VGFieldsListViewController new] autorelease];
    self.fieldsViewController.fields = self.fieldsList;
    self.fieldsViewController.editMode = YES;
    self.fieldsViewController.cellWidth = self.fieldsView.frame.size.width;
    self.fieldsViewController.emptyFields = self.emptyFields;
    CGRect frame = CGRectMake(0, 0, self.fieldsView.frame.size.width, self.fieldsView.frame.size.height);
    [self.fieldsViewController initFieldsWithFrame:frame];
    [self.fieldsView addSubview:self.fieldsViewController.view];
}

- (void)dealloc
{
    self.fieldsViewController = nil;
    self.fieldsList = nil;
    self.fieldsView = nil;
    self.emptyFields = nil;
    self.headersView = nil;
    self.personsHeadersView = nil;
    self.studentsHeadersView = nil;
    self.objectsType = nil;
    self.studentViewCell = nil;
    self.objectsList = nil;
    self.tableView = nil;
    self.personViewCell = nil;
    self.objecectDetailController = nil;
    [super dealloc];
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    [self mockViewDetails:indexPath];
    */
    NSMutableDictionary* allFields = [VGUtilities fieldsForCredentialType:((id<VGPerson>)self.objectsList[indexPath.row]).credential];
    self.objecectDetailController = [[[VGDetailViewController alloc] initWithChooseState:self.objectsType] autorelease];
    self.objecectDetailController.fields = allFields[kFields];
    self.objecectDetailController.imageName = [allFields[kIcons] objectForKey: ([self.objectsList[indexPath.row] isKindOfClass:[VGUser class]]) ? ((VGUser*)self.objectsList[indexPath.row]).credentialToString : kStudent];
    
    NSString* personId = ((id<VGPerson>)self.objectsList[indexPath.row]).objectId;
    
    [VGAlertView showPleaseWaitState];
    VGGetPersonRequest* request = (self.objectsType == [VGStudent class]) ? [[[VGGetPersonRequest alloc] initWithStudentId: personId] autorelease]: [[[VGGetPersonRequest alloc] initWithPersonId: personId] autorelease];
    request.delegate = self;
    [[VGRequestQueue queue] addRequest:request];
}

#pragma mark Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objectsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    id<VGPerson> currentPerson = self.objectsList[indexPath.row];
    
    if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kStudentCellIdentifier];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kPersonCellIdentifier];
    }
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"VGSearchCell" owner:self options:nil];
        if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
            cell = self.studentViewCell;
            self.studentViewCell = nil;
            [((UILabel*)[cell performSelector:NSSelectorFromString(kAgeLabel)]) setText:[currentPerson age]];
            [((UILabel*)[cell performSelector:NSSelectorFromString(kCardNumberLabel)]) setText:[currentPerson objectId]];
        } else {
            cell = self.personViewCell;
            self.personViewCell = nil;
        }
    }
    if (indexPath.row == self.objectsList.count - 1) {
        [self performSelectorOnMainThread:@selector(hidePleaseWaitAlert) withObject:self waitUntilDone:NO];
    }
    
    [((UILabel*)[cell performSelector:NSSelectorFromString(kFirstNameLabel)]) setText:[currentPerson firstName]];
    [((UILabel*)[cell performSelector:NSSelectorFromString(kSecondNameLabel)]) setText:[currentPerson secondName]];
    [((UILabel*)[cell performSelector:NSSelectorFromString(kSideLabel)]) setText:[currentPerson side].name];
    
    return cell;
}

#pragma mark - Actions

- (IBAction)clickSearch:(id)sender {
    if ([self isLessOneFieldNoEmpty]) {
        NSDictionary* fields = [self.fieldsViewController fieldsForSearch];
        VGSearchPersonsRequest* request = nil;
        request = ([self.objectsType isSubclassOfClass:[VGUser class]]) ? [[[VGSearchPersonsRequest alloc] initWithFirstName:fields[@"firstName"] secondName:fields[@"secondName"] sideId:fields[@"side.objectId"] andCredentialType:([[VGAppDelegate getInstance].currentScreen isEqualToString:kExpertList]) ? VGCredentilasTypeExpert : VGCredentilasTypeEmployer] autorelease] :
        [[[VGSearchPersonsRequest alloc] initWithFirstName:fields[@"firstName"] secondName:fields[@"secondName"] sideId:fields[@"side.objectId"] cardNumber:fields[@"cardNumber"] age:fields[@"age"]] autorelease];
        [[VGRequestQueue queue] addRequest:request];
    }
}

- (BOOL) isLessOneFieldNoEmpty {
    if ([self.fieldsViewController fieldsForSearch].count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)clickViewAll:(id)sender {
    /*
    [self mockViewAll];
    */
    [VGAlertView showPleaseWaitState];
    VGSearchPersonsRequest* request = ([self.objectsType isSubclassOfClass:[VGStudent class]]) ? [[[VGSearchPersonsRequest alloc] initWithAllStudents] autorelease] :
    ([[VGAppDelegate getInstance].currentScreen isEqualToString:kExpertList]) ? [[[VGSearchPersonsRequest alloc] initWithAllExperts] autorelease] :
    [[[VGSearchPersonsRequest alloc] initWithAllEmployers] autorelease];
    request.delegate = self;
    [[VGRequestQueue queue] addRequest:request];
     
}

#pragma mark - Mock functions

-(void) mockViewDetails:(NSIndexPath*)indexPath {
    NSMutableDictionary* allFields = [VGUtilities fieldsForCredentialType:((id<VGPerson>)self.objectsList[indexPath.row]).credential];
    self.objecectDetailController = [[[VGDetailViewController alloc] initWithChooseState:self.objectsType] autorelease];
    self.objecectDetailController.object = self.objectsList[indexPath.row];
    self.objecectDetailController.fields = allFields[kFields];
    self.objecectDetailController.imageName = [allFields[kIcons] objectForKey: ([self.objectsList[indexPath.row] isKindOfClass:[VGUser class]]) ? ((VGUser*)self.objectsList[indexPath.row]).credentialToString : kStudent];
    
    [self.navigationController pushViewController:self.objecectDetailController animated:YES];
}

-(void) mockViewAll {
    if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
        self.objectsList = [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allStudents];
    } else {
        NSPredicate* predicate = nil;
        NSMutableArray* tmpPersons = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:kPersons]];
        if ([[VGAppDelegate getInstance].currentScreen isEqualToString:kExpertList]) {
            predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"credential", 2];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"credential", 4];
        }
        [tmpPersons filterUsingPredicate:predicate];
        self.objectsList = tmpPersons;
    }
    [self.tableView reloadData];
}

- (void) hidePleaseWaitAlert {
    [VGAlertView hidePleaseWaitState];
}

#pragma mark - Request delegate

- (void)requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([jsonData isKindOfClass:[NSArray class]]) {
        self.objectsList = [NSMutableArray array];
        
        if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
            for (NSDictionary* jsonInfo in jsonData) {
                [self.objectsList addObject:[VGUtilities tableVariableFromJsonData:jsonInfo withClassType: [VGStudent class]]];
            }
        } else {
            for (NSDictionary * jsonInfo in jsonData) {
                [self.objectsList addObject:[VGUtilities userFromJsonData: jsonInfo]];
            }
        }
        [self.tableView reloadData];
    } else {
        // Filling user for detail
        if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
            self.objecectDetailController.object = [VGUtilities tableVariableFromJsonData:jsonData withClassType:[VGStudent class]];
        } else {
            self.objecectDetailController.object = [VGUtilities userFromJsonData:jsonData];
        }
        [self.navigationController pushViewController:self.objecectDetailController animated:YES];
    }
}

@end
