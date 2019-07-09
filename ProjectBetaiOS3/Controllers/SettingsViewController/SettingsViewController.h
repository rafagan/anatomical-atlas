//
//  SettingsViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/10/14.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *sections;
}

@property (retain, nonatomic) IBOutlet UITableView *settingsTableView;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIView *aboutView;

- (IBAction)closeButtonAction:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@end
