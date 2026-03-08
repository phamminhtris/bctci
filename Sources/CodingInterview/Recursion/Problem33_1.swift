/**
We are given a string, seq, with a sequence of instructions for a robot. The string consists of characters 'L', 'R', and '2'. The letters 'L' and 'R' instruct the robot to move left or right.

The character '2' (which never appears at the end of the string) means "perform all the instructions after this '2' twice, but skip the instruction immediately following the '2' during the second repetition." Output a string with the final list of left and right moves that the robot should do.

Example 1: seq = "LL"
Output: "LL"

Example 2: seq = "2LR"
Output: "LRR". The '2' indicates that we need to do "LR" first and then "R".

Example 3: seq = "2L"
Output: "L". The '2' indicates that we need to do "L" first and then "" (the
empty string).

Example 4: seq = "22LR"
Output: "LRRLR". The first '2' indicates that we need to do "2LR" first and
then "LR".

Example 5: seq = "LL2R2L"
Output: "LLRLL"
*/

func move(seq: String) -> String {
    let seqArr = Array(seq)
    var res = [Character]()

    move(index: 0, ins: seqArr, res: &res)
    return String(res)
}

func move(index: Int, ins: [Character], res: inout [Character]) {
    guard index < ins.count else { return }
    
    let first = ins[index]
    if first == "2" {
        move(index: index + 1, ins: ins, res: &res)
        move(index: index + 2, ins: ins, res: &res)
    } else {
        res.append(first)
        move(index: index + 1, ins: ins, res: &res)
    }
}

func moveIterative(seq: String) -> String {
    let seqArr = Array(seq)
    var res: [Character] = []
    var stack = [0]

    while let index = stack.popLast() {
        guard index < seqArr.count else { continue }

        if seqArr[index] == "2" {
            stack.append(index + 2)
            stack.append(index + 1)
        } else {
            res.append(seqArr[index])
            stack.append(index + 1)
        }
    }

    return String(res)
}
