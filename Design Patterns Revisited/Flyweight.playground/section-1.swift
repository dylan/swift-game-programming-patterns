import XCPlayground

import Cocoa
import Foundation
import SpriteKit

typealias Sprite = SKTexture

/*
    Adjust this to change the size of the map made.
    NOTE: These changes are exponential!
*/
let MAP_SIDE_LENGTH = 128
let MAP_TILE_SIZE = 16

let MAP_WIDTH = MAP_SIDE_LENGTH/MAP_TILE_SIZE
let MAP_HEIGHT = MAP_SIDE_LENGTH/MAP_TILE_SIZE


enum TerrainSprite:String {
    case
        Grass   = "grass",
        Hill    = "hill",
        River   = "river"
}


class Terrain {
    let movementCost:Int
    let isWater:Bool
    let texture:Sprite

    init(movementCost:Int, isWater:Bool, texture:TerrainSprite) {
        self.movementCost = movementCost
        self.isWater = isWater
        self.texture = SKTexture(imageNamed: texture.toRaw())
    }
    
}


class World {
    var tiles = [[Terrain]]()
    
    let grassTerrain = Terrain(movementCost: 1, isWater: false, texture: TerrainSprite.Grass)
    let hillTerrain = Terrain(movementCost: 3, isWater: false, texture: TerrainSprite.Hill)
    let riverTerrain = Terrain(movementCost: 2, isWater: true, texture: TerrainSprite.River)
    
    init() {
        generateTerrain()
    }
    

    func generateTerrain() {

        for x in 0 ..< MAP_WIDTH {
            var column = [Terrain]()

            for y in 0 ..< MAP_HEIGHT {
                // Sprinkle some hills.
                var tileType = arc4random_uniform(3) == 0 ? hillTerrain : grassTerrain
                column += tileType
            }
            
            tiles.append(column)
        }
        
        // Lay a river
        let x = Int(arc4random_uniform(UInt32(MAP_WIDTH)))

        var column = [Terrain]()
        for var y = 0; y < MAP_HEIGHT; y++ {
            column += riverTerrain
        }
        tiles.insert(column, atIndex: x)
    }
    

    func getTile(x:Int, y:Int) -> Terrain {
        return tiles[x][y]
    }
}

class Game {
    let view = SKView(frame: NSRect(x: 0, y: 0, width: MAP_SIDE_LENGTH, height: MAP_SIDE_LENGTH))
    let scene = SKScene()
    let world = World()
    
    
    func start() {
        view.showsNodeCount = true
        scene.size = view.bounds.size
        view.presentScene(scene)

        var x_index = 0
        for row in world.tiles {
            var y_index = 0
            for tile:Terrain in row  {
                let newNode = SKSpriteNode(texture: tile.texture)
                let tileHeight = CGFloat(MAP_TILE_SIZE)
                let tileWidth = CGFloat(MAP_TILE_SIZE)
                let offset = CGPoint(
                    x: tileHeight * CGFloat(x_index) + tileHeight / 2,
                    y: tileWidth * CGFloat(y_index) + tileWidth / 2)
                newNode.position = offset
                scene.addChild(newNode)
                y_index++
            }
            x_index++
        }
    }
}

// Set up so we can see the map.
let game: Game = Game()
game.start()

// Get the cost of the bottom left tile.
let cost = game.world.getTile(0, y: 0).movementCost


func say(what:String) {
    println("It's a \(what) tile!")
}

switch cost {
    case 1:
        say("grass")
    case 2:
        say("water")
    case 3:
        say("hill")
    default:
        say("foreign")
}
 
XCPShowView("Main View", game.view)
