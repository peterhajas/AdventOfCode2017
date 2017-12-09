import Cocoa

// Part 1

struct HighestValue {
    var index: Int
    var value: Int
}

extension Array where Element == Int {
    var highestValue: HighestValue {
        var highestValue = Int.min
        var index = 0
        
        for i in 0..<self.count {
            if self[i] > highestValue {
                index = i
                highestValue = self[i]
            }
        }
        
        return HighestValue(index: index, value: highestValue)
    }
}

extension Array where Element == [Int] {
    func contains(_ otherElement: [Int]) -> Bool {
        for intList in self {
            if intList == otherElement {
                return true
            }
        }
        return false
    }
}

func numberOfRedistributionsBeforeDistributionOccursAgain(bank: [Int]) -> Int {
    var seenConfigurations = [[Int]]()
    var currentConfiguration = bank
    
    func redistributeConfiguration(_ configuration: [Int]) -> [Int] {
        var mutableConfiguration = configuration
        
        // Find the highest value in the configuration
        let highestValue = mutableConfiguration.highestValue
        
        // Remove the value at this index
        mutableConfiguration[highestValue.index] = 0
        
        func configurationIndexAfterIndex(_ index: Int) -> Int {
            var nextIndex: Int
            if index == mutableConfiguration.indices.last {
                nextIndex = 0
            }
            else {
                nextIndex = mutableConfiguration.index(after: index)
            }
            return nextIndex
        }
        
        // Redistribute evenly starting at the next index
        
        var indexToWriteAt = configurationIndexAfterIndex(highestValue.index)
        for _ in 0..<highestValue.value {
            mutableConfiguration[indexToWriteAt] += 1
            indexToWriteAt = configurationIndexAfterIndex(indexToWriteAt)
        }
        
        return mutableConfiguration
    }
    
    while(true) {
        seenConfigurations.append(currentConfiguration)
        print(seenConfigurations.count)
        
        // Redistribute the current configuration
        currentConfiguration = redistributeConfiguration(currentConfiguration)
        
        if seenConfigurations.contains(currentConfiguration){
            return seenConfigurations.count
        }
    }
    
    return 0
}

// Sample
let sample = [0,2,7,0]
print(numberOfRedistributionsBeforeDistributionOccursAgain(bank: sample)) // 5

// Problem
let problemInput = [5,1,10,0,1,7,13,14,3,12,8,10,7,12,0,6]
print(numberOfRedistributionsBeforeDistributionOccursAgain(bank: problemInput)) // 5042

