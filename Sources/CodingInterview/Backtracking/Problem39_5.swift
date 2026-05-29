/**
Problem prompt:
Given a non-empty string, sentence, and a non-empty map, synonyms, where each key is a single word in the sentence, and its value is a non-empty list of synonyms, return all possible sentences that can be created by replacing the words in the sentence with their synonyms. Words without synonyms should remain unchanged. The input sentence only contains lowercase letters and spaces, while the words in synonyms only contain lowercase letters. The order of the generated sentences in the output does not matter.


Example 1:
sentence = "one does not simply walk into mordor"
synonyms = {
  "walk": ["stroll", "hike", "wander"],
  "simply": ["just", "merely"]
}
Output: [
          "one does not just stroll into mordor",
          "one does not just hike into mordor",
          "one does not just wander into mordor",
          "one does not merely stroll into mordor",
          "one does not merely hike into mordor",
          "one does not merely wander into mordor"
        ]

Example 2:
sentence = "walk"
synonyms = {
  "walk": ["stroll"]
}
Output: ["stroll"]
Constraints:

sentence consists of lowercase letters and spaces.
The length of sentence is at most 500 characters.
sentence contains at most 100 words.
The synonyms map contains at most 8 entries.
The length of each synonym list is at most 6.
Each word in sentence or in the synonym lists is at most 10 characters.
*/

func synonymSentences(_ sentence: String, synonyms: [String: [String]]) -> [String] {
    let words = sentence.split(separator: " ")
    var results = [String]()
    var currentSynonymSentence = [String]()

    func visit(index: Int) {
        if index == words.count {
            results.append(currentSynonymSentence.joined(separator: " "))
            return
        }

        let word = String(words[index])
        let choices = synonyms[word] ?? [word]
        for choice in choices {
            currentSynonymSentence.append(choice)
            visit(index: index + 1)
            currentSynonymSentence.removeLast()
        }
    }
    visit(index: 0)
    return results
}
