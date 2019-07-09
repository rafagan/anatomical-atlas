//
//  QuizLibraryViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 10/12/14.
//
//

#import "QuizLibraryViewController.h"
#import "QuizCardViewController.h"
#import "Categories.h"
#import "UnityViewControllerBase.h"
#import "FiltroTableViewCell.h"
#import "DataSourceManager.h"
#import "RightMenuViewController.h"
#import "BottomMenuViewController.h"
#import "QuizViewController.h"
#import "Arvore.h"
#import "NoArvore.h"
#import "DataSourceManager.h"
#import "CoreDataManager.h"
#import "QuizIdentifier.h"
#import "QuizTestDTO.h"

#define GAP 10

@interface QuizLibraryViewController ()

@end

@implementation QuizLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Configuração para simulação de quizsCards
    [self loadQuizes];
    
    //Configuração da tela de quiz
    self.quizView = [[QuizViewController alloc] init];
    self.quizView.view.frame = CGRectMake(self.view.frame.size.width - self.quizView.view.frame.size.width, 60, self.quizView.view.frame.size.width, self.quizView.view.frame.size.height);
    self.quizView.view.alpha = 0;
    [self.view addSubview:self.quizView.view];
    
    //Configuração de alert para cancelamento do quiz
    cancelQuizAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to cancel the test?"  delegate:self cancelButtonTitle:@"No"  otherButtonTitles:@" Yes" , nil];
    
    //Configuração de observers para métodos
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeQuiz) name:@"closeQuiz"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startQuiz) name:@"startQuiz"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFiltroTableView) name:@"loadFiltroTableView" object:nil];
}

-(void)hideKeyboard{
    [self.quizSearchBar resignFirstResponder];
}

-(void)loadFiltroTableView{
    //Delegate da tableView
    self.filtroTable.dataSource = self;
    self.filtroTable.delegate = self;
    
    //Configuração do conteudo da tableView no formato arvore
    arvore = [[Arvore alloc] init];
    [arvore.root.subnodes addObject:[Arvore boneHierarchyWithoutBones].root];
    [arvore indexTree];
    
    //Carrega o conteudo da tableView
    treeNavigationStack = [[NSMutableArray alloc] initWithObjects:arvore.root, nil];
    [self.filtroTable reloadData];
    [self adjustTableViewHeight];
    [self.spinner stopAnimating];
    self.loadingMapLabel.hidden = YES;
}

-(void)adjustTableViewHeight{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if ([actualNode isEqual:arvore.root]) {
        if(actualNode.subnodes.count * 44 > 497){
            self.filtroTable.frame = CGRectMake(self.filtroTable.frame.origin.x, self.filtroTable.frame.origin.y, self.filtroTable.frame.size.width, 497);
        }else{
            self.filtroTable.frame = CGRectMake(self.filtroTable.frame.origin.x, self.filtroTable.frame.origin.y, self.filtroTable.frame.size.width, actualNode.subnodes.count * 44);
        }
    }else{
        if((actualNode.subnodes.count + 1)* 44 > 497){
            self.filtroTable.frame = CGRectMake(self.filtroTable.frame.origin.x, self.filtroTable.frame.origin.y, self.filtroTable.frame.size.width, 497);
        }else{
            self.filtroTable.frame = CGRectMake(self.filtroTable.frame.origin.x, self.filtroTable.frame.origin.y, self.filtroTable.frame.size.width, (actualNode.subnodes.count + 1)* 44);
        }
    }
}


-(IBAction)loadQuizes{
    [DATA_SRC downloadPublicQuizLibraryWithCallback:^(NSArray *publicQuizLibrary) {
        
        //Remove todas os QuizCards que estão na quiz library
        for(UIView *view in self.scroll.subviews){
            [view removeFromSuperview];
        }
        
        //Configura os novos quiz cards e os adiciona na quizLibrary
        int x, y;
        QuizCardViewController *card;
        for (int i = 0; i < publicQuizLibrary.count; i++) {
            card = [[QuizCardViewController alloc] init];
            x = ((i % 2) * (card.view.frame.size.width + GAP)) + GAP;
            y = ((i / 2) * (card.view.frame.size.height + GAP)) + GAP;
            card.view.frame = CGRectMake(x, y, card.view.frame.size.width, card.view.frame.size.height);
            QuizTestDTO *quizDTO = publicQuizLibrary[i];
            [card setQuiz:quizDTO];
            card.authorLabel.hidden = YES;
            
            //Verifica se esse quiz está baixado ou não
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuizIdentifier" inManagedObjectContext:CD_MANAGER.managedObjectContext];
            [fetchRequest setEntity:entity];
            // Specify criteria for filtering which objects to fetch
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"idQuizTest", quizDTO.idQuizTest];
            [fetchRequest setPredicate:predicate];
            // Specify how the fetched objects should be sorted
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"idQuizTest" ascending:YES];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            
            NSError *error = nil;
            NSArray *fetchedObjects = [CD_MANAGER.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (!fetchedObjects) {
                NSLog(@"FETCH ERROR: %@", error);
            } else if(fetchedObjects.count == 0){
                card.isDownloaded = NO;
                card.statusImage.hidden = YES;
            }else{
                card.isDownloaded = YES;
                card.statusImage.hidden = NO;
            }
            
            [self.scroll addSubview:card.view];
        }
        
        //Ajusta o tamanho da scrollView content de acordo com o número de cards
        [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, y + card.view.frame.size.height + GAP + 50)];
    }];
}

//Mostra a tela de um quiz iniciado
-(void)startQuiz{
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scroll.alpha = 0;
        self.serachView.alpha = 0;
        self.quizView.view.alpha = 1;
        self.view.backgroundColor = [UIColor clearColor];
        self.cancelQuizButton.alpha = 1;
        self.quizTypeSegmentControl.alpha = 0;
        [BottomMenuViewController bottomMenuViewControllerSingleton].view.alpha = 0;
    } completion:nil];
}

//Fecha a tela do quiz e volta para quizLibrary
-(void)closeQuiz{
    [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scroll.alpha = 1;
        self.serachView.alpha = 1;
        self.quizView.view.alpha = 0;
        self.view.backgroundColor = [UIColor blackColor];
        self.cancelQuizButton.alpha = 0;
        self.quizTypeSegmentControl.alpha = 1;
        [BottomMenuViewController bottomMenuViewControllerSingleton].view.alpha = 1;
    } completion:nil];
}

//Callback para botão de fechar quiz
- (IBAction)cancelQuizAction:(id)sender {
    [cancelQuizAlertView show];
}

//Delegate das alertViews
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView isEqual:cancelQuizAlertView] && buttonIndex == 1){
        [UIView animateWithDuration:0.17 delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.scroll.alpha = 1;
            self.cancelQuizButton.alpha = 0;
            self.serachView.alpha = 1;
            self.quizView.view.alpha = 0;
            self.quizTypeSegmentControl.alpha = 1;
            [BottomMenuViewController bottomMenuViewControllerSingleton].view.alpha = 1;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:nil];
    }
}

//Delegate da TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if([actualNode isEqual:arvore.root]){
        return actualNode.subnodes.count;
    }else{
        return actualNode.subnodes.count + 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    
    NoArvore *selectedNode = nil;
    if([actualNode isEqual:arvore.root]){
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
            [self.filtroTable reloadData];
            [self adjustTableViewHeight];
        }
    }else{
        [self.filtroTable reloadData];
        [self adjustTableViewHeight];
    }
}

//DataSource da TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier = @"CellID";
    
    FiltroTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"FiltroTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    NoArvore *actualNode = (NoArvore *)treeNavigationStack.lastObject;
    if([actualNode isEqual:arvore.root]){
        NoArvore *subnode = actualNode.subnodes[indexPath.row];
        cell.titleLabel.text = subnode.title;
        cell.titleLabel.textColor = [UIColor atlasLightGreen];
        cell.indentationLevel = 0;
    }else{
        if(indexPath.row == 0){
            if(treeNavigationStack.count > 2){
                NoArvore *previousSection = treeNavigationStack[treeNavigationStack.count - 2];
                cell.titleLabel.text = [NSString stringWithFormat:@"Return to %@", previousSection.title];
            }else{
                cell.titleLabel.text = @"Return to previous";
            }
            
            cell.titleLabel.textColor = [UIColor atlasBlue];
            cell.indentationLevel = 0;
        }else{
            NoArvore *subnode = actualNode.subnodes[indexPath.row - 1];
            cell.titleLabel.text = [NSString stringWithFormat:@"      %@", subnode.title];
            if(subnode.subnodes.count == 0){
                cell.titleLabel.textColor = [UIColor lightGrayColor];
            }else{
                cell.titleLabel.textColor = [UIColor atlasLightGreen];
            }
        }
    }
    
    cell.indentationWidth = 30;
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    return cell;
}

- (IBAction)refreshQuizLibraryButton:(UIButton *)sender {
    [self loadQuizes];
}

- (void)dealloc {
    [_scroll release];
    [_serachView release];
    [_cancelQuizButton release];
    [_quizTypeSegmentControl release];
    [_quizSearchBar release];
    [_filtroTable release];
    [_refreshQuizLibrary release];
    [super dealloc];
}


@end
