# ISBN Validation
An ISBN is a 10 digit numbers that is used to identify a book. The first 9 digits of it, can take any value between 0 and 9, but the last digits, sometimes may take value equal to 10 which is done by writing it as 'X'. To verify an ISBN we can compute 10 times the first digit, plus 9 times the second digit, plus 8 times the third digit and so on until we add 1 time the last digit. If the number leaves no remainder when divided by 11, the code is a valid ISBN.

## How to Use
1. Compile with ```cobc -x -free isbn.cob```
2. Run with ```./isbn```
3. Input a filename of the ASCII file with ISBN numbers
4. Program will read the file and output the validity of each ISBN number which can be either incorrect, correct and valid, or correct, but not valid (invalid check digit).

### **Example:**
Input: 
```1856266532``` \
```1B56266532``` \
```1856266537``` 
Output: 
```correct and valid``` \
```incorrect, contains a non-digit``` \
```correct, but not valid (invalid check digit)```
