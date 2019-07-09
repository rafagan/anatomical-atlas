//
//  FiltroTableViewCell.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/11/14.
//
//

#import <UIKit/UIKit.h>

@interface FiltroTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)switchAction:(UISwitch *)sender;

@end
