//
//  DownloadPopoverViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/8/14.
//
//

#import "DownloadPopoverViewController.h"

@interface DownloadPopoverViewController ()

@end

@implementation DownloadPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)startDownloadPopover:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadQuiz"  object:nil];
}
@end
