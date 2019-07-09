//
//  TopMenuViewController.mm
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import "TopMenuViewController.h"
#import "Categories.h"
#import "BallonViewController.h"
#import "RightMenuViewController.h"
#import "HelpViewController.h"
#import "BreadCrumViewController.h"
#import "BookmarkViewController.h"

@interface TopMenuViewController ()

@end

@implementation TopMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    stereoscopia = NO;
    labels = NO;
    
    for (UIView *subView in self.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                searchBarTextField.textColor = [UIColor whiteColor];
                break;
            }
        }
    }
    
    for(UIButton *btn in self.buttons){
        btn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        [btn setTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    }
    
    helpPopover = [[UIPopoverController alloc] initWithContentViewController:[[HelpViewController alloc] init]];
    [helpPopover setPopoverContentSize:helpPopover.contentViewController.view.frame.size];
    
    bookmarkPopover = [[UIPopoverController alloc]initWithContentViewController:[[BookmarkViewController alloc] init]];
    
    [bookmarkPopover setPopoverContentSize:bookmarkPopover.contentViewController.view.frame.size];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissBookmark) name:@"dismissBookmark" object:nil];
}

- (IBAction)fullscreenButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullscreen" object:nil];
}

- (IBAction)btnResetClicked:(id)sender
{
    UnitySendMessage("Skeleton", "PassToReset", "");
    UnitySendMessage("AppManager", "ClearSelection", "");
    [[BreadCrumViewController breadCrumSingleton] passButtonSelected];
    [[RightMenuViewController rightMenuSingleton] setHasAnBoneSelected:NO];
    [[BallonViewController ballonSingleton] resetBallon];
    [BallonViewController ballonSingleton].view.alpha = 0;
    [BallonViewController ballonSingleton].titleLabel.text = @"None";
    [RightMenuViewController rightMenuSingleton].boneNameLabel.text = @"None"; 
}

- (IBAction)drawButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"draw" object:nil];
}

- (IBAction)stereoscopyButtonAction:(id)sender {
    if(!stereoscopia)
    {
        UnitySendMessage("Main Camera", "TriggerEnable", "");
        stereoscopia = YES;
        [self.stereoscopyButton setTintColor:[UIColor colorForHexCode:@"3083FB"]];
    }
    else
    {
        UnitySendMessage("Main Camera", "TriggerDisable", "");
        stereoscopia = NO;
        [self.stereoscopyButton setTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    }
}

-(IBAction)helpButtonAction:(id)sender{
    //[[NSNotificationCenter defaultCenter]   postNotificationName:@"help" object:nil];
    
    [helpPopover presentPopoverFromRect:self.helpButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)bookmarkAction:(UIButton *)sender {
    [bookmarkPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)dealloc {
    [_searchBar release];
    [_buttons release];
    [_stereoscopyButton release];
    [_drawButton release];
    [_helpButton release];
    [super dealloc];
}

- (IBAction)btnLabel:(id)sender
{
    UIButton *labelButton = (UIButton *)sender;
    
    if(!labels)
    {
        UnitySendMessage("AppManager", "ActivateLabels", "");
        labels = YES;
        labelButton.tintColor = [UIColor colorForHexCode:@"3083FB"];
    }
    else
    {
        UnitySendMessage("AppManager", "DisableLabels", "");
        labels = NO;
        labelButton.tintColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    }
}

-(void)dismissBookmark{
    [bookmarkPopover dismissPopoverAnimated:YES];
}
@end