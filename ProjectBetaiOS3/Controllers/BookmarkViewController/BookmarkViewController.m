//
//  BookmarkViewController.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/10/14.
//
//

#import "BookmarkViewController.h"
#import "Bookmark.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bookmarkArray = [[NSMutableArray alloc] init];
    
    addAlert = [[UIAlertView alloc] initWithTitle:@"New Bookmark"  message:@"Name of new bookmark" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [addAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
}

- (void)dealloc {
    [_bookmarkTableView release];
    [_add release];
    [_edit release];
    [_restore release];
    [super dealloc];
}

-(IBAction)addBookmark:(UIButton *)sender {
    [self.bookmarkTableView setEditing:NO animated:YES];
    [addAlert show];
}

-(IBAction)editBookmark:(UIButton *)sender {
    [self.bookmarkTableView setEditing:!self.bookmarkTableView.editing animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookmarkArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    Bookmark *bookmark = (Bookmark *)[self.bookmarkArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = bookmark.title;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.bookmarkArray removeObjectAtIndex:indexPath.row];
    [self.bookmarkTableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        Bookmark *bookmark = [[Bookmark alloc] init];
        [bookmark setTitle:[alertView textFieldAtIndex:0].text];
        [bookmark setBookmarkId:self.bookmarkArray.count];
        [self.bookmarkArray addObject:bookmark];
        [self.bookmarkTableView reloadData];
        [alertView textFieldAtIndex:0].text = @"";
        
        int parseInt = (int)self.bookmarkArray.count - 1;
        NSString *tmp = [NSString stringWithFormat:@"%d", parseInt];
        const char *index = [tmp UTF8String];
        
        UnitySendMessage("AppManager", "AddBookmark", index);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    int parseInt = (int)indexPath.row;
    NSString *tmp = [NSString stringWithFormat:@"%d", parseInt];
    const char *index = [tmp UTF8String];
    //NSLog(@"%s", index);
    
    UnitySendMessage("AppManager", "SetBookmark", index);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissBookmark" object:nil];
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

static BookmarkViewController *b = nil;

+(BookmarkViewController *)bookmarkSingleton
{
    if(!b){
        b = [[BookmarkViewController alloc] init];
    }
    
    return b;
}

+(void)setBookmarkSingleton:(BookmarkViewController *)bookMark
{
    b = bookMark;
}

@end