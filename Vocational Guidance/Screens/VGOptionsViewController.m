//
//  VGOptionsViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGOptionsViewController.h"
#import "VGScreenNavigator.h"

@interface VGOptionsViewController ()

@end

static NSString * CellIdentifier = @"OptionCell";

@implementation VGOptionsViewController
- (id)init
{
    self = [super initWithNibName:@"VGOptionsViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

+ (UIPopoverController *) newPopoverWithTitle: (NSString *) title options: (NSArray *) options delegate: (VGMessageHandlerViewController *) delegate tag: (NSInteger) tag {
    VGOptionsViewController         * optionsController;
    UINavigationController          * navController;
    UIPopoverController             * popoverController;
    
	optionsController = [[VGOptionsViewController alloc] init];
	optionsController.title = @"Main Menu";
	optionsController.arrayOprions = options;
	optionsController.delegate = delegate;
	
	navController = [[UINavigationController alloc] initWithRootViewController:optionsController];
	navController.view.tag = tag;
	
	popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
	popoverController.popoverContentSize = CGSizeMake(optionsController.view.frame.size.width, ([options count] * 44) + 38);
	popoverController.delegate = optionsController;
	optionsController.popover = popoverController;
    
	[navController release];
	[optionsController release];
    
    return popoverController;
    
}

#pragma mark - View controller life's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    self.arrayOprions = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOprions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
    }
    
    NSString *text = [self.arrayOprions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *controllerName = [self.arrayOprions objectAtIndex:indexPath.row];
    [VGScreenNavigator navigateToScreen:controllerName];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

@end
