//
//  CloseFullscreenViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import "CloseFullscreenViewController.h"
#import "Categories.h"

@interface CloseFullscreenViewController ()

@end

@implementation CloseFullscreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_label setTextColor:[UIColor atlasBlue]];
}

- (IBAction)action:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullscreen" object:nil];
}
- (void)dealloc {
    [_label release];
    [super dealloc];
}
@end
