package advent_of_code

import "core:os"
import "core:io"
import "core:strconv"
import "core:strings"
import "core:fmt"

elf_section :: struct
{
  Min, Max :int,
}

GetSection :: proc(ElfSection : string) -> (Result: elf_section, ok: bool)
{
  Elf := strings.split(ElfSection, "-");
  Result.Min = strconv.parse_int(Elf[0]) or_return;
  Result.Max = strconv.parse_int(Elf[1]) or_return;
  return;
}

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  
  Count :u32;
  Lines := strings.split_lines(cast(string)FileContent);
  
  for Line in Lines
  {
    Pair := strings.split(Line, ",");
    Elf1, _ := GetSection(Pair[0]);
    Elf2, _ := GetSection(Pair[1]);
    
    if (((Elf1.Min <= Elf2.Min) && (Elf2.Min <= Elf1.Max)) ||
        ((Elf1.Min <= Elf2.Max) && (Elf2.Max <= Elf1.Max)) ||
        ((Elf2.Min <= Elf1.Min) && (Elf1.Min <= Elf2.Max)) ||
        ((Elf2.Min <= Elf1.Max) && (Elf1.Max <= Elf2.Max)))
    {
      Count += 1;
    }
  }
  fmt.println(Count);
}