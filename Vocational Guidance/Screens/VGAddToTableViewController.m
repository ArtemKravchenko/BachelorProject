//
//  VGAddToTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 27.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAddToTableViewController.h"
#import "VGAppDelegate.h"
#import "VGDetailViewController.h"
#import "VGTableView.h"

static NSString * CellIdentifier = @"AddToTableCell";

@interface VGAddToTableViewController ()

@property (nonatomic, assign) BOOL isRow;
@property (nonatomic, retain) NSMutableArray* tableData;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VGAddToTableViewController

- (id)initWithExistArray:(NSMutableArray*) existArray andFlag:(BOOL)isRow
{
    self = [super initWithNibName:@"VGAddToTableViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.isRow = isRow;
        self.tableData = [NSMutableArray array];
        for (VGObject* globalObject in (isRow) ? [VGAppDelegate getInstance].allRows : [VGAppDelegate getInstance].allColumns) {
            BOOL isObjectExist = NO;
            for (VGObject* localObject in existArray) {
                if ([localObject.object_id isEqualToString:globalObject.object_id]) {
                    isObjectExist = YES;
                    break;
                } 
            }
            if (!isObjectExist) {
                [self.tableData addObject:globalObject];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
    }
    
    NSString *text = ((VGObject*)[self.tableData objectAtIndex:indexPath.row]).name;
    
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.target performSelector:self.method withObject: self.tableData[indexPath.row]];
}

#pragma mark - Actions

- (IBAction)clickAdd:(id)sender {
    if ([self.target  respondsToSelector:@selector(createNewObjectWithFlag:)]) {
        [self.target performSelector:@selector(createNewObjectWithFlag:) withObject:[NSNumber numberWithBool:self.isRow]];
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end