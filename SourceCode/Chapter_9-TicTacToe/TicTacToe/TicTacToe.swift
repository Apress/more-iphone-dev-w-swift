//
//  TicTacToe.swift
//  TicTacToe
//
//  Created by Jayant Varma on 13/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_9
// Book: More iOS Development with Swift, Apress 2015
//


import Foundation

let kTicTacToeSessionID = "oz-tictactoe"
let kTicTacToeArchiveKey = "TicTacToe"

func getDieRoll() -> Int {
    return Int(arc4random() % 1_000_000)
}

let kDiceNotRolled = Int.max

enum GameState:Int {
    case Beginning
    case RollingDice
    case MyTurn
    case YourTurn
    case Interrupted
    case Done
}

enum BoardSpace: Int {
    case UpperLeft = 1000
    case UpperMiddle
    case UpperRight
    case MiddleLeft
    case MiddleMiddle
    case MiddleRight
    case LowerLeft
    case LowerMiddle
    case LowerRight
    case None
}

enum PlayerPiece: Int {
    case Undecided
    case X
    case O
}

enum PacketType: Int {
    case DieRoll
    case Ack
    case Move
    case Reset
}


