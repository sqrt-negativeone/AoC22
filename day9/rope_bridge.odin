package advent_of_code

import "core:time"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  Lines := strings.split_lines(string(FileContent));
  Visited := make(map[[2]i32]bool);
  Head, Tail :[2]i32;
  Visited[0] = true;
  
  for Line in Lines
  {
    if Line == "" do continue;
    Moves := strings.split(Line, " ");
    Dir, Steps, _ := Moves[0], strconv.parse_int(Moves[1]);
    switch Dir[0]
    {
      case 'U': 
      {
        for ;Steps != 0; Steps -= 1
        {
          Head.y += 1;
          if Head.y - Tail.y > 1
          {
            Tail.y += 1;
            Tail.x = Head.x;
            Visited[Tail] = true;
          }
        }
      }
      case 'D': 
      {
        for ;Steps != 0; Steps -= 1
        {
          Head.y -= 1;
          if Tail.y - Head.y > 1
          {
            Tail.y -= 1;
            Tail.x = Head.x;
            Visited[Tail] = true;
          }
        }
      }
      case 'L': 
      {
        for ;Steps != 0; Steps -= 1
        {
          Head.x -= 1;
          if Tail.x - Head.x > 1
          {
            Tail.x -= 1;
            Tail.y = Head.y;
            Visited[Tail] = true;
          }
        }
      }
      case 'R': 
      {
        for ;Steps != 0; Steps -= 1
        {
          Head.x += 1;
          assert(abs(Head.y - Tail.y) <= 1);
          if Head.x - Tail.x > 1
          {
            Tail.x += 1;
            Tail.y = Head.y;
            Visited[Tail] = true;
          }
        }
      }
    }
  }
  fmt.println("part1:", len(Visited));
}
