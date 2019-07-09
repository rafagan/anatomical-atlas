//
//  BroadViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 11/13/14.
//
//

#import "Categories.h"
#import "BreadCrumViewController.h"
#import "BallonViewController.h"
#import "RightMenuViewController.h"

@interface BreadCrumViewController ()

@end

@implementation BreadCrumViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        auxString = [[NSMutableArray alloc] init];
        buttonsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstCall = YES;
    self.blackAreaClicked = NO;
    self.view.layer.cornerRadius = 6;
    [_rootButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsArray addObject:_rootButton];
    [_rootButton setBackgroundColor: [UIColor clearColor]];
}

-(void)updateBroad
{
    if(buttonsArray.count > self.view.subviews.count)
    {
        UIButton *lastAddedButton = self.view.subviews.lastObject;
        lastAddedButton.tintColor = [UIColor atlasLightGreen];
        [lastAddedButton sizeToFit];
        
        for(int i = self.view.subviews.count; i < buttonsArray.count; i++)
        {
            UIButton *newButton = buttonsArray[i];
            lastAddedButton = self.view.subviews.lastObject;
            newButton.tintColor = [UIColor atlasLightGreen];
            if(i == buttonsArray.count - 1)
            {
                NSString *str = [newButton.titleLabel.text substringToIndex:newButton.titleLabel.text.length - 3];
                [newButton setTitle:str forState:UIControlStateNormal];
                newButton.tintColor = [UIColor atlasBlue];
            }
            [newButton setFrame:CGRectMake(lastAddedButton.frame.origin.x + lastAddedButton.frame.size.width, lastAddedButton.frame.origin.y, newButton.frame.size.width, newButton.frame.size.height)];
            [newButton sizeToFit];
            [self.view addSubview:newButton];
        }
    }
    else if(self.view.subviews.count > buttonsArray.count)
    {
        int indexOfLast = buttonsArray.count;
        
        for(UIButton *btn in self.view.subviews)
        {
            int index = [self.view.subviews indexOfObject:btn];
            if(index >= indexOfLast){
                [btn removeFromSuperview];
            }
        }

    }else{
        return;
    }
    
    int width = 0;
    for(UIButton *b in self.view.subviews){
        [b sizeToFit];
        width += b.frame.size.width;
    }
    
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, width + 16, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)add:(NSArray *)titles
{
    if(!self.firstCall)
    {
        self.firstCall = YES;
        return;
    }
    
    for(NSString *str in titles)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor = [UIColor greenColor];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = [NSString stringWithFormat:@"%@ > ", str];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn sizeToFit];

        if (buttonsArray.count == 2)
        {
            [self buttonSelected:[buttonsArray firstObject]];
            [buttonsArray addObject:btn];
            self.firstCall = NO;
            [self.rootButton sizeToFit];
            [self.rootButton setTitle:@"Skeleton > " forState:UIControlStateNormal];
            [self updateBroad];
            return;
        }
        
        [self.rootButton setTitle:@"Skeleton > " forState:UIControlStateNormal];
        [buttonsArray addObject:btn];
        [self updateBroad];
    }
    self.firstCall = NO;
}

-(void)passButtonSelected
{
    if(!buttonsArray.count >= 1) return;
    
    for(int i = 1; i < buttonsArray.count; i++)
    {
        [buttonsArray removeObjectAtIndex:i];
    }
    
    [self.rootButton setTitle:@"Skeleton " forState:UIControlStateNormal];
    [self.rootButton setTintColor:[UIColor atlasBlue]];
    [self updateBroad];
    UnitySendMessage("AppManager", "ClearSelection", "");
}

-(IBAction)buttonSelected:(id)sender
{
    if (buttonsArray.count == 1)
        return;
    
    UIButton *buttonSelected = (UIButton *)sender;

    while([buttonsArray indexOfObject:buttonSelected] != buttonsArray.count - 1)
        [buttonsArray removeLastObject];
    
    buttonSelected.tintColor = [UIColor atlasBlue];
    
    if(buttonsArray.count == 2)
        [self.rootButton setTitle:@"Skeleton >" forState:UIControlStateNormal];
    else
    {
        [[BallonViewController ballonSingleton] setStillShowing:NO];
        [BallonViewController ballonSingleton].view.alpha = 0.0f;
        [[[RightMenuViewController rightMenuSingleton] boneNameLabel] setText:@"None"];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setText:@"Select a bone to see its information here."];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setTextColor:[UIColor whiteColor]];
        [[RightMenuViewController rightMenuSingleton] setHasAnBoneSelected:NO];
        
        if(self.blackAreaClicked && buttonsArray.count == 1)
            UnitySendMessage("AppManager", "ClearSelection", "");
        
        [self.rootButton setTitle:@"Skeleton " forState:UIControlStateNormal];
    }
    
    [self updateBroad];
}

static BreadCrumViewController *b = nil;

+(BreadCrumViewController *)breadCrumSingleton{
    if(!b)
        b = [[BreadCrumViewController alloc] init];
    
    return b;
}

+(void)setBreadCrumSingleton:(BreadCrumViewController *)breadCrum
{
    b = breadCrum;
}


@end
