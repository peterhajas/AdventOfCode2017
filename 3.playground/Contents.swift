//: Playground - noun: a place where people can play

import Cocoa

struct Location : Equatable {
    let x: Int
    let y: Int
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func north() -> Location {
        return Location(x: x, y: y-1)
    }
    
    func south() -> Location {
        return Location(x: x, y: y+1)
    }
    
    func east() -> Location {
        return Location(x: x+1, y: y)
    }
    
    func west() -> Location {
        return Location(x: x-1, y: y)
    }
}

func coordinateForSquare(_ square: Int) -> Location {
    // First find the x and y locations of the square. We can find the nearest
    // perfect square to the number to get close. This will be the lowest-right
    // value

    // Early-out
    if square == 1 {
        return Location(x: 0, y: 0)
    }
    // From the puzzle, we're interested in every *other* perfect square
    // That is, sqrt(nearestSquare)%2 == 1
    // You can see with this extension of the puzzle's diagram:
    // 1 4 9 16 25 36 49
    // y n y n  y  n  y
    func nearestEveryOtherSquareToNumber(_ number: Int) -> Int {
        var nearestSquare: Int? = nil
        for i in 0..<number {
            let value = i+1
            let squareRoot = Int(pow(Double(value), 0.5))
            let squareOfSquareRoot = squareRoot * squareRoot
            
            if squareOfSquareRoot == value {
                if squareRoot % 2 == 1 {
//                    print("new nearest square: \(squareOfSquareRoot)")
                    nearestSquare = squareOfSquareRoot
                }
            }
        }
        return nearestSquare!
    }
    
    let perfectSquare = nearestEveryOtherSquareToNumber(square)
//    print("nearest square to \(square) is \(perfectSquare)")
    let largestMagnitudeDouble = sqrt(Double(perfectSquare)) / 2
    let largestMagnitudeInteger = Double(Int(largestMagnitudeDouble))
    var largestMagnitudeOfTargetSquare = Int(largestMagnitudeInteger)
    if largestMagnitudeDouble > largestMagnitudeInteger {
        largestMagnitudeOfTargetSquare+=1
    }
//    print("largest magnitude is \(largestMagnitudeOfTargetSquare)")
    var currentNumber = perfectSquare
    // The starting square is (0,0). 9 is at (1,1), and so on
    var startingLocation = largestMagnitudeOfTargetSquare-1
    if startingLocation < 0 { startingLocation = 0 }
//    print("starting location is \(startingLocation)")
    var locationX = startingLocation
    var locationY = startingLocation
    // Early out if we already match:
    if perfectSquare == square {
        return Location(x: locationX, y: locationY)
    }
    
    // Now that we have this, we can explore out until we find the square
    // We'll start by going to the right
    while(currentNumber != square) {
        if locationX == startingLocation && locationY == startingLocation {
//            print("Location: (\(locationX),\(locationY)) Moving right")
            // We're at the lower-right of an inner square. Move right
            locationX+=1
        }
        else if (locationX == largestMagnitudeOfTargetSquare && abs(locationY) < largestMagnitudeOfTargetSquare) {
//            print("Location: (\(locationX),\(locationY)) Moving up")
            // We still need to move up
            locationY-=1
        }
        else if (locationX > -largestMagnitudeOfTargetSquare && locationY == -largestMagnitudeOfTargetSquare) {
//            print("Location: (\(locationX),\(locationY)) Moving left")
            // We hit the top. Move left
            locationX-=1
        }
        else if (locationX == -largestMagnitudeOfTargetSquare && locationY < largestMagnitudeOfTargetSquare) {
//            print("Location: (\(locationX),\(locationY)) Moving down")
            // We hit the top left. Move down
            locationY+=1
        }
        else {
//            print("Location: (\(locationX),\(locationY)) Moving right")
            // We're at the bottom row. Move right
            locationX+=1
        }
        
        currentNumber += 1
    }
    return Location(x: locationX, y: locationY)
}

func distanceFromSquare(_ square: Int) -> Int {
    let coord = coordinateForSquare(square)
    print(coord)
    return abs(coord.x) + abs(coord.y)
}

// Samples:
//print(distanceFromSquare(24)) // 3
//print(distanceFromSquare(25)) // 4
//print(distanceFromSquare(26)) // 5
//print(distanceFromSquare(49)) // 6

//print(distanceFromSquare(1)) // 0
//print(distanceFromSquare(12)) // 3
//print(distanceFromSquare(23)) // 2
//print(distanceFromSquare(1024)) // 31

let problemInput = 312051

// Problem:
//print(distanceFromSquare(problemInput)) // 430

// Part 2

func squareForCoordinate(_ coordinate: Location) -> Int {
    // This is a very lazy algorithm
    if coordinate == Location(x: 0, y: 0) {
        return 1
    }
    var runningNumber = 1
    
    while(true) {
        let tryCoordinate = coordinateForSquare(runningNumber)
        if tryCoordinate == coordinate {
            break
        }
        runningNumber+=1
    }
    
    return runningNumber
}

var squareValueTable = [Int : Int]()

func valueStoredAtSquare(_ square: Int) -> Int {
    if square == 1 { return 1 }
    // To determine this, we will recursively explore all adjacent squares that
    // are lower than this square
    let squareLocation = coordinateForSquare(square)
    
    let candidateOtherLocations = [squareLocation.north(), squareLocation.north().east(), squareLocation.east(), squareLocation.south().east(), squareLocation.south(), squareLocation.south().west(), squareLocation.west(), squareLocation.north().west()]
    var candidateOtherSquares = [Int]()
    
    for location in candidateOtherLocations {
        let squareAtLocation = squareForCoordinate(location)
        if squareAtLocation < square {
            candidateOtherSquares.append(squareAtLocation)
        }
    }
    
    if let value = squareValueTable[square] {
        return value
    }
    else {
        // Now return the sum of all adjacent square's values
        var sum = 0
        for otherSquare in candidateOtherSquares {
            sum = sum + valueStoredAtSquare(otherSquare)
        }
        squareValueTable[square] = sum
        return sum
    }
}

// Samples
print(valueStoredAtSquare(1)) // 1
print(valueStoredAtSquare(2)) // 1
print(valueStoredAtSquare(3)) // 2
print(valueStoredAtSquare(4)) // 4
print(valueStoredAtSquare(5)) // 5

print(valueStoredAtSquare(13)) // 59

// Problem:

var firstValueStoredLargerThanPuzzleInput = 0
var runningSquare = 1
while(true) {
    let valueAtSquare = valueStoredAtSquare(runningSquare)
    if valueAtSquare > problemInput {
        firstValueStoredLargerThanPuzzleInput = valueAtSquare
        break
    }
    runningSquare+=1
}

print(firstValueStoredLargerThanPuzzleInput)

