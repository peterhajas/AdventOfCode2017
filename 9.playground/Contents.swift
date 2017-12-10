import Cocoa

func cleanStream(_ stream: String) -> String {
    var cleanedStream = stream
    
    // Trim !'s. This involves trimming them and the character next to them
    while cleanedStream.contains("!") {
        var rangeOfExclamation = (cleanedStream as NSString).range(of: "!")
        rangeOfExclamation.length += 1
        cleanedStream = (cleanedStream as NSString).replacingCharacters(in: rangeOfExclamation, with: "")
    }
    
    // Trim garbage. This involves finding the next < and removing until the
    // next >
    while cleanedStream.contains("<") {
        let rangeOfGarbageStart = (cleanedStream as NSString).range(of: "<")
        let rangeOfGarbageEnd = (cleanedStream as NSString).range(of: ">")
        let rangeOfGarbageLength = (rangeOfGarbageEnd.location + rangeOfGarbageEnd.length) - rangeOfGarbageStart.location
        let rangeOfGarbage = NSRange(location: rangeOfGarbageStart.location, length: rangeOfGarbageLength)
        cleanedStream = (cleanedStream as NSString).replacingCharacters(in: rangeOfGarbage, with: "")
    }
    
    // Remove commas
    cleanedStream = cleanedStream.replacingOccurrences(of: ",", with: "")
    
    return cleanedStream
}

func scoreForStream(_ stream: String) -> Int {
    let cleanedStream = cleanStream(stream)
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
print(scoreForStream(problemInput))
