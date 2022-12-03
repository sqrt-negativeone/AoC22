package advent_of_code

import "core:os"
import "core:io"
import "core:bufio"
import "core:strconv"
import "core:slice"
import "core:strings"
import "core:fmt"

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  
  Lines := strings.split_lines(cast(string)FileContent);
  Sum :u32;
  
  for Line in Lines
  {
    Items := len(Line);
    Compartment1 := Line[:Items/2];
    Compartment2 := Line[Items/2:];
    for Item1 in Compartment1
    {
      if (strings.contains_rune(Compartment2, Item1) >= 0)
      {
        switch Item1
        {
          case 'a'..='z': Sum += u32(Item1 - 'a' + 1);
          case : Sum += 26 + u32(Item1 - 'A' + 1);
        }
        break;
      }
    }
  }
  fmt.println(Sum);
}