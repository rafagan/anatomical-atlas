//
//  RightMenuViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/13/14.
//
//

#import "RightMenuViewController.h"
#import "Categories.h"
#import "BallonViewController.h"
#import "Arvore.h"
#import "NoArvore.h"

#define TABLE_VIEW_BLOCK_DISTANCE 4.0f

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Configurações das variaveis auxiliares da classe
    self.selectedBoneOpacityLevel = 0;
    self.otherBonesOpacityLevel = 0;
    self.isOpen = NO;
    self.hasAnBoneSelected = NO;
    isTabBlocked = NO;
    self.bonesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Obeservers Setup
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBoneTableView) name:@"loadRightMenuBoneHierarchy" object:nil];
}

//Carrega ossos
-(void)loadBoneTableView{
    //Delegate da tableView
    _bonesTableView.dataSource = self;
    _bonesTableView.delegate = self;
    
    //Configuração do conteudo da tableView no formato de arvore
    _arvore = [[Arvore alloc] init];
    [self.arvore.root.subnodes addObject:[Arvore boneHierarchyWithBones].root];
    [self.arvore indexTree];
    
    //Carrega o conteudo tableView
    treeNavigationStack = [[NSMutableArray alloc]initWithObjects:self.arvore.root, nil];
    [self.bonesTableView reloadData];
    [self adjustTableViewHeight];
    [self.spinner stopAnimating];
    self.loadingMapLabel.hidden = YES;
    self.mapSectionNameLabel.hidden = NO;
}

//Callback do segmented controll para alterar entre map e info view
- (IBAction)seg:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    
    if(segmented.selectedSegmentIndex == 0){
        self.mapView.hidden = YES;
        self.infoVIew.hidden = NO;
    }else if(segmented.selectedSegmentIndex == 1){
        self.mapView.hidden = NO;
        self.infoVIew.hidden = YES;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if([actualNode isEqual:self.arvore.root]){
        return actualNode.subnodes.count;
    }else{
        return actualNode.subnodes.count + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if([actualNode isEqual:_arvore.root]){
        NoArvore *subnode = actualNode.subnodes[indexPath.row];
        cell.textLabel.text = subnode.title;
        cell.textLabel.textColor = [UIColor atlasLightGreen];
        cell.indentationLevel = 0;
    }else{
        if(indexPath.row == 0){
            if(treeNavigationStack.count > 2){
                NoArvore *previousSection = treeNavigationStack[treeNavigationStack.count - 2];
                cell.textLabel.text = [NSString stringWithFormat:@"Return to %@", previousSection.title];
                
            }else{
                cell.textLabel.text = @"Return to Skeleton System";
            }
            
            cell.textLabel.textColor = [UIColor atlasBlue];
            cell.indentationLevel = 0;
        }else{
            NoArvore *subnode = actualNode.subnodes[indexPath.row - 1];
            cell.textLabel.text = subnode.title;
            if(subnode.subnodes.count == 0){
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }else{
                cell.textLabel.textColor = [UIColor atlasLightGreen];
            }
            
            cell.indentationLevel = 1;
        }
    }
    
    cell.indentationWidth = 30;
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    
    NoArvore *selectedNode = nil;
    if([actualNode isEqual:_arvore.root]){
        selectedNode = actualNode.subnodes[indexPath.row];
    }else{
        if(indexPath.row == 0){
            [treeNavigationStack removeLastObject];
        }else{
            selectedNode = actualNode.subnodes[indexPath.row - 1];
            
        }
    }
    
    if(selectedNode){
        if(selectedNode.subnodes.count > 0){
            [treeNavigationStack addObject:selectedNode];
            [self.bonesTableView reloadData];
            [self adjustTableViewHeight];
        }
    }else{
        [self.bonesTableView reloadData];
        [self adjustTableViewHeight];
    }
}

-(void)adjustTableViewHeight{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if ([actualNode isEqual:_arvore.root]) {
        if(actualNode.subnodes.count * 44 > 497){
            self.bonesTableView.frame = CGRectMake(self.bonesTableView.frame.origin.x, self.bonesTableView.frame.origin.y, self.bonesTableView.frame.size.width, 497);
        }else{
            self.bonesTableView.frame = CGRectMake(self.bonesTableView.frame.origin.x, self.bonesTableView.frame.origin.y, self.bonesTableView.frame.size.width, actualNode.subnodes.count * 44);
        }
        
        self.mapSectionNameLabel.text = @"Skeleton System:";
        
    }else{
        if((actualNode.subnodes.count + 1)* 44 > 497){
            self.bonesTableView.frame = CGRectMake(self.bonesTableView.frame.origin.x, self.bonesTableView.frame.origin.y, self.bonesTableView.frame.size.width, 497);
        }else{
            self.bonesTableView.frame = CGRectMake(self.bonesTableView.frame.origin.x, self.bonesTableView.frame.origin.y, self.bonesTableView.frame.size.width, (actualNode.subnodes.count + 1)* 44);
        }
        
        NoArvore *thisSection = treeNavigationStack.lastObject;
        self.mapSectionNameLabel.text = [NSString stringWithFormat:@"%@:", thisSection.title];
    }
}

- (IBAction)btnOpacityClicked:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if(self.selectedBoneOpacityLevel == 0)
    {
        UnitySendMessage("AppManager", "Fade", "");
        [senderButton setImage:[UIImage imageNamed:@"half opacity.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].opacityButton setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
    }
    else if(self.selectedBoneOpacityLevel == 1)
    {
        UnitySendMessage("AppManager", "Hide", "");
        [senderButton setImage:[UIImage imageNamed:@"hide.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].opacityButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
    }
    else
    {
        UnitySendMessage("AppManager", "ShowHide", "");
        [senderButton setImage:[UIImage imageNamed:@"show.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].opacityButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        self.selectedBoneOpacityLevel = 0;
        [BallonViewController ballonSingleton].selectedBoneOpacityLevel = 0;
        return;
    }
    
    [BallonViewController ballonSingleton].selectedBoneOpacityLevel++;
    self.selectedBoneOpacityLevel++;
}

- (IBAction)btnOthersClicked:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    
    if(self.otherBonesOpacityLevel == 0){
        UnitySendMessage("AppManager", "FadeOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"half opacity.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].othersButton setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
    }
    else if(self.otherBonesOpacityLevel == 1){
        UnitySendMessage("AppManager", "HideOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"hide.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].othersButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
    }
    else{
        UnitySendMessage("AppManager", "ShowHideOthers", "");
        [senderButton setImage:[UIImage imageNamed:@"show.png" ] forState:UIControlStateNormal];
        [[BallonViewController ballonSingleton].othersButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        [BallonViewController ballonSingleton].otherBonesOpacityLevel = 0;
        self.otherBonesOpacityLevel = 0;
        return;
    }
    
    [BallonViewController ballonSingleton].otherBonesOpacityLevel++;
    self.otherBonesOpacityLevel++;
}

- (IBAction)tabPanGesture:(UIPanGestureRecognizer *)sender{
    
    if(!isTabBlocked){
        currentTime = [[NSDate date] timeIntervalSinceReferenceDate];
        NSTimeInterval deltaTime = currentTime - lastTime;
        if(deltaTime > 0.2) deltaTime = 0;
        
        int vx = [sender velocityInView:self.view].x;
        int x = self.view.frame.origin.x + vx * deltaTime;
        
        if(sender.state == UIGestureRecognizerStateEnded){
            isTabBlocked = YES;
            if(!self.isOpen){
                if(x + self.tab.frame.size.width > self.view.superview.frame.size.width - ((float)(1/TABLE_VIEW_BLOCK_DISTANCE) * self.menuView.frame.size.width)){
                    [self closeMenu];
                    if(self.hasAnBoneSelected){
                        [BallonViewController ballonSingleton].view.alpha = 0.95f;
                    }
                }else{
                    [self openMenu];
                    [BallonViewController ballonSingleton].view.alpha = 0.0f;
                }
            }else{
                if(x + self.tab.frame.size.width < self.view.superview.frame.size.width - ((float)(1 -(1/TABLE_VIEW_BLOCK_DISTANCE)) * self.menuView.frame.size.width)){
                    [self openMenu];
                    [BallonViewController ballonSingleton].view.alpha = 0.0f;
                }else{
                    [self closeMenu];
                    if(self.hasAnBoneSelected){
                        [BallonViewController ballonSingleton].view.alpha = 0.95f;
                    }
                }
            }
        }else{
            if(x > self.view.superview.frame.size.width - self.tab.frame.size.width){
                x = self.view.superview.frame.size.width - self.tab.frame.size.width;
            }
            
            if(x < self.view.superview.frame.size.width - self.view.frame.size.width){
                x = self.view.superview.frame.size.width - self.view.frame.size.width;
            }
            
            [self.view setFrame:CGRectMake(x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            lastTime = currentTime;
        }
    }
}

-(void)closeMenu{
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(self.view.superview.frame.size.width - self.tab.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self.isOpen = NO;
    } completion:^(BOOL finished){
        if(finished) isTabBlocked = NO;
    }];
}

-(void)openMenu{
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(self.view.superview.frame.size.width - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        self.isOpen = YES;
    } completion:^(BOOL finished){
        if(finished) isTabBlocked = NO;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //não apague
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //não apague
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
     //não apague
}

- (void)dealloc {
    [_infoVIew release];
    [_opacityButton release];
    [_othersButton release];
    [_tab release];
    [_menuView release];
    [_boneNameLabel release];
    [_boneDescriptionTextView release];
    [_tab release];
    [_tabPan release];
    [_mapSectionNameLabel release];
    [super dealloc];
}

static RightMenuViewController *r = nil;

+(RightMenuViewController *)rightMenuSingleton{
    if(!r){
        r = [[RightMenuViewController alloc] init];
    }
    
    return r;
}

+(void)setRightMenuSingleton:(RightMenuViewController *)rightMenu{
    r = rightMenu;
}

@end
