package advent_of_code

import "core:time"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"

part1 :: proc(Grid :[]string) -> (Answer :int)
{
  Row, Col := len(Grid), len(Grid[0]);
  for Y in 0..< Row
  {
    for X in 0..<Col
    {
      TreeHeight := int(Grid[Y][X] - '0');
      
      // NOTE(fakhri): test visible left
      TopHeight := -1;
      for TestX in 0..< X
      {
        Height := int(Grid[Y][TestX] - '0');
        TopHeight = max(TopHeight, Height)
      }
      if TreeHeight > TopHeight {Answer += 1; continue;}
      
      // NOTE(fakhri): test visible right
      TopHeight = -1;
      for TestX in (X + 1)..< Col
      {
        Height := int(Grid[Y][TestX] - '0');
        TopHeight = max(TopHeight, Height)
      }
      if TreeHeight > TopHeight {Answer += 1; continue;}
      
      // NOTE(fakhri): test visible up
      TopHeight = -1;
      for TestY in 0..< Y
      {
        Height := int(Grid[TestY][X] - '0');
        TopHeight = max(TopHeight, Height)
      }
      if TreeHeight > TopHeight {Answer += 1; continue;}
      
      // NOTE(fakhri): test visible down
      TopHeight = -1;
      for TestY in (Y + 1)..< Row
      {
        Height := int(Grid[TestY][X] - '0');
        TopHeight = max(TopHeight, Height)
      }
      if TreeHeight > TopHeight {Answer += 1; continue;}
    }
  }
  return;
}


part2 :: proc(Grid :[]string) -> (Answer :int)
{
  Row, Col := len(Grid), len(Grid[0]);
  for Y in 0..< Row
  {
    for X in 0..<Col
    {
      // NOTE(fakhri): look left
      LeftView := 0;
      for TestX := X - 1; TestX >= 0; TestX -= 1 
      {
        LeftView += 1;
        if Grid[Y][TestX] >= Grid[Y][X] do break;
      }
      
      // NOTE(fakhri): look right
      RightView := 0;
      for TestX in (X + 1) ..< Col
      {
        RightView += 1;
        if Grid[Y][TestX] >= Grid[Y][X] do break;
      }
      
      // NOTE(fakhri): look up
      UpView := 0;
      for TestY := Y - 1; TestY >= 0; TestY -= 1 
      {
        UpView += 1;
        if Grid[TestY][X] >= Grid[Y][X] do break;
      }
      
      // NOTE(fakhri): look down
      DownView := 0;
      for TestY in (Y + 1)..< Row
      {
        DownView += 1;
        if Grid[TestY][X] >= Grid[Y][X] do break;
      }
      ScenicScore := LeftView * RightView * UpView * DownView;
      Answer = max(Answer, ScenicScore)
    }
  }
  return;
}

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  Grid := strings.split_lines(string(FileContent));
  
  fmt.println("part1:", part1(Grid));
  fmt.println("part2:", part2(Grid));
}
