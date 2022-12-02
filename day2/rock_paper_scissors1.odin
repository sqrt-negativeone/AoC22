package advent_of_code

import "core:os"
import "core:io"
import "core:bufio"
import "core:strconv"
import "core:slice"
import "core:strings"
import "core:fmt"

MyRock :: 'X'
MyPaper :: 'Y'
MyScissor :: 'Z'

OtherRock :: 'A'
OtherPaper :: 'B'
OtherScissor :: 'C'

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  
  Lines := strings.split(cast(string)FileContent, "\n");
  Score :u32;
  
  for Line in Lines
  {
    Adversary := Line[0];
    Mine := Line[2];
    Score += u32(1 +  (Mine - 'X'));
    if (Mine - 'X') == (Adversary - 'A') do Score += 3; // draw
    else if Mine == MyRock && Adversary == OtherScissor do Score += 6;
    else if Mine == MyPaper && Adversary == OtherRock do Score += 6;
    else if Mine == MyScissor && Adversary == OtherPaper do Score += 6;
  }
  fmt.println(Score);
}