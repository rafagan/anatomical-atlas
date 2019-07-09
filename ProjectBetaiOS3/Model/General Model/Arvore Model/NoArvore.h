//
//  NoArvore.h
//  TreeTableView
//
//  Created by Pedro Roberto Nadolny Filho on 11/8/14.
//  Copyright (c) 2014 Pedro Roberto Nadolny Filho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoArvore : NSObject

@property (strong, nonatomic) NSMutableArray *subnodes;
@property (strong, nonatomic) NSString *title;
@property BOOL isOpen;
@property int index;
@property int height;

-(void)print;

@end
