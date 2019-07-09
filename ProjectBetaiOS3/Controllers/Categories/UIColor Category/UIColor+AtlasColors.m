//
//  UIColor+AtlasColors.m
//  Unity-iPhone
//
//  Created by Pedro Roberto Nadolny Filho on 9/27/14.
//
//

#import "UIColor+AtlasColors.h"

@implementation UIColor (AtlasColors)

+(UIColor *)colorForHexCode:(NSString *)hexCode{
    int red = [self valueForHexDigit:[hexCode characterAtIndex:0] withSignifanceOf:1] + [self valueForHexDigit:[hexCode characterAtIndex:1] withSignifanceOf:0];
    int green = [self valueForHexDigit:[hexCode characterAtIndex:2] withSignifanceOf:1] + [self valueForHexDigit:[hexCode characterAtIndex:3] withSignifanceOf:0];
    int blue = [self valueForHexDigit:[hexCode characterAtIndex:4] withSignifanceOf:1] + [self valueForHexDigit:[hexCode characterAtIndex:5] withSignifanceOf:0];
    
    int alpha = 255;
    
    if(hexCode.length == 8){
        alpha = [self valueForHexDigit:[hexCode characterAtIndex:6] withSignifanceOf:1] + [self valueForHexDigit:[hexCode characterAtIndex:7] withSignifanceOf:0];
    }
    
    return [UIColor colorWithRed:(CGFloat)red/255  green:(CGFloat)green/255 blue:(CGFloat)blue/255 alpha:(CGFloat)alpha/255];
}

+(int)valueForHexDigit:(char)digit withSignifanceOf:(int) significance{
    
    int val;
    
    if(digit == '0'){
        val = 0;
    }else if(digit == '1'){
        val = 1;
    }else if(digit == '2'){
        val = 2;
    }else if(digit == '3'){
        val = 3;
    }else if(digit == '4'){
        val = 4;
    }else if(digit == '5'){
        val = 5;
    }else if(digit == '6'){
        val = 6;
    }else if(digit == '7'){
        val = 7;
    }else if(digit == '8'){
        val = 8;
    }else if(digit == '9'){
        val = 9;
    }else if(digit == 'A'){
        val = 10;
    }else if(digit == 'B'){
        val = 11;
    }else if(digit == 'C'){
        val = 12;
    }else if(digit == 'D'){
        val = 13;
    }else if(digit == 'E'){
        val = 14;
    }else if(digit == 'F'){
        val = 15;
    }
    
    return val * pow(16, significance);
}

+(UIColor *) atlasLightGreen{
    return [UIColor colorForHexCode:@"38FF6C"];
}

+(UIColor *) atlasBlue{
    return [UIColor colorForHexCode:@"387FE1"];
}

@end
