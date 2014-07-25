//
//  RIVGameBoard.m
//  Connect Four
//
//  Created by Brian Radebaugh on 5/5/14.
//  Copyright (c) 2014 Brian Radebaugh. All rights reserved.
//

#import "RIVGameBoard.h"
#import "RIVPlayer.h"
#import "RIVGamePiece.h"
#import "RIVGridLocation.h"

const NSInteger numberOfRows = 6;
const NSInteger numberOfColumns = 7;

typedef NS_ENUM (NSInteger, SearchDirection) {
    SearchDirectionWest = 1,
    SearchDirectionEast,
    SearchDirectionSouth,
    SearchDirectionNorth,
    SearchDirectionSouthWest,
    SearchDirectionNorthEast,
    SearchDirectionSouthEast,
    SearchDirectionNorthWest,
    SearchDirectionNone
};

@implementation RIVGameBoard

- (instancetype)initWithTwoPlayers
{
    self = [super init];
    if (self) {
        // Make and Add Players
        RIVPlayer *firstPlayer = [[RIVPlayer alloc] initWithColor:RIVGamePieceColorBlack andPieceCount:21];
        RIVPlayer *secondPlayer = [[RIVPlayer alloc] initWithColor:RIVGamePieceColorRed andPieceCount:21];
        self.players = @[firstPlayer, secondPlayer];
        
        // Randomly Choose Who Goes First
        NSInteger playerToActIndex = arc4random_uniform(self.players.count);
        self.playerToAct = self.players[playerToActIndex];
    }
    return self;
}


#pragma mark - Helper Methods


- (RIVGameBoardPlayState)playGamePieceonColumn:(NSInteger)column fromPlayer:(RIVPlayer *)player
{
    if (!player || !player.unplayedPieces.count || column < 0 || column >= numberOfColumns) return RIVGameBoardPlayStateNotPlayable;
    
    RIVGridLocation *playedLocation = [self nextAvailableLocationForColumn:column];
    if (!playedLocation) return RIVGameBoardPlayStateNotPlayable;
    
    playedLocation.piece = player.unplayedPieces.lastObject;
    [player.unplayedPieces removeLastObject];
    
    BOOL didWin = [self playedPieceWinsGameAtLocation:playedLocation];
    return (didWin) ? RIVGameBoardPlayStateWinningMove : RIVGameBoardPlayStatePlayed;
}

- (RIVGridLocation *)nextAvailableLocationForColumn:(NSInteger)column
{
    RIVGridLocation *tempGridLocation;
    NSInteger row = 0;
    while (row < numberOfRows) {
        tempGridLocation = self.grid[row][column];
        if (!tempGridLocation.piece) return tempGridLocation;
        row++;
    }
    
    return nil;
}

- (BOOL)playedPieceWinsGameAtLocation:(RIVGridLocation *)playedPieceLocation
{
    RIVGridLocation *searchLocation = playedPieceLocation;
    SearchDirection currentDirection = SearchDirectionWest;
    BOOL shouldChangeDirection = NO;
    NSInteger searchRow = searchLocation.row + [self horizontalDeltaFor:currentDirection];
    NSInteger searchColumn = searchLocation.column + [self verticalDeltaFor:currentDirection];
    NSInteger piecesInARow = 1;
    
    while (piecesInARow < 4 || currentDirection == SearchDirectionNone) {
        if (searchRow < 0 || searchRow >= numberOfRows || searchColumn < 0 || searchColumn >= numberOfColumns) {
            shouldChangeDirection = YES;
        } else {
            searchLocation = self.grid[searchRow][searchColumn];
            if (playedPieceLocation.piece.color == searchLocation.piece.color) piecesInARow++;
                else shouldChangeDirection = YES;
        }
        
        if (shouldChangeDirection) {
            currentDirection++;
            if (currentDirection % 2 != 0) piecesInARow = 1;
            searchLocation = playedPieceLocation;
            shouldChangeDirection = NO;
        }
        
        searchRow = searchLocation.row + [self horizontalDeltaFor:currentDirection];
        searchColumn = searchLocation.column + [self verticalDeltaFor:currentDirection];
    }
    
    return (piecesInARow >= 4) ? YES : NO;
}

- (NSInteger)horizontalDeltaFor:(SearchDirection)direction
{
    switch (direction) {
        case SearchDirectionWest:
        case SearchDirectionNorthWest:
        case SearchDirectionSouthWest:
            return -1;
        case SearchDirectionEast:
        case SearchDirectionNorthEast:
        case SearchDirectionSouthEast:
            return 1;
        case SearchDirectionNorth:
        case SearchDirectionSouth:
        case SearchDirectionNone:
        default:
            return 0;
    }
}

- (NSInteger)verticalDeltaFor:(SearchDirection)direction
{
    switch (direction) {
        case SearchDirectionNorth:
        case SearchDirectionNorthWest:
        case SearchDirectionNorthEast:
            return 1;
        case SearchDirectionSouth:
        case SearchDirectionSouthWest:
        case SearchDirectionSouthEast:
            return -1;
        case SearchDirectionWest:
        case SearchDirectionEast:
        case SearchDirectionNone:
        default:
            return 0;
    }
}


#pragma mark - Lazy Instantiation


//            (7) Columns
//
//    5                         (6)
//    4                          R
//    3                          o
//    2                          w
//    1                          s
//    0, 1, 2, 3, 4, 5, 6
- (NSArray *)grid
{
    if (!_grid) {
        NSMutableArray *rows = [NSMutableArray new];
        NSMutableArray *columns;
        RIVGridLocation *gridLocation;
        
        for (NSInteger row = 0; row < numberOfRows; row++) {
            columns = [NSMutableArray new];
            for (NSInteger column = 0; column < numberOfColumns; column++) {
                gridLocation = [[RIVGridLocation alloc] initWithRow:row andColumn:column];
                [columns addObject:gridLocation];
            }
            [rows addObject:[columns copy]];
        }
        _grid = [rows copy];
    }
    return _grid;
}

- (NSArray *)players
{
    if (!_players) _players = [NSArray new];
    return _players;
}

@end