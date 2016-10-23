//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jayant Varma on 13/01/2015.
//  Copyright (c) 2015 OZ Apps. All rights reserved.
//
// Code : Chapter_9
// Book: More iOS Development with Swift, Apress 2015
//

// Note: The graphics are current of a fixed size for iPhone5 only 

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {

    var state: GameState = .Done
    var myDieRoll: Int = 0
    var opponentDieRoll: Int = 0
    var playerPiece: PlayerPiece = .Undecided
    var dieRollRecieved = false
    var dieRollAcknowledged = false
    
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var nearbyBrowser: MCNearbyServiceBrowser!
    
    let xPieceImage = UIImage(named: "X.png")!
    let oPieceImage = UIImage(named: "O.png")!
    
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBAction func gameButtonPressed(sender: AnyObject) {
        println("IBAction gameButtonPressed")
        
        self.dieRollRecieved = false
        self.dieRollAcknowledged = false
        self.gameButton.hidden = true
        
        self.assistant = MCAdvertiserAssistant(serviceType: kTicTacToeSessionID, discoveryInfo: nil, session: self.session)
        self.assistant.start()

        if self.nearbyBrowser == nil {
            self.nearbyBrowser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: kTicTacToeSessionID)
        }
        if self.browser == nil {
            self.browser = MCBrowserViewController(browser: self.nearbyBrowser, session: self.session)
        }
        self.browser.delegate = self
        self.presentViewController(self.browser, animated: true, completion: nil)
        
    }
    
    @IBAction func gameSpacePressed(sender: AnyObject) {
        println("IBAction gameSpacePressed")

        var buttonPressed = sender as! UIButton
        if (self.state == GameState.MyTurn && buttonPressed.imageForState(.Normal) == nil) {
            buttonPressed.setImage(self.playerPiece == PlayerPiece.O ? oPieceImage : xPieceImage, forState: UIControlState.Normal)
            self.feedbackLabel.text = "Opponent's Turn"
            self.state = GameState.YourTurn
        
            var packet = Packet(movePacketWithSpace: BoardSpace(rawValue: buttonPressed.tag)!)
            sendPacket(packet)
            
            //dispatch_async(dispatch_get_main_queue(), {
                self.checkForGameEnd()
            //})
        }
    }

    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("ViewDidLoad")
        
        self.myDieRoll = kDiceNotRolled
        self.opponentDieRoll = kDiceNotRolled
        
        self.peerID = MCPeerID(displayName: "MyName")

        self.session = MCSession(peer: peerID)
        session.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.session.disconnect()
        self.session.delegate = nil
        self.peerID = nil
        
        self.browser = nil
        self.nearbyBrowser = nil
        self.assistant = nil
    }

    //MARK: - Game Specific Actions
    func startNewGame() {
        println("Start New Game")
        self.resetBoard()
        self.sendDieRoll()
    }

    func resetDieState() {
        println("resetDieState")
        self.dieRollRecieved = false
        self.dieRollAcknowledged = false
        self.myDieRoll = kDiceNotRolled
        self.opponentDieRoll = kDiceNotRolled
    }

    func startGame() {
        println("START GAME CALLED, \(self.myDieRoll), \(self.opponentDieRoll)")
            if self.myDieRoll == self.opponentDieRoll {
                self.myDieRoll = kDiceNotRolled
                self.opponentDieRoll = kDiceNotRolled
                self.sendDieRoll()
                self.playerPiece = .Undecided
            } else if self.myDieRoll < self.opponentDieRoll {
                self.state = .YourTurn
                self.playerPiece = .X
                self.feedbackLabel.text = "Opponent's Turn"
            } else if self.myDieRoll > self.opponentDieRoll {
                self.state = .MyTurn
                self.playerPiece = .O
                self.feedbackLabel.text = "Your Turn"
            }
    }
    
    func sendPacket(packet: Packet) {
        println("sendPacket \(packet.type.rawValue)")
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(packet, forKey: kTicTacToeArchiveKey)
        archiver.finishEncoding()
        
        //println(">> sending Packet: \(packet.type.rawValue), \(packet.dieRoll), \(packet.space.rawValue)")
        
        var error:NSError? = nil
        self.session.sendData(data, toPeers: self.session.connectedPeers, withMode: .Reliable, error: &error)
            
        if error != nil {
            println("Error sending data: \(error?.localizedDescription)")
        }
    }
    
    func sendDieRoll(){
        println("sendDieRoll")
        var rollPacket: Packet
        self.state = .RollingDice
        if self.myDieRoll == kDiceNotRolled {
            rollPacket = Packet(type: .DieRoll)
            self.myDieRoll = rollPacket.dieRoll
        } else {
            rollPacket = Packet(dieRollPacketWithRoll: self.myDieRoll)
        }
        
        self.sendPacket(rollPacket)
    }
    
    func checkForGameEnd() {
        println("CheckForGameEnd")
        var moves: Int = 0
        var i: Int = 0
        var currentButtonImages:[UIImage!] = Array(count: 9, repeatedValue: nil)
        var winningImage: UIImage?
        
        currentButtonImages.reserveCapacity(9)
        
        for i = BoardSpace.UpperLeft.rawValue; i <= BoardSpace.LowerRight.rawValue; i++ {
            var oneButton = self.view.viewWithTag(i) as! UIButton
            if oneButton.imageForState(.Normal) != nil {
                moves++
            }
            currentButtonImages[i - BoardSpace.UpperLeft.rawValue] = oneButton.imageForState(.Normal)
        }
        
        //Top Row
        
        if let aRow = compareImages(currentButtonImages, index1:0, index2:1, index3:2) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 3, index2: 4, index3: 5) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 6, index2: 7, index3: 8) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 0, index2: 3, index3: 6) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 1, index2: 4, index3: 7) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 2, index2: 5, index3: 8) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 0, index2: 4, index3: 8) {
            winningImage = aRow
        } else if let aRow = compareImages(currentButtonImages, index1: 2, index2: 4, index3: 6) {
            winningImage = aRow
        }
        
        if winningImage != nil {
            if winningImage == self.xPieceImage {
                if self.playerPiece == .X {
                    self.feedbackLabel.text = "You Won!"
                    self.state = GameState.Done
                } else {
                    self.feedbackLabel.text = "Opponent Won!"
                    self.state = GameState.Done
                }
            } else if winningImage == self.oPieceImage {
                if self.playerPiece == .O {
                    self.feedbackLabel.text = "You Won"
                    self.state = GameState.Done
                } else {
                    self.feedbackLabel.text = "Opponent Won!"
                    self.state = GameState.Done
                }
            } else {
                if moves > 9 {
                    self.feedbackLabel.text = "Cat Wins!!"
                    self.state = GameState.Done
                }
            }
        }
            
        if self.state == .Done {
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "startNewGame", userInfo: nil, repeats: false)
        }
        
    }
    
    func compareImages(buttons:[UIImage!], index1: Int, index2: Int, index3: Int) -> UIImage! {
        var one:UIImage? = buttons[index1]
        var two:UIImage? = buttons[index2]
        var three:UIImage? = buttons[index3]
        var result: UIImage!
        
        if one != nil {
            if one == two && one == three {
                result = one
            }
        }
        return result
    }
    
    func resetBoard() {
        println("resetBoard")
        var i:Int = 0
        for i = BoardSpace.UpperLeft.rawValue ; i <= BoardSpace.LowerRight.rawValue ;i++ {
            var aButton = self.view.viewWithTag(i) as! UIButton
            aButton.setImage(nil, forState: .Normal)
        }
        self.feedbackLabel.text = ""
        self.sendPacket(Packet(type: .Reset))
        self.playerPiece = .Undecided
    }
    
    //MARK: - MCBrowserViewController Methods
    func dismissController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        self.dismissController()

        self.browser.delegate = nil
        self.browser = nil
        
        self.assistant.stop()
        self.assistant = nil
        
        self.nearbyBrowser.stopBrowsingForPeers()
        self.nearbyBrowser = nil

        dispatch_async(dispatch_get_main_queue(), {
            self.startNewGame()
        })
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        self.dismissController()
        self.gameButton.hidden = false
    }
    
    //MARK: - MCSession delegate functions
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        if state == .NotConnected {
            println(">>> NOT CONNECTED")
            //dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "Error connecting", message: "Unable to connect to peer", preferredStyle: .Alert)
                var cancelAction = UIAlertAction(title: "Bummer", style: .Destructive, handler: {
                    action in
                    self.resetBoard()
                    self.gameButton.hidden = false
                    })
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            //})
        }
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        
        if let packet = unarchiver.decodeObjectForKey(kTicTacToeArchiveKey) as? Packet{
            println("We got : \(packet.type.rawValue), urDie:\(packet.dieRoll), myDie:\(self.myDieRoll), \(packet.space.rawValue), \(self.state.rawValue)")
            
            switch packet.type!{
            case .DieRoll:
                println("<<DIEROLL>>")
                self.opponentDieRoll = packet.dieRoll
                println(">> Opponent's DieRoll: \(opponentDieRoll)/\(self.opponentDieRoll), from \(packet.dieRoll)")
                
                //dispatch_async(dispatch_get_main_queue(), {
                    var ack = Packet(ackPacketWithRoll: self.opponentDieRoll)
                    self.sendPacket(ack)
                    self.dieRollRecieved = true
                //})
            case .Ack:
                println("<<ACK>>")
                if packet.dieRoll != self.myDieRoll {
                    println(">> Ack packet does not match your die roll...(mine: \(self.myDieRoll), send: \(packet.dieRoll))")
                }
                self.dieRollAcknowledged = true
            case .Move:
                println("<<MOVE>>")
                dispatch_async(dispatch_get_main_queue(), {
                    var aButton = self.view.viewWithTag(packet.space.rawValue) as! UIButton
                    aButton.setImage(self.playerPiece == .O ? self.xPieceImage:self.oPieceImage, forState: UIControlState.Normal)
                    self.state = GameState.MyTurn
                    self.feedbackLabel.text = "Your Turn"
                    self.checkForGameEnd()
                    println("Check the label now!! it should be Your Turn and the state should be \(self.state.rawValue)")
                })
            case PacketType.Reset:
                println("<<RESET>>")
                dispatch_async(dispatch_get_main_queue(), {
                    if self.state == GameState.Done {
                        self.startNewGame()
                     } else {
                            self.resetDieState()
                     }
                 })
            default:
                println("<<DEFAULT!!??>>")
                break
            }
            
            if self.dieRollRecieved == true && self.dieRollAcknowledged == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.startGame()
                })
            }
        }
    }

    // UNIMPLEMENTED Stuff
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        //
    }
    
   
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        //
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        //
    }
    
}

