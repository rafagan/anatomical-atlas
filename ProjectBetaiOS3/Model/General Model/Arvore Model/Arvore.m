//
//  Arvore.m
//  TreeTableView
//
//  Created by Pedro Roberto Nadolny Filho on 11/8/14.
//  Copyright (c) 2014 Pedro Roberto Nadolny Filho. All rights reserved.
//

#import "Arvore.h"
#import "NoArvore.h"

@implementation Arvore
{
    int aux;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.root = [[NoArvore alloc] init];
        _root.isOpen = YES;
    }
    return self;
}

-(int)numberOfOpenSubnodes{
    return [self numberOfOpenSubnodesInNode:self.root];
}

-(int)numberOfOpenSubnodesInNode:(NoArvore *)node{
    
    int result = 0;
    
    for (NoArvore *subnode in node.subnodes) {
        result++;
        if(subnode.isOpen){
            result += [self numberOfOpenSubnodesInNode:subnode];
        }
    }
    
    return result;
}

-(NoArvore *)nodeForIndex:(int)index{
    for(NoArvore* node in self.root.subnodes){
            if(node.index == index){
                return node;
            } else{
                if(node.isOpen){
                    NoArvore* n =[self subnodeOfIndex:index inNode:node];
                    if(n == nil) continue;
                    else {
                        return n;
                    }
                }
            }
    }
    return NULL;
}

-(NoArvore *)subnodeOfIndex:(int)index inNode:(NoArvore*)node{
    for(NoArvore* subnode in node.subnodes){
            if(subnode.index == index){
                return subnode;
            } else{
                if(subnode.isOpen){
                    NoArvore* n =[self subnodeOfIndex:index inNode:subnode];
                    if(n == nil) continue;
                    else return n;
                }
            }
    }
    return NULL;
}

-(void)indexTree{
    self.root.index = 0;
    self.root.height = 0;
    aux = 1;
    [self indexSubnodesOfNode:self.root];
}

-(void)indexSubnodesOfNode: (NoArvore *)node{
    for(NoArvore *subnode in node.subnodes){
        subnode.height = node.height + 1;
        subnode.index = aux;
        aux++;
        if(subnode.isOpen){
            [self indexSubnodesOfNode:subnode];
        }
    }
}

-(void)printTree{
    [self printNode:self.root];
}

-(void)printNode:(NoArvore *)node{
    NSLog(@"%@", node.title);
    for(NoArvore* subnode in node.subnodes){
        [self printNode:subnode];
    }
}

//Singleton para acesso a hierarquia de ossos

static Arvore *boneHierarchyWithBones = nil;
static Arvore *boneHierarchyWithoutBones = nil;

+(Arvore *)boneHierarchyWithBones{
    if(!boneHierarchyWithBones){
        boneHierarchyWithBones = [Arvore new];
    }
    
    return boneHierarchyWithBones;
}

+(void)setBoneHierarchyWithBones:(Arvore *)bh{
    boneHierarchyWithBones = bh;
}

+(Arvore *)boneHierarchyWithoutBones{
    if(!boneHierarchyWithoutBones){
        boneHierarchyWithoutBones = [Arvore new];
    }
    
    return boneHierarchyWithoutBones;
}

+(void)setBoneHierarchyWithoutBones:(Arvore *)bh{
    boneHierarchyWithoutBones = bh;
}

@end
