package advent_of_code

import "core:os"
import "core:io"
import "core:strconv"
import "core:strings"
import "core:fmt"


PART :: 2;
HEADER_LENGTH :: 4 when PART == 1 else 14;


main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  Input := cast(string)FileContent;
  
  Occ :=[26]int{0..<26 = -1};
  StartIndex := 0;
  
  for Ch, Index in Input
  {
    assert('a' <= Ch && Ch <= 'z');
    if Occ[Ch - 'a'] >= StartIndex
    {
      StartIndex = Occ[Ch - 'a'] + 1;
    }
    Occ[Ch - 'a'] = Index;
    if Index - StartIndex + 1 == HEADER_LENGTH
    {
      fmt.println(Index + 1);
      break;
    }
  }
}