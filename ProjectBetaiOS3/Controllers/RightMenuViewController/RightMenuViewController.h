//
//  RightMenuViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/13/14.
//
//

#import <UIKit/UIKit.h>

@class Arvore;

@interface RightMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSTimeInterval lastTime, currentTime;
    BOOL isTabBlocked;
    NSMutableArray *treeNavigationStack;
}

@property (retain, nonatomic) IBOutlet UILabel *mapSectionNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *othersButton;
@property (retain, nonatomic) IBOutlet UIButton *opacityButton;
@property (retain, nonatomic) IBOutlet UIView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *bonesTableView;
@property (strong, nonatomic) Arvore *arvore;
@property (retain, nonatomic) IBOutlet UIView *infoVIew;
@property (retain, nonatomic) IBOutlet UIView *menuView;
@property BOOL isOpen;
@property int selectedBoneOpacityLevel;
@property int otherBonesOpacityLevel;
@property BOOL hasAnBoneSelected;
@property (retain, nonatomic) IBOutlet UILabel *boneNameLabel;
@property (retain, nonatomic) IBOutlet UITextView *boneDescriptionTextView;
@property (retain, nonatomic) IBOutlet UIView *tab;
@property (retain, nonatomic) IBOutlet UIPanGestureRecognizer *tabPan;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *loadingMapLabel;


+(RightMenuViewController *)rightMenuSingleton;
+(void)setRightMenuSingleton:(RightMenuViewController *)rightMenu;
- (IBAction)tabPanGesture:(UIPanGestureRecognizer *)sender;
- (IBAction)btnOthersClicked:(id)sender;
- (IBAction)btnOpacityClicked:(id)sender;
- (IBAction)seg:(id)sender;
-(void)closeMenu;
-(void)openMenu;


@end
