#include "UnityViewControllerBase.h"
#include "iPhone_OrientationSupport.h"
#include "UI/UnityView.h"
#include "objc/runtime.h"

#import "CoreDataManager.h"
#import "BoneSetCD.h"
#import "BoneSetRelatedQuestions.h"
#import "DataSourceManager.h"
#import "Arvore.h"
#import "NoArvore.h"
#import "BonePart.h"
#import "BoneSet.h"
#import "Bone.h"

#import "HelpViewController.h"
#import "TopMenuViewController.h"
#import "BottomMenuViewController.h"
#import "LoginViewController.h"
#import "DrawViewController.h"
#import "BreadCrumViewController.h"
#import "RightMenuViewController.h"
#import "CloseFullscreenViewController.h"
#import "QuizLibraryViewController.h"
#import "BallonViewController.h"
#import "SettingsViewController.h"
#import "QuizViewController.h"

#define debug 1
#define ANIMATION_TIME 0.17

BOOL
ShouldAutorotateToInterfaceOrientation_DefaultImpl(id self_, SEL _cmd, UIInterfaceOrientation interfaceOrientation)
{
	EnabledOrientation targetAutorot = autorotLandscapeLeft;
	ScreenOrientation  targetRot = ConvertToUnityScreenOrientation(interfaceOrientation, &targetAutorot);
	ScreenOrientation  requestedOrientation = (ScreenOrientation)UnityRequestedScreenOrientation();

	if(requestedOrientation == autorotation)
		return UnityIsOrientationEnabled(targetAutorot);
	else
		return targetRot == requestedOrientation;
}

NSUInteger
SupportedInterfaceOrientations_DefaultImpl(id self_, SEL _cmd)
{
	NSUInteger ret = 0;

	if(UnityRequestedScreenOrientation() == autorotation)
	{
		if( UnityIsOrientationEnabled(autorotPortrait) )			ret |= (1 << UIInterfaceOrientationLandscapeLeft);
		if( UnityIsOrientationEnabled(autorotPortraitUpsideDown) )	ret |= (1 << UIInterfaceOrientationLandscapeRight);
		if( UnityIsOrientationEnabled(autorotLandscapeLeft) )		ret |= (1 << UIInterfaceOrientationLandscapeRight);
		if( UnityIsOrientationEnabled(autorotLandscapeRight) )		ret |= (1 << UIInterfaceOrientationLandscapeLeft);
	}
	else
	{
		switch(UnityRequestedScreenOrientation())
		{
			case portrait:				ret = (1 << UIInterfaceOrientationLandscapeLeft);      break;
			case portraitUpsideDown:	ret = (1 << UIInterfaceOrientationLandscapeRight);     break;
			case landscapeLeft:			ret = (1 << UIInterfaceOrientationLandscapeLeft);      break;
			case landscapeRight:		ret = (1 << UIInterfaceOrientationLandscapeRight);     break;
			default:					ret = (1 << UIInterfaceOrientationLandscapeLeft);      break;
		}
	}

	return ret;
}

BOOL
ShouldAutorotate_DefaultImpl(id self_, SEL _cmd)
{
	return (UnityRequestedScreenOrientation() == autorotation);
}

BOOL
PrefersStatusBarHidden_DefaultImpl(id self_, SEL _cmd)
{
	// we do not support changing styles from script, so we need read info.plist only once
	static BOOL _PrefersStatusBarHidden = NO;

	bool _PrefersStatusBarHiddenInited = false;
	if(!_PrefersStatusBarHiddenInited)
	{
		NSNumber* hidden = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIStatusBarHidden"];
		_PrefersStatusBarHidden = hidden ? [hidden boolValue] : YES;

		_PrefersStatusBarHiddenInited = NO;
	}

	return NO;
}

UIStatusBarStyle
PreferredStatusBarStyle_DefaultImpl(id self_, SEL _cmd)
{
	static UIStatusBarStyle _PreferredStatusBarStyle = UIStatusBarStyleDefault;

	bool _PreferredStatusBarStyleInited = false;
	if(!_PreferredStatusBarStyleInited)
	{
		// this will be called only on ios7, so no need to handle old enum values
		NSString* style = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIStatusBarStyle"];
		if(style && ([style isEqualToString:@"UIStatusBarStyleBlackOpaque"] || [style isEqualToString:@"UIStatusBarStyleBlackTranslucent"]))
		{
		#if UNITY_PRE_IOS7_SDK
			_PreferredStatusBarStyle = (UIStatusBarStyle)1;
		#else
			_PreferredStatusBarStyle = UIStatusBarStyleLightContent;
		#endif
		}
		_PreferredStatusBarStyleInited = true;
	}

	return UIStatusBarStyleLightContent;
}

void
AddShouldAutorotateToImplIfNeeded(Class targetClass, ShouldAutorotateToFunc impl)
{
	if( UNITY_PRE_IOS6_SDK || !_ios60orNewer )
		class_addMethod( targetClass, @selector(shouldAutorotateToInterfaceOrientation:), (IMP)impl, "c12@0:4i8" );
}

void
AddShouldAutorotateToDefaultImplIfNeeded(Class targetClass)
{
	AddShouldAutorotateToImplIfNeeded(targetClass, &ShouldAutorotateToInterfaceOrientation_DefaultImpl);
}

void
AddOrientationSupportImpl(Class targetClass, SupportedInterfaceOrientationsFunc impl1, ShouldAutorotateFunc impl2, ShouldAutorotateToFunc impl3)
{
	AddShouldAutorotateToImplIfNeeded(targetClass, impl3);

	class_addMethod(targetClass, @selector(supportedInterfaceOrientations), (IMP)impl1, "I8@0:4");
	class_addMethod(targetClass, @selector(shouldAutorotate), (IMP)impl2, "c8@0:4");
}

void
AddOrientationSupportDefaultImpl(Class targetClass)
{
	AddOrientationSupportImpl(	targetClass,
								&SupportedInterfaceOrientations_DefaultImpl,
								&ShouldAutorotate_DefaultImpl,
								&ShouldAutorotateToInterfaceOrientation_DefaultImpl
							 );
}

void
AddStatusBarSupportImpl(Class targetClass, PrefersStatusBarHiddenFunc impl1, PreferredStatusBarStyleFunc impl2)
{
	class_addMethod(targetClass, @selector(prefersStatusBarHidden), (IMP)impl1, "c8@0:4");
	class_addMethod(targetClass, @selector(preferredStatusBarStyle), (IMP)impl2, "i8@0:4");
}
void
AddStatusBarSupportDefaultImpl(Class targetClass)
{
	AddStatusBarSupportImpl(targetClass, &PrefersStatusBarHidden_DefaultImpl, &PreferredStatusBarStyle_DefaultImpl);
}

void
AddViewControllerAllDefaultImpl(Class targetClass)
{
	AddOrientationSupportDefaultImpl(targetClass);
	AddStatusBarSupportDefaultImpl(targetClass);
}

@implementation UnityViewControllerBase

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(void)viewDidLoad{
    [self setupGUI];
    [self loadWebContent];
}

//Inicia o load do conteudo web
-(void)loadWebContent{
    NSArray *boneHierarchyCD = [self loadBonesHierarchyFromCoredata];
    
    //If existe algum dado no cache carrega o propio, else baixa o conteudo do WS
    if (boneHierarchyCD.count > 0) {
        BoneSet *fullBoneLibrary = [[BoneSet alloc] init];
        [self setupBoneSet:fullBoneLibrary forBoneSetCD:boneHierarchyCD.firstObject];
        [self saveBoneHierachyTrees:fullBoneLibrary];
        [self updateInterface];
    }else{
        [self downloadWebContent];
    }
}

//Chama metodos para carregar dados na interface
-(void)updateInterface{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadRightMenuBoneHierarchy" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadFiltroTableView" object:nil];
}

//Baixa conteudo nescessario do WS e manda atualiza-lo na interface
-(void)downloadWebContent{
    [DATA_SRC downloadFullBoneLibraryWithCallback:^(BoneSet *fullBoneLibrary) {
        //Salva em memória
        [self saveBoneHierachyTrees:fullBoneLibrary];
        
        //Cria o model para o CD
        BoneSetCD *skeletonCD = [NSEntityDescription insertNewObjectForEntityForName:@"BoneSetCD" inManagedObjectContext:CD_MANAGER.managedObjectContext];
        [self setupBoneSetCD:skeletonCD forBoneSet:fullBoneLibrary];
        
        //Salva em disco
        [CD_MANAGER saveContext];

        //Atualiza Interface
        [self updateInterface];
    }];
}

//Salva boneSet como hierarquia de ossos na classe Arvore
-(void)saveBoneHierachyTrees:(BoneSet *)boneSet{
    //Cria arvore com ossos
    Arvore *boneHierarchyWithBones = [Arvore new];
    NoArvore *skeletonWithBones = [NoArvore new];
    [self boneSetNodeSetup:boneSet forNode:skeletonWithBones withBones:YES];
    boneHierarchyWithBones.root = skeletonWithBones;
    [Arvore setBoneHierarchyWithBones:boneHierarchyWithBones];
    
    //Cria arvore sem ossos
    Arvore *boneHierarchyWithoutBones = [Arvore new];
    NoArvore *skeletonWithoutBones = [NoArvore new];
    [self boneSetNodeSetup:boneSet forNode:skeletonWithoutBones withBones:NO];
    boneHierarchyWithoutBones.root = skeletonWithoutBones;
    [Arvore setBoneHierarchyWithoutBones:boneHierarchyWithoutBones];
}

//Verifica a nescessecidade de download do boneHierarchy
-(NSArray *)loadBonesHierarchyFromCoredata{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BoneSetCD"
                                              inManagedObjectContext:CD_MANAGER.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [CD_MANAGER.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

//Cria o model para CoreData do Bone Set
-(void)setupBoneSetCD:(BoneSetCD *)boneSetCD forBoneSet:(BoneSet *)boneSet{
    boneSetCD.totalBones = [NSNumber numberWithInteger:boneSet.totalBones];
    boneSetCD.category = boneSet.category;
    boneSetCD.descript = boneSet.descript;
    boneSetCD.boneChildren = boneSet.boneChildren;
    boneSetCD.boneSetChildren = boneSet.boneSetChildren;
    boneSetCD.parentBoneSet = boneSet.parentBoneSet;
    boneSetCD.idBoneSet = [NSNumber numberWithInteger:boneSet.idBoneSet];
    boneSetCD.synonimous = boneSet.synonimous;
    
    BoneSetRelatedQuestions *boneSetRelatedQuestions = [NSEntityDescription insertNewObjectForEntityForName:@"BoneSetRelatedQuestions" inManagedObjectContext:CD_MANAGER.managedObjectContext];
    boneSetRelatedQuestions.relatedQuestions = boneSet.relatedQuestions;
    boneSetCD.relatedQuestions = boneSetRelatedQuestions;
}

//Cria um Bone Set de acordo com o model do Core Data
-(void)setupBoneSet:(BoneSet *)boneSet forBoneSetCD:(BoneSetCD *)boneSetCD{
    boneSet.totalBones = boneSetCD.totalBones.integerValue;
    boneSet.category = boneSetCD.category;
    boneSet.descript = boneSetCD.descript;
    boneSet.boneChildren = boneSetCD.boneChildren;
    boneSet.boneSetChildren = boneSetCD.boneSetChildren;
    boneSet.parentBoneSet = boneSetCD.parentBoneSet;
    boneSet.idBoneSet = boneSetCD.idBoneSet.integerValue;
    boneSet.synonimous = boneSetCD.synonimous;
    boneSet.relatedQuestions = boneSetCD.relatedQuestions.relatedQuestions;
}

//Configura uma boneSet no formato arvore
-(void)boneSetNodeSetup:(BoneSet*)currentBoneSet forNode:(NoArvore*)currentNode withBones:(BOOL)isWithBones
{
    currentNode.title = currentBoneSet.category;
    
    if(isWithBones){
        for (Bone* b in currentBoneSet.boneChildren) {
            NoArvore *newNode = [NoArvore new];
            [self boneNodeSetup:b forNode:newNode];
            [currentNode.subnodes addObject:newNode];
        }
    }
    
    for (BoneSet* bs in currentBoneSet.boneSetChildren) {
        NoArvore *newNode = [NoArvore new];
        [self boneSetNodeSetup:bs forNode:newNode withBones:isWithBones];
        [currentNode.subnodes addObject:newNode];
    }
}

//Configura um bone formato arvore
-(void)boneNodeSetup:(Bone*)currentBone forNode:(NoArvore*)currentBoneNode
{
    currentBoneNode.title = currentBone.name;
    
    for (BonePart* bp in currentBone.boneParts) {
        NoArvore *newNode = [NoArvore new];
        newNode.title = bp.name;
        [currentBoneNode.subnodes addObject:newNode];
    }
}

-(void)setupGUI
{
    //Top Menu - adicionado como subview junto a right menu
    topMenu = [[TopMenuViewController alloc] init];
    
    CGFloat r = 0.3;
    CGFloat g = 0.9;
    CGFloat b = 0.4;
    
    //Draw
    drawView = [[DrawViewController alloc] init];
    drawView.view.alpha = 0;
    [_unityView addSubview:drawView.view];
    [drawView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    preview = [[UIView alloc] initWithFrame:CGRectMake(_unityView.frame.size.width - 95, 40, 70, 70)];
    preview.layer.cornerRadius = preview.frame.size.width/2;
    preview.layer.borderColor = [UIColor whiteColor].CGColor;
    preview.layer.borderWidth = 2;
    preview.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    preview.alpha = 0;
    UIGestureRecognizer *previewTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(previewTap)];
    [preview addGestureRecognizer:previewTap];
    [self.view addSubview:preview];
    
    UIImageView *previewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draw.png"]];
    previewImageView.frame = CGRectMake(preview.frame.size.width/2 - previewImageView.frame.size.width/2, preview.frame.size.height/2 - previewImageView.frame.size.height/2, previewImageView.frame.size.width, previewImageView.frame.size.height);
    [preview addSubview:previewImageView];
    [DrawViewController setPreviewSingleton:preview];
    [_unityView addSubview:preview];
    
    //Close Fullscreen
    closeFullscreen = [[CloseFullscreenViewController alloc] init];
    [closeFullscreen.view setFrame:CGRectMake(0, 12, closeFullscreen.view.frame.size.width, closeFullscreen.view.frame.size.height)];
    closeFullscreen.view.alpha = 0;
    [_unityView addSubview:closeFullscreen.view];
    
    //Right Menu
    rightMenu = [[RightMenuViewController alloc] init];
    [rightMenu.view setFrame:CGRectMake(self.view.frame.size.width - rightMenu.tab.frame.size.width, topMenu.view.frame.size.height, rightMenu.view.frame.size.width, rightMenu.view.frame.size.height)];
    [_unityView addSubview:rightMenu.view];
    [_unityView addSubview:topMenu.view];
    [RightMenuViewController setRightMenuSingleton:rightMenu];
    
    //BreadCrum
    breadView = [[BreadCrumViewController alloc] init];
    [breadView.view setFrame:CGRectMake(10, topMenu.view.frame.size.height + 10, breadView.view.frame.size.width, breadView.view.frame.size.height)];
    [_unityView addSubview:breadView.view];
    [BreadCrumViewController setBreadCrumSingleton:breadView];
    
    //Ballon
    ballonView = [[BallonViewController alloc] init];
    ballonView.view.alpha = 0.0f;
    ballonView.view.frame = CGRectMake(20, 400, ballonView.view.frame.size.width, ballonView.view.frame.size.height);
    [_unityView addSubview:ballonView.view];
    [BallonViewController setBallonSingleton:ballonView];
    
    //Quiz Library
    quizLibraryView = [[QuizLibraryViewController alloc] init];
    quizLibraryView.view.frame = CGRectMake(0, 0, quizLibraryView.view.frame.size.width, quizLibraryView.view.frame.size.height);
    quizLibraryView.view.alpha = 0;
    [_unityView addSubview:quizLibraryView.view];
    [QuizViewController setQuizSingleton:quizLibraryView.quizView];
    
    //Login
    loginView = [[LoginViewController alloc] init];
    loginView.view.alpha = 0;
    [_unityView addSubview:loginView.view];
    
    //Settings
    settingsView = [[SettingsViewController alloc] init];
    settingsView.view.frame = CGRectMake(_unityView.frame.size.width/2 - settingsView.view.frame.size.width/2, _unityView.frame.size.height/2 - settingsView.view.frame.size.height/2, settingsView.view.frame.size.width, settingsView.view.frame.size.height);
    settingsView.view.alpha = 0;
    [_unityView addSubview:settingsView.view];
    
    //Bottom Menu
    bottomMenu = [[BottomMenuViewController alloc] init];
    [bottomMenu.view setFrame:CGRectMake(0, self.view.frame.size.height - bottomMenu.view.frame.size.height, bottomMenu.view.frame.size.width, bottomMenu.view.frame.size.height)];
    [_unityView addSubview:bottomMenu.view];
    [BottomMenuViewController setBottomMenuSingleton:bottomMenu];
    
    //Observers Setup
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginView) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawView) name:@"draw" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullscreen) name:@"fullscreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quizLibrary) name:@"quizLibrary" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(help) name:@"help" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(atlas) name:@"atlas" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settings) name:@"settings" object:nil];
}

-(void)atlas
{
    [UIView animateWithDuration:ANIMATION_TIME delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseIn animations:^{
        quizLibraryView.view.alpha = 0;
        loginView.view.alpha = 0;
        if([[RightMenuViewController rightMenuSingleton]hasAnBoneSelected])
            ballonView.view.alpha = 0.95f;
        topMenu.view.alpha = 1;
        rightMenu.view.alpha = 1;
        breadView.view.alpha = 1;
        settingsView.view.alpha = 0;
        if(drawView.view.alpha != 0){
            drawView.view.alpha = 0;
            preview.alpha = 0;
        }
        
    } completion:nil];
}

-(void)help{
    static int aux = 0;
    [breadView add:@[[NSString stringWithFormat:@"str %d", aux++]]];
}

-(void)settings{
    [UIView animateWithDuration:ANIMATION_TIME delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseIn animations:^{
        settingsView.view.alpha = 1;
        loginView.view.alpha = 0;
    } completion:nil];
}

-(void)loginView{
    [UIView animateWithDuration:ANIMATION_TIME delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseIn animations:^{
        if(loginView.view.alpha == 0){
            loginView.view.alpha = 1;
            settingsView.view.alpha = 0;
        }else {
            loginView.view.alpha = 0;
        }
    } completion:nil];
}

-(void)drawView{
    [UIView animateWithDuration:ANIMATION_TIME delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseIn animations:^{
        drawView.view.alpha = 1;
        preview.alpha = 1;
        quizLibraryView.view.alpha = 0;
        
    } completion:nil];
    
    [self fullscreen];
}

-(void)quizLibrary{
    
    [UIView animateWithDuration:ANIMATION_TIME delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationCurveEaseIn animations:^{
        quizLibraryView.view.alpha = 1;
        loginView.view.alpha = 0;
        topMenu.view.alpha = 0;
        rightMenu.view.alpha = 0;
        breadView.view.alpha = 0;
        ballonView.view.alpha = 0;
        settingsView.view.alpha = 0;
    } completion:nil];
}

-(void)fullscreen
{
    float delay1, delay2;
    
    if([UnityViewControllerBase isFullscreen])
    {
        delay1 = 0;
        delay2 = ANIMATION_TIME;
    }else
    {
        delay1 = ANIMATION_TIME;
        delay2 = 0;
    }
    
    [UIView animateWithDuration:ANIMATION_TIME delay:delay1 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if(topMenu.view.frame.origin.y == 0) //fullscren off to on
        {
            ballonView.view.alpha = 0.0;
            
            topMenu.view.frame = CGRectMake(0, topMenu.view.frame.origin.y - topMenu.view.frame.size.height - 1, topMenu.view.frame.size.width, topMenu.view.frame.size.height);
            
            bottomMenu.view.frame = CGRectMake(0, bottomMenu.view.frame.origin.y + bottomMenu.view.frame.size.height, bottomMenu.view.frame.size.width, bottomMenu.view.frame.size.height);
            
            if([rightMenu isOpen]){
                rightMenu.view.frame = CGRectMake(rightMenu.view.frame.origin.x + rightMenu.view.frame.size.width, rightMenu.view.frame.origin.y, rightMenu.view.frame.size.width, rightMenu.view.frame.size.height);
            }else{
                rightMenu.view.frame = CGRectMake(rightMenu.view.frame.origin.x + rightMenu.tab.frame.size.width, rightMenu.view.frame.origin.y, rightMenu.view.frame.size.width, rightMenu.view.frame.size.height);
            }
            
            breadView.view.frame = CGRectMake(breadView.view.frame.origin.x, breadView.view.frame.origin.y - 100, breadView.view.frame.size.width, breadView.view.frame.size.height);
            
            
        }else //fullscreen on to off
        {
            if(ballonView.stillShowing)
                ballonView.view.alpha = 0.95;
    
            topMenu.view.frame = CGRectMake(0, topMenu.view.frame.origin.y + topMenu.view.frame.size.height + 1, topMenu.view.frame.size.width, topMenu.view.frame.size.height);
            
            bottomMenu.view.frame = CGRectMake(0, bottomMenu.view.frame.origin.y - bottomMenu.view.frame.size.height, bottomMenu.view.frame.size.width, bottomMenu.view.frame.size.height);
            
            if([rightMenu isOpen]){
                rightMenu.view.frame = CGRectMake(rightMenu.view.frame.origin.x - rightMenu.view.frame.size.width, rightMenu.view.frame.origin.y, rightMenu.view.frame.size.width, rightMenu.view.frame.size.height);
            }else{
                rightMenu.view.frame = CGRectMake(rightMenu.view.frame.origin.x - rightMenu.tab.frame.size.width, rightMenu.view.frame.origin.y, rightMenu.view.frame.size.width, rightMenu.view.frame.size.height);
            }
            
            breadView.view.frame = CGRectMake(breadView.view.frame.origin.x, breadView.view.frame.origin.y +    100, breadView.view.frame.size.width, breadView.view.frame.size.height);
            
            if(drawView.view.alpha != 0){
                drawView.mainImage.image = nil;
                preview.alpha = 0;
                drawView.view.alpha = 0;
            }
        }
    } completion:nil];
    
    [UIView animateWithDuration:ANIMATION_TIME delay:delay2 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if(closeFullscreen.view.alpha == 0){
            closeFullscreen.view.alpha = 1;
        }else{
            closeFullscreen.view.alpha = 0;
        }
    } completion:nil];
    
    [UnityViewControllerBase setIsFullscreen:![UnityViewControllerBase isFullscreen]];
}

static BOOL isFullscreen = NO;

+(BOOL)isFullscreen
{
    return isFullscreen;
}

+(void)setIsFullscreen:(BOOL)f
{
    isFullscreen = f;
}

- (void)assignUnityView:(UnityView*)view_
{
	_unityView = view_;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView setAnimationsEnabled:UnityUseAnimatedAutorotation()];

	ScreenOrientation orient = ConvertToUnityScreenOrientation(toInterfaceOrientation, 0);
	[_unityView willRotateTo:orient];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.view layoutSubviews];
	[_unityView didRotate];
	[UIView setAnimationsEnabled:YES];
}

@end

@implementation UnityDefaultViewController
@end


extern "C" void NotifyAutoOrientationChange()
{
	if([UIViewController respondsToSelector:@selector(attemptRotationToDeviceOrientation)])
		[UIViewController attemptRotationToDeviceOrientation];
}

extern "C"
{
    const char *oldName;
    void _BoneTouched (const char* nameOfBone, bool isFaded, bool isHidden)
    {
        NSLog(@"Structure: %s Faded: %d Hidden: %d", nameOfBone, isFaded, isHidden);
        [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if([RightMenuViewController rightMenuSingleton].isOpen){
                [BallonViewController ballonSingleton].view.alpha = 0.0f;
            }else{
                [BallonViewController ballonSingleton].view.alpha = 0.95f;
            }
        } completion:nil]
        ;
        
        if(oldName != nameOfBone)
        {
            [[BallonViewController ballonSingleton] resetBallon];
            oldName = nameOfBone;
        }
         NSString *text = [NSString stringWithUTF8String:nameOfBone];
        
        [[BreadCrumViewController breadCrumSingleton] setBlackAreaClicked:NO];
        [[BreadCrumViewController breadCrumSingleton] add:@[text]];
        
        [[BallonViewController ballonSingleton] setStillShowing:YES];
        [[[BallonViewController ballonSingleton] titleLabel]setText:text];
        [[[RightMenuViewController rightMenuSingleton] boneNameLabel] setText:text];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setText:@"Description"];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setTextColor:[UIColor whiteColor]];
        
        [[RightMenuViewController rightMenuSingleton] setHasAnBoneSelected:YES];
        
        if(isFaded)
        {
            [[[BallonViewController ballonSingleton] opacityButton]setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
            [[[BallonViewController ballonSingleton] othersButton]setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
            [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"half opacity.png"] forState:UIControlStateNormal];
            //[[BallonViewController ballonSingleton] setCountMine:1];
        }
        else if(isHidden)
        {
            [[[BallonViewController ballonSingleton] opacityButton] setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
            [[[BallonViewController ballonSingleton] othersButton]setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
            [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
            //[[BallonViewController ballonSingleton] setCountMine:2];
        }   
        else
        {
            [[[BallonViewController ballonSingleton] opacityButton] setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
            [[[BallonViewController ballonSingleton] othersButton]setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
            [[RightMenuViewController rightMenuSingleton].opacityButton setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        }
    }
    
    void _BlackAreaClicked ()
    {
        [[BallonViewController ballonSingleton] setStillShowing:NO];
        [[BreadCrumViewController breadCrumSingleton] setBlackAreaClicked:YES];
        [BallonViewController ballonSingleton].view.alpha = 0.0f;
        [[[RightMenuViewController rightMenuSingleton] boneNameLabel] setText:@"None"];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setText:@"Select a bone to see its information here."];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [[[RightMenuViewController rightMenuSingleton] boneDescriptionTextView] setTextColor:[UIColor whiteColor]];
        [[RightMenuViewController rightMenuSingleton] setHasAnBoneSelected:NO];
        [[BreadCrumViewController breadCrumSingleton] passButtonSelected];
    }
    
    void _BookMarkChanged(const char* index)
    {
        ;
    }
}