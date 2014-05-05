//
//  RIVGameBoard.h
//  Connect Four
//
//  Created by Brian Radebaugh on 5/5/14.
//  Copyright (c) 2014 Brian Radebaugh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RIVGamePiece;

@interface RIVGameBoard : NSObject

@property (strong, nonatomic) NSArray *pieces;
@property (strong, nonatomic) NSArray *players; // of RIVPlayer
@property (strong, nonatomic) NSArray *spots;

- (instancetype)initWithPlayers;

- (void)playPiece:(RIVGamePiece *)gamePiece atIndex:(NSIndexPath *)indexPath;

@end