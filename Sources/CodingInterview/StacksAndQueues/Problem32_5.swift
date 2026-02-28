/**
You are implementing the back arrow functionality of a browser with an additional "forward" action. You are given a non-empty array, actions, with the actions that the user has done so far. Each element in actions consists of two elements. The first is the action type, "go", "back", or "forward".

When the action is "go", the second element is a URL string. The first action is always "go".
When the action is "back", the second element is a number ≥ 1 with the number of times we want to go back. Going back once means returning to the previous URL we went to with a "go" action. If there are no previous URLs, going back stays at the current one.
When the action is "forward", the second element is a number ≥ 1 with the number of times we want to go forward. Going forward past the last page that we have gone to does nothing.
Return the current URL the user is on after all actions are performed.

Example: actions = [["go", "google.com"],
                    ["go", "wikipedia.com"],
                    ["back", 1],
                    ["forward", 1],
                    ["back", 3],
                    ["go", "netflix.com"],
                    ["forward", 3]]
Output: "netflix.com"
*/

import Foundation


enum Action {
    case go(String)
    case back(Int)
    case forward(Int)
}

func currentURLFollowUp(actions: [Action]) -> String {
    var currentStack = [String]()
    var backStack = [String]()
    for action in actions {
        switch action {
            case .go(let domain):
                currentStack.append(domain)
                backStack.removeAll()
            case .back(let time):
                var toPop = time >= currentStack.count ? (currentStack.count - 1) : time
                while toPop > 0 {
                    backStack.append(currentStack.popLast()!)
                    toPop -= 1
                } 
            case .forward(let time):
                var toPush = min(time, backStack.count)
                while toPush > 0 {
                    currentStack.append(backStack.popLast()!)
                    toPush -= 1
                }
        }
    }
    return currentStack.last!
}