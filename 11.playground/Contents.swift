import Cocoa

// Part 1

enum Direction : Hashable {
    case north
    case south
    case northWest
    case southWest
    case northEast
    case southEast
    case none
    
    init(_ string: String) {
        switch string {
        case "n":
            self = .north
        case "s":
            self = .south
        case "nw":
            self = .northWest
        case "sw":
            self = .southWest
        case "ne":
            self = .northEast
        case "se":
            self = .southEast
        default:
            self = .none
        }
    }
    
    var string: String {
        switch self {
        case .north:
            return "n"
        case .south:
            return "s"
        case .northEast:
            return "ne"
        case .northWest:
            return "nw"
        case .southEast:
            return "se"
        case .southWest:
            return "sw"
        case .none:
            return ""
        }
    }
    
    var oppositeDirection: Direction {
        switch self {
        case .north:
            return .south
        case .south:
            return .north
        case .northEast:
            return .southWest
        case .northWest:
            return .southEast
        case .southEast:
            return .northWest
        case .southWest:
            return .northEast
        case .none:
            return .none
        }
    }
    
    func directionWhenMovingIn(_ direction: Direction) -> Direction? {
        if direction == oppositeDirection {
            return Direction.none
        }
        switch self {
        case .north:
            if direction == .southWest {
                return .northWest
            }
            if direction == .southEast {
                return .northEast
            }
        case .south:
            if direction == .northWest {
                return .southWest
            }
            if direction == .northEast {
                return .southEast
            }
        case .northEast:
            if direction == .south {
                return .southEast
            }
            if direction == .northWest {
                return .north
            }
        case .northWest:
            if direction == .south {
                return .southWest
            }
            if direction == .northEast {
                return .north
            }
        case .southEast:
            if direction == .north {
                return .northEast
            }
            if direction == .southWest {
                return .south
            }
        case .southWest:
            if direction == .north {
                return .northWest
            }
            if direction == .southEast {
                return .south
            }
        case .none:
            return direction
        }
        return nil
    }
    
    static var allDirections: [Direction] {
        return [.north,.northEast,.southEast,.south,.southWest,.northWest]
    }
    
    static func directionsFromString(_ string: String) -> [Direction] {
        var directions = [Direction]()
        
        let components = string.components(separatedBy: ",")
        for component in components {
            directions.append(Direction(component))
        }
        
        return directions
    }
    
    var hashValue: Int {
        return string.hashValue
    }
    
    static func ==(lhs: Direction, rhs: Direction) -> Bool {
        return lhs.string == rhs.string
    }
}

struct DirectionPair : Hashable {
    let directionOne: Direction
    let directionTwo: Direction
    
    static func ==(lhs: DirectionPair, rhs: DirectionPair) -> Bool {
        return lhs.directionOne == rhs.directionOne && lhs.directionTwo == rhs.directionTwo
    }
    
    var hashValue: Int {
        return directionOne.hashValue - directionTwo.hashValue
    }
}

extension Array where Element == Direction {
    func contains(directionPair: DirectionPair) -> Bool {
        if count < 2 {
            return false
        }
        for i in 0..<count-1 {
            let one = self[i]
            let two = self[i+1]
            let cursorPair = DirectionPair(directionOne: one, directionTwo: two)
            if directionPair == cursorPair {
                return true
            }
        }
        return false
    }
    func contains(directionPairs: [DirectionPair]) -> Bool {
        var contains = false
        
        for pair in directionPairs {
            let containsPair = self.contains(directionPair: pair)
            contains = contains || containsPair
            if contains {
                break
            }
        }
        
        return contains
    }
}

func distanceFromCenterForMovementString(_ movementString: String) -> Int {
    // Split the movement string into individual moves
    var mutableDirections = Direction.directionsFromString(movementString)
    
    // We can reduce this set of moves by reducing the moves. For example:
    // ne,sw reduces to nothing
    // ne,s reduces to se
    // and so on
    var reducableDictionary = [DirectionPair : Direction]()
    for direction in Direction.allDirections {
        let opposite = direction.oppositeDirection
        reducableDictionary[DirectionPair(directionOne: direction, directionTwo: opposite)] = .none
        
        for otherDirection in Direction.allDirections {
            if let movingDirection = direction.directionWhenMovingIn(otherDirection) {
                reducableDictionary[DirectionPair(directionOne: direction, directionTwo: otherDirection)] = movingDirection
            }
        }
    }
    
    while mutableDirections.contains(directionPairs: Array(reducableDictionary.keys)) {
        if mutableDirections.count < 2 {
            break
        }
        for i in 0..<mutableDirections.count-1 {
            let one = mutableDirections[i]
            let two = mutableDirections[i+1]
            let pair = DirectionPair(directionOne: one, directionTwo: two)
            if let replacement = reducableDictionary[pair] {
                mutableDirections.replaceSubrange(i...i+1, with: [replacement])
                break
            }
        }
        
        while(mutableDirections.contains(.none)) {
            if let indexOfNone = mutableDirections.index(of: .none) {
                mutableDirections.remove(at: indexOfNone)
            }
        }
    }
    
    print(mutableDirections)
    return mutableDirections.count
}

// Examples
//print(distanceFromCenterForMovementString("ne,ne,ne")) // 3
//print(distanceFromCenterForMovementString("ne,ne,sw,sw")) // 0
print(distanceFromCenterForMovementString("ne,ne,s,s")) // 2
//print(distanceFromCenterForMovementString("se,sw,se,sw,sw")) // 3

