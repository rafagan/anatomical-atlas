//
//  Arvore.h
//  TreeTableView
//
//  Created by Pedro Roberto Nadolny Filho on 11/8/14.
//  Copyright (c) 2014 Pedro Roberto Nadolny Filho. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoArvore;

@interface Arvore : NSObject

@property (strong, nonatomic) NoArvore *root;

-(int)numberOfOpenSubnodes;
-(NoArvore *)nodeForIndex:(int)index;
-(void)indexTree;
-(void)printTree;

//Singletons get/set
+(Arvore *)boneHierarchyWithBones;
+(void)setBoneHierarchyWithBones:(Arvore *)bh;

+(Arvore *)boneHierarchyWithoutBones;
+(void)setBoneHierarchyWithoutBones:(Arvore *)bh;

@end
