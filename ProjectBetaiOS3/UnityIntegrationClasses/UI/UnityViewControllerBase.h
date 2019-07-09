#ifndef _TRAMPOLINE_UI_UNITYVIEWCONTROLLERBASE_H_
#define _TRAMPOLINE_UI_UNITYVIEWCONTROLLERBASE_H_

#import <UIKit/UIKit.h>

typedef BOOL				(*ShouldAutorotateToFunc)(id, SEL, UIInterfaceOrientation);
typedef NSUInteger			(*SupportedInterfaceOrientationsFunc)(id, SEL);
typedef BOOL				(*ShouldAutorotateFunc)(id, SEL);
typedef BOOL				(*PrefersStatusBarHiddenFunc)(id, SEL);
typedef UIStatusBarStyle	(*PreferredStatusBarStyleFunc)(id, SEL);

BOOL				ShouldAutorotateToInterfaceOrientation_DefaultImpl(id self_, SEL _cmd, UIInterfaceOrientation interfaceOrientation);
NSUInteger			SupportedInterfaceOrientations_DefaultImpl(id self_, SEL _cmd);
BOOL				ShouldAutorotate_DefaultImpl(id self_, SEL _cmd);
BOOL				PrefersStatusBarHidden_DefaultImpl(id self_, SEL _cmd);
UIStatusBarStyle	PreferredStatusBarStyle_DefaultImpl(id self_, SEL _cmd);

void	AddShouldAutorotateToImplIfNeeded(Class targetClass, ShouldAutorotateToFunc);
void	AddShouldAutorotateToDefaultImplIfNeeded(Class targetClass);

void	AddOrientationSupportImpl(Class targetClass, SupportedInterfaceOrientationsFunc, ShouldAutorotateFunc, ShouldAutorotateToFunc);
void	AddOrientationSupportDefaultImpl(Class targetClass);

void	AddStatusBarSupportImpl(Class targetClass, PrefersStatusBarHiddenFunc, PreferredStatusBarStyleFunc);
void	AddStatusBarSupportDefaultImpl(Class targetClass);

void	AddViewControllerAllDefaultImpl(Class targetClass);

@class TopMenuViewController;
@class BottomMenuViewController;
@class LoginViewController;
@class DrawViewController;
@class BreadCrumViewController;
@class RightMenuViewController;
@class CloseFullscreenViewController;
@class QuizLibraryViewController;
@class BallonViewController;
@class SettingsViewController;
@class UnityView;

// this is base implementation of unity orientation support
// for most of apps it is sufficient to subclass it.
// if you want your own view controller please check the implementation for what needs to be done for unity to work properly
@interface UnityViewControllerBase : UIViewController
{
	UnityView*	_unityView;
    TopMenuViewController *topMenu;
    BottomMenuViewController *bottomMenu;
    LoginViewController *loginView;
    DrawViewController *drawView;
    BreadCrumViewController *breadView;
    RightMenuViewController *rightMenu;
    CloseFullscreenViewController *closeFullscreen;
    QuizLibraryViewController *quizLibraryView;
    BallonViewController *ballonView;
    SettingsViewController *settingsView;
    UIView *preview;
    BOOL isRightMenuOpen;
}

- (void)assignUnityView:(UnityView*)view;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
+(BOOL)isFullscreen;
+(void)setIsFullscreen:(BOOL)f;

@end

// this is default view controller implementation
@interface UnityDefaultViewController : UnityViewControllerBase {}
@end


#endif
