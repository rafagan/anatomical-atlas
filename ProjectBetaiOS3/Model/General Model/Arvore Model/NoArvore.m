//
//  NoArvore.m
//  TreeTableView
//
//  Created by Pedro Roberto Nadolny Filho on 11/8/14.
//  Copyright (c) 2014 Pedro Roberto Nadolny Filho. All rights reserved.
//

#import "NoArvore.h"

@implementation NoArvore

- (instancetype)init
{
    self = [super init];
    if (self) {
        _subnodes = [[NSMutableArray alloc] init];
        _title = [[NSString alloc] init];
        _isOpen = false;
        _index = 0;
        _height = 0;
    }
    return self;
}

-(void)print{
    if(self.isOpen){
        for(NoArvore *subnode in self.subnodes){
            [subnode print];
        }
    }
}

@end
