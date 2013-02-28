//
//  VGAddToTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAddToTableViewController.h"

@interface VGAddToTableViewController ()

@property (retain, nonatomic) IBOutlet UITextField *txtName;

@end

@implementation VGAddToTableViewController

- (id)init
{
    self = [super initWithNibName:@"VGAddToTableViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)clickAdd:(id)sender {
    if (![self.txtName.text isEqualToString:@""] && ![self.txtName.text isEqualToString:@"\n" ] && ![self.txtName.text isEqualToString:@"\t"] && self.target != nil && self.method != nil) {
        [self.target performSelector:self.method withObject:self.txtName.text];
    }
}

- (void)dealloc {
    [_txtName release];
    [super dealloc];
}
@end
