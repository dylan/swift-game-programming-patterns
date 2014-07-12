import XCPlayground
import Cocoa
import Foundation

class Command {
    func execute() -> Void {}
}


class QuitCommand: Command {
    
    override func execute() {
        quit()
    }
    
    func quit() {
        println("Quitting game...")
        game.quit()
    }
}


class FireCommand: Command {
    
    override func execute() {
        fireGun()
    }
    
    
    func fireGun() {
        println("Fired Gun")
    }
}


class MoveLeftCommand: Command {
    
    override func execute() {
        moveLeft()
    }
    
    
    func moveLeft() {
        println("Moved Left")
    }
}


class MoveRightCommand: Command {
    
    override func execute() {
        moveRight()
    }
    
    
    func moveRight() {
        println("Moved Right")
    }
}

class Button {
    var isPressed = false
}

class Gamepad: NSObject {
    let buttonX = Button()
    let buttonY = Button()
    let buttonA = Button()
    let buttonB = Button()
    
    func pressButton(timer:NSTimer) {
        if let button = timer.userInfo as? Button {
            button.isPressed = true
        }
    }
    func releaseButton(timer:NSTimer) {
        if let button = timer.userInfo as? Button {
            button.isPressed = false
        }
    }
}

class InputHandler: NSObject {
    let buttonX: Command
    let buttonY: Command
    let buttonA: Command
    let buttonB: Command
    
    init() {
        buttonX = QuitCommand()
        buttonY = FireCommand()
        buttonA = MoveLeftCommand()
        buttonB = MoveRightCommand()
    }
    
    
    func isPressed(button:Button) -> Bool {
        return button.isPressed
    }
    
    
    func handleInput() -> Void {
        isPressed(gamepad.buttonX)
        if isPressed(gamepad.buttonX) { buttonX.execute() }
        if isPressed(gamepad.buttonY) { buttonY.execute() }
        if isPressed(gamepad.buttonA) { buttonA.execute() }
        if isPressed(gamepad.buttonB) { buttonB.execute() }
    }
}

let gamepad         = Gamepad()
let inputHandler    = InputHandler()

class Game: NSObject {
    var timer: NSTimer?
    var numberOfTicks: Int = 0
    
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: "step", userInfo: nil, repeats: true)
    }
    
    
    func step() {
        inputHandler.handleInput()
        numberOfTicks++
    }
   
    
    func quit() {
        timer?.invalidate()
    }
}


/*
    Using this to fake button presses at different times, change the buttons to
    perform different commands.
*/

NSTimer.scheduledTimerWithTimeInterval(5.0,     target:     gamepad,
                                                selector:   "pressButton:",
                                                userInfo:   gamepad.buttonA,
                                                repeats:    false)

NSTimer.scheduledTimerWithTimeInterval(5.15,    target:     gamepad,
                                                selector:   "releaseButton:",
                                                userInfo:   gamepad.buttonA,
                                                repeats:    false)

NSTimer.scheduledTimerWithTimeInterval(7.0,     target:     gamepad,
                                                selector:   "pressButton:",
                                                userInfo:   gamepad.buttonX,
                                                repeats:    false)

NSTimer.scheduledTimerWithTimeInterval(7.25,    target:     gamepad,
                                                selector:   "releaseButton:",
                                                userInfo:   gamepad.buttonX,
                                                repeats:    false)

let game = Game()
game.start()

// Uncomment the following line to fire it up!
//XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
