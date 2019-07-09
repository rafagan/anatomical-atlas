    //
//  BookmarkViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/10/14.
//
//

#import <UIKit/UIKit.h>

@interface BookmarkViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UIAlertView *addAlert;
}

@property (retain, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (retain, nonatomic) IBOutlet UIButton *add;
@property (retain, nonatomic) IBOutlet UIButton *edit;
@property (retain, nonatomic) IBOutlet UIButton *restore;
@property (strong, nonatomic) NSMutableArray *bookmarkArray;

+(void)setBookmarkSingleton:(BookmarkViewController *)bookMark;

- (IBAction)addBookmark:(UIButton *)sender;
- (IBAction)editBookmark:(UIButton *)sender;

@end