/**
Problem 35.2 - Hidden Message
The self-proclaimed 'cryptography expert' in your friend group has devised their own schema to hide messages in binary trees. Each node has a text field with exactly two characters. The first character is either 'b', 'i', or 'a'. The second character is part of the hidden message. To decode the message, you have to read the hidden-message characters in the following order:

If the first character in a node is 'b', the node goes before its left subtree, and the left subtree goes before the right subtree.
If it is 'a', the node goes after its right subtree, and the right subtree goes after the left subtree.
If it is 'i', the node goes after its left subtree and before its right subtree.
Given the root of the binary tree, return the hidden message as a string.

Example:

                 bn
               /    \
             i_      a!
            /  \     /
          ae    it  br
         /  \         \
       bi    bc        ay

Output: "nice_try!"

*/

import Foundation

func hiddenMessage(root: TreeNode<String>?) -> String {
  guard let root else { return "" }
  guard let code = root.value.first, let message = root.value.message else { 
    return ""
  }

  if code == "b" { 
    return String(message) + hiddenMessage(root: root.left) + hiddenMessage(root: root.right) 
  } else if code == "a" {
    return hiddenMessage(root: root.left) + hiddenMessage(root: root.right) + String(message)
  } else {
    // code == "i"
    return hiddenMessage(root: root.left) + String(message) + hiddenMessage(root: root.right) 
  }
}

extension String {
  var message: Character? { 
    guard self.count > 1 else { return nil }
    return self[index(after: startIndex)]
  }
}

