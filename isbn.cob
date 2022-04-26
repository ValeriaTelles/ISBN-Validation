identification division.
program-id. isbn. 

environment division.
input-output section.
file-control.
select input-file assign to dynamic fname-inp
   organization is line sequential.

data division.
file section.
fd input-file.
01 file-info pic A(100).
01 number-info.
   05 num pic 9(10).

working-storage section.
77 feof        pic A(1).
77 fname-inp   pic x(30).
77 digitISBN   pic 9(3).
01 ISBN        pic 9(10).
01 printISBN   pic x(10).
01 validity    pic x(50).
01 temp        pic x(1).
77 checkValid  pic 99 value 1.
77 i           pic 99 value 1.
77 j           pic 99 value 1.
77 k           pic 99 value 1.
77 n           pic 99.
01 arr.
   02 array1 pic 9(10) occurs 100 times.

procedure division.
   perform readISBN.
   perform isValid.
stop run.

readISBN.
   *> prompt the user for the name of the ASCII file with ISBN numbers
   display "Input filename? "
   accept fname-inp.
   perform check-file-exists

   *> read the values of the ISBN
   open input input-file.
   perform until feof='Y'
   read input-file
      at end move 'Y' to feof
      not at end perform store-element
   end-read
   end-perform.
   compute n = i - 1.
   close input-file.

check-file-exists.
   *> check if the file exists, if it does not then re-prompt
   call "CBL_CHECK_FILE_EXIST" using fname-inp file-info.
   if return-code not equal zero then
      display "Error: File " fname-inp (1:20) " does not exist"
      perform readISBN
   end-if.

store-element.
   *> store the current number in the array and increment the array index i
   move num to array1(i).
   compute i = i + 1.

isValid.
   *> checks the validity of the ISBN
   perform varying i from 1 by 1 until i > n
      set checkValid to 1
      move array1(i) to ISBN
      move array1(i) to printISBN *> to be able to print all characters
      display printISBN with no advancing 

      perform varying j from 1 by 1 until j > 10
         move ISBN(j:1) to temp
         *> check if the character is a numerical digit
         if temp is not numeric then
            *> check if the check digit is an X - design
            if temp is equal to 'X' or temp is equal to 'x' then 
               *> check if the X - design check digit is in the right position
               if j is not equal to 10 then 
                  move "  incorrect, contains a non-digit" to validity
                  set checkValid to 0
               end-if 
            else 
               *> if the character is not an 'X' or 'x', then it an incorrect character
               move "  incorrect, contains a non-digit" to validity
               set checkValid to 0
            end-if
         end-if 
      end-perform

      perform checkSUM

   end-perform.

checkSUM.
   *> extracts the individual digits of the ISBN, and calculates the checksum digit
   set digitISBN to 0
   if checkValid is equal to 1 then 
      perform varying k from 1 by 1 until k > 9
         compute digitISBN = digitISBN + (11 - k) * function numval(ISBN(k:1))
      end-perform
      compute digitISBN = function mod(digitISBN, 11)
      if digitISBN is not equal to 0 then 
         compute digitISBN = 11 - digitISBN
      end-if
   end-if 

   *> check if the ISBN is valid (i.e., it is equal to the check digit)
   move ISBN(10:1) to temp.
   if checkValid is equal to 1 then 
      *> check if the character is a numerical digit
      if temp is not numeric then
         *> check if the X - design check digit is equal to the check sum digit
         if (temp is equal to 'X' or 'x') and (digitISBN is equal to 10) then 
            display "  correct and valid" 
         end-if
      else 
         *> if the check sum digit is equal to the last digit of the ISBN (i.e., check digit), then it is correct
         if function numval(temp) is equal to digitISBN then 
            display "  correct and valid" 
         else 
            *> if the ISBN is a correct format, but not the correct check digit
            display "  correct, but not valid (invalid check digit)"
         end-if 
      end-if 
   end-if

   if checkValid is equal to 0 then 
      display validity
   end-if.


