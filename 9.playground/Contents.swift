import Cocoa

func cleanStream(_ stream: String) -> (cleaned: String, noncancelledGarbage: Int) {
    var cleanedStream = stream
    
    // Trim !'s. This involves trimming them and the character next to them
    while cleanedStream.contains("!") {
        var rangeOfExclamation = (cleanedStream as NSString).range(of: "!")
        rangeOfExclamation.length += 1
        cleanedStream = (cleanedStream as NSString).replacingCharacters(in: rangeOfExclamation, with: "")
    }
    
    // Trim garbage. This involves finding the next < and removing until the
    // next >
    var noncancelledGarbageCount = 0
    while cleanedStream.contains("<") {
        let rangeOfGarbageStart = (cleanedStream as NSString).range(of: "<")
        let rangeOfGarbageEnd = (cleanedStream as NSString).range(of: ">")
        let rangeOfGarbageLength = (rangeOfGarbageEnd.location + rangeOfGarbageEnd.length) - rangeOfGarbageStart.location
        let rangeOfGarbage = NSRange(location: rangeOfGarbageStart.location, length: rangeOfGarbageLength)
        cleanedStream = (cleanedStream as NSString).replacingCharacters(in: rangeOfGarbage, with: "")
        
        noncancelledGarbageCount += (rangeOfGarbageLength - 2)
    }
    
    // Remove commas
    cleanedStream = cleanedStream.replacingOccurrences(of: ",", with: "")
    
    return (cleanedStream, noncancelledGarbageCount)
}

func scoreForStream(_ stream: String) -> Int {
    let cleanedStream = cleanStream(stream).cleaned
    var level = 0
    var score = 0
    for character in cleanedStream {
        let characterString = String(character)
        if characterString == "{" {
            level += 1
        }
        else if characterString == "}" {
            score += level
            level -= 1
        }
    }
    
    return score
}

let problemInput: String

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
problemInput = try String(contentsOf: url)

// Samples
print(scoreForStream("{}")) // 1
print(scoreForStream("{{{}}}")) // 6
print(scoreForStream("{{},{}}")) // 5
print(scoreForStream("{{{},{},{{}}}}")) // 16
print(scoreForStream("{<a>,<a>,<a>,<a>}")) // 1
print(scoreForStream("{{<ab>},{<ab>},{<ab>},{<ab>}}")) // 9
print(scoreForStream("{{<!!>},{<!!>},{<!!>},{<!!>}}")) // 9
print(scoreForStream("{{<a!>},{<a!>},{<a!>},{<ab>}}")) // 3

// Problem
print(scoreForStream(problemInput)) // 16021

// Part 2
// Samples
print(cleanStream("<>").noncancelledGarbage) // 0
print(cleanStream("<random characters>").noncancelledGarbage) // 17
print(cleanStream("<{o\"i!a,<{i<a>").noncancelledGarbage) // 10

// Problem
print(cleanStream(problemInput).noncancelledGarbage) / /7685
