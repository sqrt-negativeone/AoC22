package advent_of_code

import "core:os"
import "core:io"
import "core:strconv"
import "core:strings"
import "core:slice"
import "core:fmt"

MAX_CRATES :: 1_000;

stack :: struct
{
  Crates :[MAX_CRATES]u8,
  Top :int,
}

PushToStack :: proc(Stack :^stack, Crate :u8)
{
  if Crate != ' '
  {
    assert(Stack.Top < MAX_CRATES);
    Stack.Crates[Stack.Top] = Crate;
    Stack.Top += 1;
  }
}

PopFromStack :: proc(Stack :^stack) -> (Result : u8)
{
  assert(Stack.Top > 0);
  Stack.Top -= 1;
  Result = Stack.Crates[Stack.Top];
  return;
}

PeekTop :: proc(Stack :^stack) -> (Result : u8)
{
  assert(Stack.Top > 0);
  Result = Stack.Crates[Stack.Top - 1];
  return;
}

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  
  Stacks_Steps:= strings.split(cast(string)FileContent, "\n\n");
  Staks := strings.split_lines(Stacks_Steps[0]);
  Steps := strings.split_lines(Stacks_Steps[1]);
  
  slice.reverse(Staks);
  Staks = Staks[1:];
  // [x] [x] [x] ... [x]
  // 3 * n + (n - 1) = string_length
  StaksCount := (len(Staks[0]) + 1) / 4;
  Stacks := make([]stack, StaksCount);
  for StackLine in Staks
  {
    for i := 0; i < StaksCount; i += 1
    {
      IndexInStack := 4 * i + 1;
      PushToStack(&Stacks[i], StackLine[IndexInStack]);
    }
  }
  
  for Step in Steps
  {
    DecodedStep := strings.split(Step, " ");
    if (len(DecodedStep) != 6) do continue;
    MoveCount, _  := strconv.parse_int(DecodedStep[1]);
    Src,       _  := strconv.parse_int(DecodedStep[3]);
    Dest,      _  := strconv.parse_int(DecodedStep[5]);
    Src  -= 1;
    Dest -= 1;
    
    for i := 0; i < MoveCount; i += 1
    {
      PushToStack(&Stacks[Dest], Stacks[Src].Crates[Stacks[Src].Top - MoveCount + i]);
    }
    Stacks[Src].Top -= MoveCount;
    
    // NOTE(fakhri): debug
    when false
    {
      for Stake in &Stacks
      {
        for Crate in Stake.Crates[:Stake.Top]
        {
          fmt.print(rune(Crate));
        }
        fmt.println();
      }
      fmt.println();
    }
  }
  
  for Stack in &Stacks
  {
    fmt.print(rune(PeekTop(&Stack)));
  }
  
}