//
//  HelpViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/7/14.
//
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helpTableView.dataSource = self;
    self.helpTableView.delegate = self;
    self.helpTableView.backgroundColor = [UIColor clearColor];
    self.view.layer.cornerRadius = 4;
    
    cellInfo = [[NSMutableDictionary alloc] init];
    
    cellInfo[@"titles"] = [[NSMutableArray alloc] init];
    cellInfo[@"images"] = [[NSMutableArray alloc] init];
    
    [cellInfo[@"titles"] addObject:@"One finger to rotate"];
    [cellInfo[@"titles"] addObject:@"Pinch to zoom"];
    [cellInfo[@"titles"] addObject:@"Three thingers to pan"];
    [cellInfo[@"titles"] addObject:@"Two taps to reset"];
    
    [cellInfo[@"images"] addObject:[UIImage imageNamed:@"one finger.png"]];
    [cellInfo[@"images"] addObject:[UIImage imageNamed:@"pinch.png"]];
    [cellInfo[@"images"] addObject:[UIImage imageNamed:@"three fingers.png"]];
    [cellInfo[@"images"] addObject:[UIImage imageNamed:@"two taps.png"]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cellInfo[@"titles"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"Cell Id";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue"  size:13];
    cell.textLabel.text = cellInfo[@"titles"][indexPath.row];
    cell.imageView.image = cellInfo[@"images"][indexPath.row];
    
    return cell;
}


- (void)dealloc {
    [_helpTableView release];
    [super dealloc];
}
@end
