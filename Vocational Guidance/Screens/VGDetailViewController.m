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

@interface VGDetailViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *imgIcon;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;
@property (retain, nonatomic) VGFieldsListViewController* fieldsViewController;
@property (retain, nonatomic) VGTableViewController* tableViewController;
@property (retain, nonatomic) Class classValue;

@end

@implementation VGDetailViewController

#pragma mark - Init Functions

- (id) initForAddNewObject:(Class)classValue {
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(initForNewObject);
        self.classValue = classValue;
    }
    return self;
}

- (id) initForChooseExistObject {
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.initMethod = @selector(initForChooseObject);
    }
    return self;
}

- (id)init{
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
    }
    return self;
}

- (void) initForChooseObject {
    self.btnViewTable.hidden = YES;
    
    self.btnAdd.hidden = NO;
    [self.btnAdd setTitle:@"Choose" forState:UIControlStateNormal];
    self.btnBack.hidden = NO;
    self.btnEdit.hidden = NO;
}

- (void) initForNewObject {
    self.btnViewTable.hidden = YES;
    
    self.btnAdd.hidden = NO;
    self.btnBack.hidden = NO;
    [self.btnBack setTitle:@"Cancel" forState:UIControlStateNormal];
    self.btnEdit.hidden = NO;
}

#pragma mark - View's cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // init self view
    
    if (self.initMethod != nil) {
        [self performSelector:self.initMethod];
    }
    
    self.imgIcon.image = [UIImage imageNamed:[VGAppDelegate getInstance].iconName];
    // init fields view controller
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

- (void)dealloc {
    self.tableViewController = nil;
    [_fields release];
    [_fieldsViewController release];
    [_object release];
    [_imgIcon release];
    [_fieldsView release];
    [_btnViewTable release];
    [_btnEdit release];
    [_btnBack release];
    [_btnAdd release];
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)clickViewTable:(id)sender {
    self.tableViewController = [[[VGTableViewController alloc] initWithUser:(VGUser*)self.object] autorelease];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

- (IBAction)clickEdit:(id)sender {
    if ([((UIButton*)sender).titleLabel.text isEqualToString:@"Edit"]) {
        for (UIView* view in self.fieldsViewController.fieldsView.subviews) {
            for (UITextField* textField in view.subviews) {
                if ([textField isKindOfClass:[UITextField class]]) {
                    textField.enabled = YES;
                    textField.backgroundColor = [UIColor whiteColor];
                }
            }
        }
        [((UIButton*)sender) setTitle:@"Save" forState:UIControlStateNormal];
    } else {
        for (UIView* view in self.fieldsViewController.fieldsView.subviews) {
            for (UITextField* textField in view.subviews) {
                if ([textField isKindOfClass:[UITextField class]]) {
                    textField.enabled = NO;
                    textField.backgroundColor = [UIColor yellowColor];
                }
            }
        }
        [((UIButton*)sender) setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickAdd:(id)sender {
    [self.fieldsViewController saveDataToObject];
    if (self.fieldsViewController.object != nil) {
        self.object = self.fieldsViewController.object;
        VGTableViewController* parentViewController = [self.navigationController viewControllers][[self.navigationController viewControllers].count - 2];
        if ([parentViewController.tableView respondsToSelector:@selector(addToTableMethod:)]) {
            [parentViewController.tableView performSelector:@selector(addToTableMethod:) withObject:self.object];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error: parentViewController can't respond selector(addToTableMethod:)");
        }
    } else {
        NSLog(@"Error: object is nill");
    }
}
@end