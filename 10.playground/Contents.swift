import Cocoa

extension NSRange {
    var end: Int {
        return location + length
    }
    
    var indices: [Int] {
        var indexArray = [Int]()
        for i in 0..<length {
            indexArray.append(i + location)
        }
        return indexArray
    }
}

extension Array {
    func loopingIndex(after i: Int) -> Int {
        if i == count-1 {
            return 0
        }
        return index(after: i)
    }
    func loopingIndex(before i: Int) -> Int {
        if i == 0 {
            return count-1
        }
        return index(before: i)
    }
    func loopingIndex(for i: Int) -> Int {
        let index = i%(count)
        return index
    }
    mutating func reverseInRange(_ range: NSRange) {
        var indicesToFlip = range.indices
        for i in 0..<indicesToFlip.count {
            indicesToFlip[i] = loopingIndex(for: indicesToFlip[i])
        }
        
        var valuesForIndices = [Element]()
        for index in indicesToFlip {
            valuesForIndices.append(self[index])
        }
        
        indicesToFlip.reverse()
        
        for i in 0..<indicesToFlip.count {
            self[indicesToFlip[i]] = valuesForIndices[i]
        }
    }
}

func processKnot(_ knotCommands: [Int], knotList: [Int], startingAtPosition: Int = 0, startingWithSkipSize: Int = 0) -> (knotList: [Int], currentPosition: Int, skipSize: Int) {
    var mutableKnotList = knotList
    var currentPosition = startingAtPosition
    var skipSize = startingWithSkipSize
    
    for command in knotCommands {
        let rangeToReverse = NSRange(location: currentPosition, length: command)
        mutableKnotList.reverseInRange(rangeToReverse)
        currentPosition += (command+skipSize)
        skipSize += 1
    }
    
    return (mutableKnotList, currentPosition, skipSize)
}

func part1ForKnot(_ knot: [Int]) -> Int {
    return knot[0] * knot[1]
}

// Sample
let sampleKnotList = [0,1,2,3,4]
print(processKnot([3,4,1,5], knotList: sampleKnotList).knotList) // 3,4,2,1,0
print(part1ForKnot(processKnot([3,4,1,5], knotList: sampleKnotList).knotList)) // 12

// Problem
let problemInput = [102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216]
let problemKnotList = Array(0..<256)
print(part1ForKnot(processKnot(problemInput, knotList: problemKnotList).knotList)) // 5577

// Part 2

func processKnotPart2(_ knot: String) -> String {
    var knotAscii = [Int]()
    
    for knotCharacter in knot {
        let ascii = (Int(knotCharacter.unicodeScalars.first!.value))
        knotAscii.append(ascii)
    }
    
    let otherAsciiToAppend = [17, 31, 73, 47, 23]
    knotAscii.append(contentsOf: otherAsciiToAppend)
    
    // Compute the sparse hash
    let roundsToRun = 64
    var currentPosition = 0
    var skipSize = 0
    var sparseHash = Array(0..<256)
    for _ in 0..<roundsToRun {
        let resultOfRun = processKnot(knotAscii, knotList: sparseHash, startingAtPosition: currentPosition, startingWithSkipSize: skipSize)
        currentPosition = resultOfRun.currentPosition
        skipSize = resultOfRun.skipSize
        sparseHash = resultOfRun.knotList
    }
    
    // Now that we have the sparse hash, we need to compute the dense hash
    var denseHash = [Int]()
    
    for i in 0..<256/16 {
        var valuesForBlock = [Int]()
        for j in 0..<16 {
            valuesForBlock.append(sparseHash[i*16 + j])
        }
        
        var valueForBlock: Int? = nil
        for value in valuesForBlock {
            if valueForBlock == nil {
                valueForBlock = value
                continue
            }
            valueForBlock = valueForBlock! ^ value
        }
        
        denseHash.append(valueForBlock!)
    }
    
    // Now that we have the dense hash, we need to make it into a string of
    // hex
    var hashString = ""
    
    for value in denseHash {
        let valueString = String(format:"%02x", value)
        hashString += valueString
    }
    
    return hashString
}

// Samples:
print(processKnotPart2("")) // a2582a3a0e66e6e86e3812dcb672a272
print(processKnotPart2("AoC 2017")) // 33efeb34ea91902bb2f59c9920caa6cd
print(processKnotPart2("1,2,3")) // 3efbe78a8d82f29979031a4aa0b16a9d
print(processKnotPart2("1,2,4")) // 63960835bcdc130f0b66d7ff4f6a5a8e

// Problem:
print(processKnotPart2("102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216")) // 44f4befb0f303c0bafd085f97741d51d

