//
//  BallonViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/29/14.
//
//

#import "BallonViewController.h"
#import "RightMenuViewController.h"

@interface BallonViewController ()

@end

@implementation BallonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ballonView.layer.cornerRadius = 40;
    self.leftButton.layer.cornerRadius = self.leftButton.frame.size.width/2;
    self.rightButton.layer.cornerRadius = self.rightButton.frame.size.width/2;
    [self.view bringSubviewToFront:self.leftButton];
    [self.view bringSubviewToFront:self.rightButton];
    lastTime = 0;
    self.selectedBoneOpacityLevel = 0;
    self.otherBonesOpacityLevel = 0;
    self.stillShowing = NO;
    self.view.alpha = 0.95f;
}

- (void)dealloc {
    [_ballonView release];
    [_titleLabel release];
    [_subtitleLabel release];
    [_leftButton release];
    [_rightButton release];
    [_leftButton release];
    [_othersButton release];
    [_opacityButton release];
    [super dealloc];
}

- (IBAction)panGesture:(id)sender {
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSinceReferenceDate];
    NSTimeInterval time = currentTime - lastTime;
    
    if(time > 0.2f){
        lastTime = [[NSDate date] timeIntervalSinceReferenceDate];
        return;
    }
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
    CGPoint veloticity = [pan velocityInView:pan.view];
    veloticity.x = veloticity.x;
    veloticity.y = veloticity.y;
    CGFloat xf = self.view.frame.origin.x + (veloticity.x * time);
    CGFloat yf = self.view.frame.origin.y + (veloticity.y * time);
    lastTime = currentTime;
    
    UIView *parent = [self.view superview];
    
    if(xf < 0){
        xf = 0;
    }else if(xf > parent.frame.size.width - self.view.frame.size.width){
        xf = parent.frame.size.width - self.view.frame.size.width;
    }
    
    if(yf < 60){
        yf = 60;
    }else if(yf > parent.frame.size.height - self.view.frame.size.height - 50){
        yf = parent.frame.size.height - self.view.frame.size.height - 50;
    }
    
    self.view.frame = CGRectMake(xf, yf, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (IBAction)leftButton:(UIButton *)sender {

}

- (IBAction)rightButton:(UIButton *)sender {

}

- (IBAction)infoButton:(id)sender {
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.0f;
    } completion:nil];
    [[RightMenuViewController rightMenuSingleton] openMenu];
}

- (IBAction)btnOpacityClicked:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if(self.selectedBoneOpacityLevel == 0)
    {
        UnitySendMessage("AppManager", "Fade", "");
        [senderButton setImage:[UIImage imageNamed:@"half opacity.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
    }
    else if(self.selectedBoneOpacityLevel == 1)
    {
        UnitySendMessage("AppManager", "Hide", "");
        [senderButton setImage:[UIImage imageNamed:@"hide.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
    }
    else
    {
        UnitySendMessage("AppManager", "ShowHide", "");
        [senderButton setImage:[UIImage imageNamed:@"show.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        self.selectedBoneOpacityLevel = 0;
        [RightMenuViewController rightMenuSingleton].selectedBoneOpacityLevel = 0;
        
        return;
    }
    
    [RightMenuViewController rightMenuSingleton].selectedBoneOpacityLevel++;
    self.selectedBoneOpacityLevel++;
}

- (IBAction)btnOthersClicked:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if(self.otherBonesOpacityLevel == 0)
    {
        UnitySendMessage("AppManager", "FadeOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"half opacity.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].othersButton setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
    }
    else if(self.otherBonesOpacityLevel == 1)
    {
        UnitySendMessage("AppManager", "HideOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"hide.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].othersButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
    }
    else
    {
        UnitySendMessage("AppManager", "ShowHideOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"show.png" ] forState:UIControlStateNormal];
        [[RightMenuViewController rightMenuSingleton].othersButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        self.otherBonesOpacityLevel = 0;
        [RightMenuViewController rightMenuSingleton].otherBonesOpacityLevel = 0;
        return;
    }
    
    [RightMenuViewController rightMenuSingleton].otherBonesOpacityLevel++;
    self.otherBonesOpacityLevel++;
}

-(void)resetBallon
{
    self.selectedBoneOpacityLevel = 0;
    self.otherBonesOpacityLevel = 0;
    [RightMenuViewController rightMenuSingleton].selectedBoneOpacityLevel = 0;
    [RightMenuViewController rightMenuSingleton].otherBonesOpacityLevel = 0;
    
     [[RightMenuViewController rightMenuSingleton].othersButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
     [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
    
    [self.opacityButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
    [self.othersButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
}


static BallonViewController* b = nil;

+(BallonViewController *)ballonSingleton
{
    if(!b){
        b = [[BallonViewController alloc] init];
    }
    
    return b;
}

+(void)setBallonSingleton:(BallonViewController *)ballon
{
    b = ballon;
}

@end
