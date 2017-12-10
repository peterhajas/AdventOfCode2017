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

func processKnot(_ knotCommands: [Int], length: Int) -> [Int] {
    var knotList = Array(0..<length)
    var currentPosition = 0
    var skipSize = 0
    
    for command in knotCommands {
        let rangeToReverse = NSRange(location: currentPosition, length: command)
        knotList.reverseInRange(rangeToReverse)
        currentPosition += (command+skipSize)
        skipSize += 1
    }
    
    return knotList
}

func part1ForKnot(_ knot: [Int]) -> Int {
    return knot[0] * knot[1]
}

// Sample
print(processKnot([3,4,1,5], length: 5)) // 3,4,2,1,0
print(part1ForKnot(processKnot([3,4,1,5], length: 5))) // 12

// Problem
let problemInput = [102,255,99,252,200,24,219,57,103,2,226,254,1,0,69,216]
print(part1ForKnot(processKnot(problemInput, length: 256))) // 5577
