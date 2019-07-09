//
//  TopMenuViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import <UIKit/UIKit.h>

@interface TopMenuViewController : UIViewController
{
    BOOL stereoscopia;
    BOOL labels;
    UIPopoverController *helpPopover;
    UIPopoverController *bookmarkPopover;
}

- (IBAction)drawButtonAction:(id)sender;
- (IBAction)stereoscopyButtonAction:(id)sender;
- (IBAction)fullscreenButtonAction:(id)sender;
- (IBAction)btnResetClicked:(id)sender;
-(IBAction)helpButtonAction:(id)sender;
- (IBAction)bookmarkAction:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (retain, nonatomic) IBOutlet UIButton *stereoscopyButton;
@property (retain, nonatomic) IBOutlet UIButton *drawButton;
@property (retain, nonatomic) IBOutlet UIButton *helpButton;
- (IBAction)btnLabel:(id)sender;

@end
