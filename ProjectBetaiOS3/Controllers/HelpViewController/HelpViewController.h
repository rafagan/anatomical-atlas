//
//  HelpViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/7/14.
//
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *cellInfo;
}
@property (retain, nonatomic) IBOutlet UITableView *helpTableView;

@end
