//
//  Packet.swift
//  TicTacToe
//
//  Created by Jayant Varma on 13/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_9
// Book: More iOS Development with Swift, Apress 2015
//


import UIKit

//@objc(Packet)

class Packet: NSObject , NSCoding {
   
    var type:PacketType!
    var dieRoll: Int!
    var space: BoardSpace!
    
    //MARK: - Initializers
    override init() {
        self.type = .Reset
        self.dieRoll = 0
        self.space = .None
    }
    
    convenience init(type: PacketType, dieRoll aDieRoll: Int, space aBoardSpace: BoardSpace){
        self.init()
        self.type = type
        self.dieRoll = aDieRoll
        self.space = aBoardSpace
    }
    
    convenience init(dieRollPacketWithRoll aDieRoll: Int) {
        self.init(type: .DieRoll, dieRoll: aDieRoll, space: .None)
        println(">> ROLL: \(aDieRoll)")
    }
    
    convenience init(movePacketWithSpace aBoardSpace: BoardSpace) {
        self.init(type: .Move, dieRoll: 0, space: aBoardSpace)
    }
    
    convenience init(ackPacketWithRoll aDieRoll: Int) {
        self.init(type: .Ack, dieRoll: aDieRoll, space: .None)
        println(">> ACK: \(dieRoll)")
    }

    convenience init(type: PacketType) {
        if type == .DieRoll {
            var aDieRoll = getDieRoll()
            self.init(type: .DieRoll, dieRoll: aDieRoll, space: .None)
            println(">> GEN: \(aDieRoll)")
        }else{
            self.init(type: .Reset, dieRoll: 0, space: .None)
        }
    }
    
    
    //MARK: - NSCoding (Archiving) Methods
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.type = PacketType(rawValue: aDecoder.decodeIntegerForKey("type") ?? PacketType.Reset.rawValue)
        self.dieRoll = aDecoder.decodeIntegerForKey("dieRoll")
        self.space = BoardSpace(rawValue: aDecoder.decodeIntegerForKey("space")  ?? BoardSpace.None.rawValue)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.type.rawValue, forKey: "type")
        aCoder.encodeInteger(self.dieRoll, forKey: "dieRoll")
        aCoder.encodeInteger(self.space.rawValue, forKey: "space")
    }
    
}
