//
//  QuizCardPopoverViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/3/14.
//
//

#import "PlayPopoverViewController.h"

@interface PlayPopoverViewController ()

@end

@implementation PlayPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.optionSelected = 0;
    
    deleteAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete?"  message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes" , nil];
}

- (IBAction)deleteButton:(id)sender {
    [deleteAlert show];
}

- (IBAction)startButton:(id)sender {
    self.optionSelected = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popoverOptionSelected"  object:nil];
}

- (void)dealloc {
    [_redButton release];
    [_blueButton release];
    [super dealloc];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        self.optionSelected = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popoverOptionSelected"  object:nil];
    }
}

@end