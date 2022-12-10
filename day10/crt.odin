package advent_of_code

import "core:time"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"

DrawPixel :: proc(Pixel :int, Screen :[]rune, X :int)
{
  Screen[Pixel] = (abs(Pixel - X) <= 1)? '#' : '.';;
}

PrintScreen :: proc(Screen :[]rune)
{
  Pixel := 0;
  for R in 0..<6
  {
    for C in 0..<40
    {
      fmt.print(Screen[Pixel]);
      Pixel += 1;
    }
    fmt.println();
  }
}

main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  Lines := strings.split_lines(string(FileContent));
  
  Screen :[6 * 40]rune;
  X := 1;
  Cycles := 1;
  TargetCycle := 20;
  SignalStrength := 0;
  Scanline := 0;
  for Line in Lines
  {
    if len(Line) == 0 do continue;
    Instruction := strings.split(Line, " ");
    Pixel := Cycles - 1;
    
    Sprite := Scanline + X;
    DrawPixel(Pixel, Screen[:], Sprite);
    if Instruction[0][0] == 'a'
    {
      // NOTE(fakhri): add instruction
      Operand, _ := strconv.parse_int(Instruction[1]);
      DrawPixel(Pixel + 1, Screen[:], Sprite);
      Cycles += 2;
      if Cycles > TargetCycle
      {
        // NOTE(fakhri): use the old X value
        SignalStrength += TargetCycle * X;
        TargetCycle += 40;
      }
      X += Operand;
    }
    else do Cycles += 1;
    
    if Cycles == TargetCycle
    {
      SignalStrength += TargetCycle * X;
      TargetCycle += 40;
    }
    
    if Cycles >= Scanline + 40 do Scanline += 40;
  }
  
  fmt.println("part1:", SignalStrength);
  fmt.println("part2:");
  PrintScreen(Screen[:]);
}
