//
//  RIVPlayer.m
//  Connect Four
//
//  Created by Brian Radebaugh on 5/5/14.
//  Copyright (c) 2014 Brian Radebaugh. All rights reserved.
//

#import "RIVPlayer.h"
#import "RIVGamePiece.h"

@implementation RIVPlayer

- (instancetype)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color andPieceCount:(NSInteger)count
{
    self = [super init];
    if (self) {
        self.color = color;
        NSMutableArray *tempPieces = [NSMutableArray new];
        for (NSInteger i = 0; i < count; i++) {
            RIVGamePiece *tempPiece = ([color isEqual:[UIColor blackColor]]) ? [RIVGamePiece blackPiece] : [RIVGamePiece redPiece];
            [tempPieces addObject:tempPiece];
        }
        self.gamePieces = tempPieces;
    }
    return self;
}

@end
