package advent_of_code

import "core:os"
import "core:io"
import "core:bufio"
import "core:strconv"
import "core:fmt"

main :: proc()
{
  FileHandle, err := os.open("input.txt");
  if err != os.ERROR_NONE do panic("couldn't open file");
  BufferedReader :bufio.Reader;
  bufio.reader_init(&BufferedReader, io.Reader{os.stream_from_handle(FileHandle)});
  
  CurrentCalories :int;
  MaxCalories :int;
  for
  {
    Line, io_err := bufio.reader_read_string(&BufferedReader, '\n');
    if io_err == .EOF || io_err == .No_Progress do break;
    Line = Line[:len(Line) - 1];
    if len(Line) > 0
    {
      Calorie, ok := strconv.parse_int(Line);
      if !ok do panic("couldnt parse value");
      CurrentCalories += Calorie;
    }
    else
    {
      MaxCalories = max(CurrentCalories, MaxCalories);
      CurrentCalories = 0;
    }
  }
  fmt.println(MaxCalories);
}