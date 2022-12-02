package advent_of_code

import "core:os"
import "core:io"
import "core:bufio"
import "core:strconv"
import "core:slice"
import "core:strings"
import "core:fmt"

Lose :: 'X'
Draw :: 'Y'
Win  :: 'Z'

LoseScore :: 0
DrawScore :: 3
WinScore  :: 6

RockScore    :: 1
PaperScore   :: 2
ScissorScore :: 3

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
    Outcome := Line[2];
    switch
    {
      case Adversary == OtherRock:
      {
        switch
        {
          case Outcome == Draw: Score += DrawScore + RockScore;
          case Outcome == Win : Score += WinScore + PaperScore;
          case Outcome == Lose: Score += LoseScore + ScissorScore;
        }
      }
      case Adversary == OtherPaper:
      {
        switch
        {
          case Outcome == Draw: Score += DrawScore + PaperScore;
          case Outcome == Win : Score += WinScore + ScissorScore;
          case Outcome == Lose: Score += LoseScore + RockScore;
        }
      }
      case Adversary == OtherScissor:
      {
        switch
        {
          case Outcome == Draw: Score += DrawScore + ScissorScore;
          case Outcome == Win : Score += WinScore + RockScore;
          case Outcome == Lose: Score += LoseScore + PaperScore;
        }
      }
    }
  }
  fmt.println(Score);
}