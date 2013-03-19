//
//  VGGraphViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 28.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGraphViewController.h"
#import "VGBaseDataModel.h"

static const NSInteger graphItemWidth   = 89;
static const NSInteger graphItemHeight  = 89;
static const NSInteger deltaX           = 200;
static const NSInteger startOffset      = 20;

static NSString * CellIdentifier = @"GraphCell";

@class VGTableType;

@interface VGGraphViewController ()

@property (retain, nonatomic) IBOutlet VGGraphDesktop *graphDesktop;

@end

@implementation VGGraphViewController

- (id) initWIthUser:(VGUser*)user
{
    self = [super initWithNibName:@"VGGraphViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.tableData = [NSMutableArray array];
        self.user = user;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) dealloc {
    self.tableData = nil;
    self.user = nil;
    [_graphDesktop release];
    [_tableView release];
    [super dealloc];
}

- (void) reloadDataWithArray:(NSMutableArray*)array {
    // Reload table
    self.tableData = [NSMutableArray arrayWithArray: array]; // self.user.values
    [self.tableView reloadData];
    
    // Reload desktop
    for (UIView* view in self.graphDesktop.subviews) {
        [view removeFromSuperview];
    }
    self.graphDesktop.user = self.user;
    self.graphDesktop.tableValues = [NSMutableArray arrayWithArray:array];
    [self.graphDesktop reloadItems];
}

#pragma mark Table data souce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
    }
    
    VGBaseDataModel* tmpCell = (VGBaseDataModel*)self.tableData[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ , %@: %@",
                      tmpCell.row.name,
                      tmpCell.col.name,
                      tmpCell.value];
    
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Search field delegate

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![[searchBar.text stringByReplacingCharactersInRange:range withString:text] isEqualToString:@""]) {
        NSPredicate* predicate = nil;
        // Prepeare tmpArray
        NSMutableArray* tmpArray = [[VGAppDelegate getInstance] stringValuesFromDataArray:self.user.dataSet];
        predicate = [NSPredicate predicateWithFormat:@" %K CONTAINS %@", @"value" ,[searchBar.text stringByReplacingCharactersInRange:range withString:text]];
        [tmpArray filterUsingPredicate:predicate];
        
        [self.tableData removeAllObjects];
        NSMutableArray* tmpTableData = [NSMutableArray array];
        for (VGTableType* type in tmpArray) {
            [tmpTableData addObject:[self.user.dataSet objectAtIndex:type.key]];
        }
        [self reloadDataWithArray:tmpTableData];
    } else {
        [self reloadDataWithArray:self.user.dataSet];
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    [self reloadDataWithArray:self.user.dataSet];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    tableView.frame = CGRectMake(0, 88, self.tableView.frame.size.width, self.tableView.frame.size.height);
}


#pragma mark - Actions

@end

@implementation VGGraphItem : UIView

@end

@implementation VGGraphDesktop

- (void)dealloc
{
    self.user = nil;
    self.tableValues = nil;
    [super dealloc];
}

- (void) drawRect:(CGRect)rect {
    //[self reloadItems];
}

- (void) reloadItems {
    NSInteger originX = 0;
    NSInteger originY = 0;
    
    NSInteger offsetX = startOffset;
    NSInteger offsetY = startOffset;
    
    NSInteger fullOffsetRow = 0;
    NSInteger fullOffsetCol = 0;
    
    // Add lines
    [self.gdl removeFromSuperview];
    self.gdl = [[[VGGraphDesktopLines alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.gdl.user = self.user;
    self.gdl.tableValues = self.tableValues;
    self.gdl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.gdl];
    // Add columns
    for (NSInteger i = 0; i < self.user.columns.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((VGObject*)self.user.columns[i]).name];
        offsetX += deltaX;
        fullOffsetCol = originX;
    }
    // Add rows
    offsetX = startOffset;
    offsetY += graphItemHeight * 4;
    for (NSInteger i = 0; i < self.user.rows.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((VGObject*)self.user.rows[i]).name];
        offsetX += deltaX;
        fullOffsetRow = originX;
    }
    
    self.contentSize = CGSizeMake(MAX(fullOffsetRow, fullOffsetCol) + graphItemWidth * 2, self.frame.size.height);
    self.gdl.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

- (void) addItemWithOriginX:(NSInteger)originX andOriginY:(NSInteger)originY andValue:(NSString*)value {
    NSArray *topElements = [[NSBundle mainBundle] loadNibNamed:@"VGGraphItem" owner:self options:nil];
    VGGraphItem* tmpItem = nil;
    tmpItem = (VGGraphItem*)topElements[0];
    topElements = nil;
    ((UILabel*)[tmpItem viewWithTag:11]).text = value;
    tmpItem.frame = CGRectMake(originX, originY, tmpItem.frame.size.width, tmpItem.frame.size.height);
    [self addSubview:tmpItem];
}

@end

@implementation VGGraphDesktopLines

-(void)drawRect:(CGRect)rect {
    [self reloadData];
}

- (void) reloadData {
    NSInteger offsetX = 0;
    NSInteger offsetY = 0;
    if (self.tableValues != nil) {
        for (NSInteger i = 0; i < self.user.rows.count; i++) {
            offsetX = startOffset;
            offsetY = startOffset;
            for (NSInteger j = 0; j < self.user.columns.count; j++) {
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ && %K LIKE %@", @"row.object_id", ((VGObject*)self.user.rows[i]).object_id, @"col.object_id", ((VGObject*)self.user.columns[j]).object_id];
                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray: self.tableValues];
                [tmpArray filterUsingPredicate:predicate];
                if (tmpArray.count) {
                    
                    if (![((VGBaseDataModel*)tmpArray[0]).value isEqualToString: @"0"]) {
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextBeginPath(context);
                        
                        CGContextMoveToPoint(context, offsetX + graphItemWidth  * j + graphItemWidth / 2, offsetY + graphItemHeight/ 2);
                        CGContextAddLineToPoint(context, startOffset + (deltaX * i) + graphItemWidth  * i + graphItemWidth / 2, offsetY + graphItemHeight * 4.5);
                        
                        // Set line width
                        CGContextSetLineWidth(context, 0.5);
                        CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                        
                        //Draw on the screen
                        CGContextDrawPath(context, kCGPathFillStroke);
                        
                    }
                }
                offsetX += deltaX;
            }
        }
    }
}
- (void)dealloc
{
    self.user = nil;
    self.tableValues = nil;
    [super dealloc];
}

@end
