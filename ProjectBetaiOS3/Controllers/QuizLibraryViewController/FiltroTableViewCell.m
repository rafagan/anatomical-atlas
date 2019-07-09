//
//  FiltroTableViewCell.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 12/11/14.
//
//

#import "FiltroTableViewCell.h"

@implementation FiltroTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [_titleLabel release];
    [super dealloc];
}

- (IBAction)switchAction:(UISwitch *)sender {
    
}

@end
