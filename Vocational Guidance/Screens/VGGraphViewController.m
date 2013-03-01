//
//  VGGraphViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 28.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGraphViewController.h"

static const NSInteger graphItemWidth = 89;
static const NSInteger graphItemHeight = 89;

static NSString * CellIdentifier = @"GraphCell";

@interface VGGraphViewController ()
@property (retain, nonatomic) IBOutlet VGGraphDesktop *graphDesktop;
@property (retain, nonatomic) IBOutlet UITextField *txtSearch;

@end

@implementation VGGraphViewController

- (id) init
{
    self = [super initWithNibName:@"VGGraphViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.tableData = [NSMutableArray array];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [VGAppDelegate getInstance].values;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) dealloc {
    self.tableData = nil;
    [_graphDesktop release];
    [_tableView release];
    [_txtSearch release];
    [super dealloc];
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
    
    VGTableCell* tmpCell = (VGTableCell*)self.tableData[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ , %@: %@",
                      ((NSString*)[VGAppDelegate getInstance].rows[tmpCell.rowIndex]),
                      ((NSString*)[VGAppDelegate getInstance].columns[tmpCell.colIndex]),
                      tmpCell.value];
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - Actions

- (IBAction)clickSearch:(id)sender {
}

@end

@implementation VGGraphItem : UIView

@end

@implementation VGGraphDesktop

-(void)drawRect:(CGRect)rect {
    NSInteger originX = 0;
    NSInteger originY = 0;
    
    NSInteger offsetX = 20;
    NSInteger offsetY = 20;
    
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].columns.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((NSString*)[VGAppDelegate getInstance].columns[i])];
        offsetX += 20;
    }
    
    offsetX = 20;
    offsetY += graphItemHeight * 4;
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].rows.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((NSString*)[VGAppDelegate getInstance].columns[i])];
        offsetX += 20;
    }
    
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].columns.count; i++) {
        for (NSInteger j = 0; j < [VGAppDelegate getInstance].rows.count; j++) {
            
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextBeginPath(context);
            
            CGContextMoveToPoint(context, 150,0);
            CGContextAddLineToPoint(context, 300, 300);
            
            // Set line width
            CGContextSetLineWidth(context, 2.0);
            CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
            
            //Draw on the screen
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    self.contentSize = CGSizeMake(offsetX + MAX([VGAppDelegate getInstance].columns.count * graphItemWidth, [VGAppDelegate getInstance].rows.count), self.frame.size.height);
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
