//
//  VGGraphViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 28.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGraphViewController.h"

static const NSInteger graphItemWidth   = 89;
static const NSInteger graphItemHeight  = 89;
static const NSInteger deltaX           = 200;

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
}

- (void) dealloc {
    self.tableData = nil;
    [_graphDesktop release];
    [_tableView release];
    [_txtSearch release];
    [super dealloc];
}

- (void) reloadData {
    self.tableData = [VGAppDelegate getInstance].values;
    [self.tableView reloadData];
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

- (void) drawRect:(CGRect)rect {
    [self reloadItems];
}

- (void) reloadItems {
    NSInteger originX = 0;
    NSInteger originY = 0;
    
    NSInteger offsetX = 20;
    NSInteger offsetY = 20;
    
    [self.gdl removeFromSuperview];
    self.gdl = [[[VGGraphDesktopLines alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    self.gdl.backgroundColor = [UIColor clearColor];
    [self addSubview:self.gdl];
    
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].columns.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((NSString*)[VGAppDelegate getInstance].columns[i])];
        offsetX += deltaX;
    }
    
    offsetX = 20;
    offsetY += graphItemHeight * 4;
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].rows.count; i++) {
        originX = offsetX + graphItemWidth  * i;
        originY = offsetY;
        
        [self addItemWithOriginX:originX andOriginY:originY andValue: ((NSString*)[VGAppDelegate getInstance].rows[i])];
        offsetX += deltaX;
    }
    
    self.contentSize = CGSizeMake(offsetX + MAX([VGAppDelegate getInstance].columns.count * graphItemWidth, [VGAppDelegate getInstance].rows.count), self.frame.size.height);
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
    
    for (NSInteger i = 0; i < [VGAppDelegate getInstance].rows.count; i++) {
        offsetX = 20;
        offsetY = 20;
        for (NSInteger j = 0; j < [VGAppDelegate getInstance].columns.count; j++) {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %d && %K == %d", @"rowIndex", i, @"colIndex", j];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray: [VGAppDelegate getInstance].values];
            [tmpArray filterUsingPredicate:predicate];
            if (![((VGTableCell*)tmpArray[0]).value isEqualToString: @"0"]) {
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextBeginPath(context);
                
                CGContextMoveToPoint(context, offsetX + graphItemWidth  * j + graphItemWidth / 2, offsetY + graphItemHeight/ 2);
                CGContextAddLineToPoint(context, 20 + (deltaX * i) + graphItemWidth  * i + graphItemWidth / 2, offsetY + graphItemHeight * 4.5);
                
                // Set line width
                CGContextSetLineWidth(context, 0.5);
                CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
                
                //Draw on the screen
                CGContextDrawPath(context, kCGPathFillStroke);
                
            }
            offsetX += deltaX;
        }
    }
}

@end
