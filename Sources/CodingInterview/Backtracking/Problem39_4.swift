/**
Problem prompt:
Inspired by Shakespeare's iconic line, you decide to write a function, shakespearify(), which takes in a string, sentence, consisting of letters and spaces. For each word in the string, the function chooses if it should "be" or "not be" included in the sentence, returning all possible outcomes. The order of the output strings does not matter.


Example 1: sentence = "I love dogs"
Output: [
         "",
         "I",
         "love",
         "dogs",
         "I love",
         "I dogs",
         "love dogs",
         "I love dogs"
        ]

Example 2: sentence = "hello"
Output: ["", "hello"]

Example 3: sentence = ""
Output: [""]

*/

func shakespearify(_ sentence: String) -> [String] {
    let words = sentence.split(separator: " ")
    var outcomes: [String] = []
    var selectedWords: [Substring] = []

    func visit(index: Int) {
        guard index < words.count else {
            outcomes.append(selectedWords.joined(separator: " "))
            return
        }

        selectedWords.append(words[index])
        visit(index: index + 1)
        selectedWords.removeLast()

        visit(index: index + 1)
    }

    visit(index: 0)
    return outcomes
}
