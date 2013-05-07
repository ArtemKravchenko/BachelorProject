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
#import "VGUtilities.h"

static NSString* const kFirstNameLabel = @"lblFirstName";
static NSString* const kSecondNameLabel = @"lblSecondName";
static NSString* const kSideLabel = @"lblSide";
static NSString* const kAgeLabel = @"lblAge";
static NSString* const kCardNumberLabel = @"lblCardNumber";

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
    self.objecectDetailController = [[VGDetailViewController alloc] initWithChooseState:self.objectsType];
    self.objecectDetailController.object = self.objectsList[indexPath.row];
    self.objecectDetailController.fields = ([self.objectsType isSubclassOfClass:[VGStudent class]]) ?
            [VGUtilities fieldsForCredentialType:VGCredentilasTypeStudent][kFields]: ([self.navigationItem.title isEqualToString:kExpertList]) ?
            [VGUtilities fieldsForCredentialType:VGCredentilasTypeExpert][kFields]:
            [VGUtilities fieldsForCredentialType:VGCredentilasTypeEmployer][kFields];
    [self.navigationController pushViewController:self.objecectDetailController animated:YES];
}

#pragma mark Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objectsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    id<VGPerson> currentPerson = self.objectsList[indexPath.row];
    
    if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Students_Cell"];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Persons_Cell"];
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
    
    [((UILabel*)[cell performSelector:NSSelectorFromString(kFirstNameLabel)]) setText:[currentPerson firstName]];
    [((UILabel*)[cell performSelector:NSSelectorFromString(kSecondNameLabel)]) setText:[currentPerson secondName]];
    [((UILabel*)[cell performSelector:NSSelectorFromString(kSideLabel)]) setText:[currentPerson side].name];
    
    return cell;
}

#pragma mark - Actions

- (IBAction)clickViewAll:(id)sender {
    if ([self.objectsType isSubclassOfClass:[VGStudent class]]) {
        self.objectsList = [NSMutableArray arrayWithArray:[VGAppDelegate getInstance].allStudents];
    } else {
        NSPredicate* predicate = nil;
        NSMutableArray* tmpPersons = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"persons"]];
        NSLog(@"%@", self.navigationItem.title);
        if ([self.navigationItem.title isEqualToString:kExpertList]) {
            predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"credential", 2];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"credential", 4];
        }
        //predicate = ([self.navigationItem.title isEqualToString:kExpertList]) ? [NSPredicate predicateWithFormat:@"%K == %@", @"credential", 2]: [NSPredicate predicateWithFormat:@"%K == %@", @"credential", 4];
        [tmpPersons filterUsingPredicate:predicate];
        self.objectsList = tmpPersons;
    }
    [self.tableView reloadData];
}

@end
