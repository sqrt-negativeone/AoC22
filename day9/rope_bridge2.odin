package advent_of_code

import "core:time"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"

point :: [2]i32;

DrawRope :: proc(Rope :[]point, $W : int, $H:int)
{
  HalfWidth := W / 2;
  HalfHeight := H / 2;
  
  for Y := H; Y >= 0; Y -= 1
  {
    for X := 0; X < W; X += 1
    {
      Ch := '.';
      for P, i in Rope
      {
        if (int(P.x) + HalfWidth == X) && (int(P.y) + HalfHeight == Y)
        {
          Ch = '0' + rune(i);
          break;
        }
      }
      fmt.print(Ch);
    }
    fmt.println()
  }
  fmt.println();
}

UpdateRope :: proc(Rope :[]point)
{
  for i := 1; i < len(Rope); i += 1
  {
    Head     := &Rope[i - 1];
    Tail     := &Rope[i];
    if (abs(Head.x - Tail.x) <= 1) && (abs(Head.y - Tail.y) <= 1) do continue;
    
    if (Head.y == Tail.y) && (abs(Head.x - Tail.x) > 1)
    {
      // NOTE(fakhri): same column
      Tail.x += (Head.x - Tail.x > 0)? 1 : -1;
    }
    else if (Head.x == Tail.x) && (abs(Head.y - Tail.y) > 1)
    {
      // NOTE(fakhri): same row
      Tail.y += (Head.y - Tail.y > 0)? 1 : -1;
    }
    else if (abs(Head.x - Tail.x) > 1) || (abs(Head.y - Tail.y) > 1)
    {
      // NOTE(fakhri): diagonal
      Tail.x += (Head.x - Tail.x > 0)? 1 : -1;
      Tail.y += (Head.y - Tail.y > 0)? 1 : -1;
    }
  }
  
  // NOTE(fakhri): debug output
  when false do DrawRope(Rope, 30, 30);
}

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  Lines := strings.split_lines(string(FileContent));
  Visited := make(map[[2]i32]bool);
  Visited[0] = true;
  // 0 is the head, 9 is the tail
  KNOT_COUNT :: 9;
  Rope     :[KNOT_COUNT + 1]point;
  for Line in Lines
  {
    if Line == "" do continue;
    Moves := strings.split(Line, " ");
    Dir, Steps, _ := Moves[0], strconv.parse_int(Moves[1]);
    for ;Steps != 0; Steps -= 1
    {
      switch Dir[0]
      {
        case 'U': Rope[0].y += 1;
        case 'D': Rope[0].y -= 1;
        case 'L': Rope[0].x -= 1;
        case 'R': Rope[0].x += 1;
      }
      UpdateRope(Rope[:]);
      Visited[Rope[KNOT_COUNT]] = true;
    }
  }
  
  fmt.println("part2:", len(Visited));
}
