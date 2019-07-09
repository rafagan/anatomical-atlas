//
//  BottomMenuViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/2/14.
//
//

#import "BottomMenuViewController.h"
#import "Categories.h"

@interface BottomMenuViewController ()

@end

@implementation BottomMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.quizButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profileButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.atlasButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.settingsButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.atlasButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self.profileButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.quizButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.settingsButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

- (IBAction)loginButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    [self.atlasButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.profileButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self.quizButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.settingsButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

- (IBAction)quizLibraryViewController:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"quizLibrary" object:nil];
    [self.atlasButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.profileButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.quizButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self.settingsButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

- (IBAction)atlasButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"atlas" object:nil];
    [self.atlasButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self.profileButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.quizButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.settingsButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
}

- (IBAction)settingsButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settings" object:nil];
    [self.atlasButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.profileButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.quizButton setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    [self.settingsButton setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
}

- (void)dealloc{
    [_quizButton release];
    [_settingsButton release];
    [_profileButton release];
    [_atlasButton release];
    [super dealloc];
}

BottomMenuViewController *bottomMenuSingleton = nil;

+(BottomMenuViewController *)bottomMenuViewControllerSingleton{
    if(!bottomMenuSingleton){
        bottomMenuSingleton = [[BottomMenuViewController alloc] init];
    }
    
    return bottomMenuSingleton;
}

+(void)setBottomMenuSingleton:(BottomMenuViewController *)bottomMenu{
    bottomMenuSingleton = bottomMenu;
}

@end
