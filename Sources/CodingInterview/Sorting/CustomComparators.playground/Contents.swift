import Foundation

/**
QUESTION 1

CASE-INSENSITIVE SORT

Given an array of strings, sort it lexicographically (the dictionary order) in descending order, ignoring case.

Example:
Input: ["apple", "Banana", "3", "Cherry", "42", "GRAPE", "10"]
Output: ["GRAPE", "Cherry", "Banana", "apple", "42", "3", "10"]
*/

/**
QUESTION 2

SORT BY ELEMENT AT INDEX

Given an array of intervals, where each interval consists of a start value and an end value, sort the intervals by the end value.

Example:
Input: [[3,9], [1,4], [4,7], [2,3]]
Output: [[2,3], [1,4], [4,7], [3,9]]
*/

/**
QUESTION 3

SORT BY FIELD

You are given an array, deck, of objects of the Card class, representing a deck of playing cards:

class Card:
    def __init__(self, value, suit):
        self.value = value  # A number between 1 and 13.
        self.suit = suit   # 'clubs', 'hearts', 'spades', or 'diamonds'

Sort the cards by value in ascending order.
	•	Aces are represented by the value 1
	•	Jacks, Queens, and Kings are represented by 11, 12, and 13, respectively
	•	When values are equal, break ties by suit, where:
Clubs < Hearts < Spades < Diamonds

Example:
Input:
deck = [{8, 'hearts'}, {8, 'clubs'}, {3, 'clubs'}, {3, 'hearts'}]

Output:
[{3, 'clubs'}, {3, 'hearts'}, {8, 'clubs'}, {8, 'hearts'}]
*/

/**
QUESTION 4

NEW DECK ORDER

Given the same deck array, sort it in “new deck order”, where:
	•	Suits are ordered: Hearts < Clubs < Diamonds < Spades
	•	Each suit is sorted from Ace (low) to King (high)

Example:
Input:
deck = [{8, 'hearts'}, {8, 'clubs'}, {3, 'clubs'}, {3, 'hearts'}]

Output:
[{3, 'hearts'}, {8, 'hearts'}, {3, 'clubs'}, {8, 'clubs'}]

*/

/**
QUESTION 5

STABLE SORTING

Given the same deck array, sort it by value while preserving the relative order of cards with the same value.
A sorting algorithm that breaks ties by the input order is called stable.

Example:
Input:
deck = [{9, 'clubs'}, {4, 'spades'}, {9, 'spades'}, {4, 'clubs'}]

Output:
[{4, 'spades'}, {4, 'clubs'}, {9, 'clubs'}, {9, 'spades'}]
*/
