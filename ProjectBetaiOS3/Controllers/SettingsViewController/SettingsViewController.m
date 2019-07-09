//
//  SettingsViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/10/14.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    sections = [[NSMutableArray alloc] init];

    NSMutableArray *sec1 = [[NSMutableArray alloc] init];
    NSMutableArray *sec2 = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *aboutDic = [[NSMutableDictionary alloc] init];
    aboutDic[@"title"] = @"About";
    aboutDic[@"info"] = @"";
    
    NSMutableDictionary *version = [[NSMutableDictionary alloc] init];
    version[@"title"] = @"Version";
    version[@"info"] = @"0.0.1";

    [sec1 addObject:aboutDic];
    [sec1 addObject:version];
    
    NSMutableDictionary *login = [[NSMutableDictionary alloc] init];
    login[@"title"] = @"Log Out";
    login[@"info"] = @"";
    
    [sec2 addObject:login];
    
    [sections addObject:sec1];
    [sections addObject:sec2];
    
    self.aboutView.layer.cornerRadius = 5;
    self.titleView.layer.cornerRadius = 5;
    self.settingsTableView.layer.cornerRadius = 5;
    self.titleView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.settingsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *sec = (NSMutableArray *)[sections objectAtIndex:section];
    return sec.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"CellId";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSMutableArray *s = (NSMutableArray *)[sections objectAtIndex:section];
    NSMutableDictionary *r = [s objectAtIndex:row];
    
    cell.textLabel.text = r[@"title"];
    cell.detailTextLabel.text = r[@"info"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([r[@"title"] isEqualToString:@"About"]){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    if([r[@"title"] isEqualToString:@"Log Out"]){
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"About"]){
        [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseOut animations:^{
            self.aboutView.alpha = 1;
        } completion:nil];
    }
}

- (IBAction)closeButtonAction:(id)sender {
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:nil];
}

- (IBAction)backButton:(UIButton *)sender {
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseOut animations:^{
        self.aboutView.alpha = 0;
    } completion:nil];
}
- (void)dealloc {
    [_settingsTableView release];
    [_aboutView release];
    [super dealloc];
}
@end