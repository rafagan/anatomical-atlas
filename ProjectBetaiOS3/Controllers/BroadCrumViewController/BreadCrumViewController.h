//
//  BroadViewController.h
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/13/14.
//
//

#import <UIKit/UIKit.h>

@interface BreadCrumViewController : UIViewController{
    NSMutableArray *buttonsArray;
    NSMutableArray *auxString;
}

@property (retain, nonatomic) IBOutlet UIButton *rootButton;
@property BOOL firstCall;
@property BOOL blackAreaClicked;
-(void) passButtonSelected;
-(void)add:(NSArray *)titles;
+(void)setBreadCrumSingleton:(BreadCrumViewController *)breadCrum;
+(BreadCrumViewController *)breadCrumSingleton;

@end
