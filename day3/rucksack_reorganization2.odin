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
  
  for i := 0; i < len(Lines); i += 3
  {
    Elf1 := Lines[i];
    Elf2 := Lines[i + 1];
    Elf3 := Lines[i + 2];
    for Item1 in Elf1
    {
      if (strings.contains_rune(Elf2, Item1) >= 0) && (strings.contains_rune(Elf3, Item1) >= 0)
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