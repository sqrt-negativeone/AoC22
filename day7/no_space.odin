package advent_of_code

import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"


MAX_STRAGE_SIZE    :: 70_000_000
UPDATE_STRAGE_SIZE :: 30_000_000
MAX_NODE_COUNT :: 100_000

fs_node :: struct
{
  Parent : ^fs_node,
  Childs : map[string]^fs_node,
  Name   : string,
  IsFile : bool,
  Size   : int,
}

CreateNode :: proc(Name : string) -> (Node :^fs_node)
{
  Node = new(fs_node);
  Node.Childs = make(map[string]^fs_node);
  Node.Name = Name;
  return;
}

ComputeDirSize :: proc(Node : ^fs_node) -> (Answer :int)
{
  assert(Node.IsFile == false);
  
  for ChildName in Node.Childs
  {
    Child := Node.Childs[ChildName];
    if !Child.IsFile 
    {
      Answer += ComputeDirSize(Child);
    }
    
    Node.Size += Child.Size
  }
  
  if Node.Size < 100000
  {
    Answer += Node.Size;
  }
  return;
}

FindDirSizeToDelete :: proc(Node : ^fs_node, FreeSpace :int) -> (Answer : int)
{
  assert(Node.IsFile == false);
  if FreeSpace + Node.Size >= UPDATE_STRAGE_SIZE 
  {
    Answer = Node.Size;
    for ChildName in Node.Childs
    {
      if Child := Node.Childs[ChildName]; !Child.IsFile 
      {
        TestSize := FindDirSizeToDelete(Child, FreeSpace);
        if TestSize != 0 do Answer = min(Answer, TestSize)
      }
    }
  }
  return;
}


main :: proc()
{
  FileContent, ok := os.read_entire_file_from_filename("input.txt");
  if !ok do panic("couldn't open file");
  CommandResults := strings.split(cast(string)FileContent, "$ ")[1:];
  
  Root := CreateNode("/");
  CurrNode :^fs_node;
  
  for Result in CommandResults
  {
    Command_Output := strings.split_lines(Result);
    Command, Output := strings.split(Command_Output[0], " "), Command_Output[1:];
    switch Command[0]
    {
      case "cd": 
      {
        DestDir := Command[1];
        switch DestDir
        {
          case "/" : 
          {
            CurrNode = Root;
          }
          case "..": 
          {
            CurrNode = CurrNode.Parent;
          }
          case: 
          {
            CurrNode = CurrNode.Childs[DestDir];
          }
        }
      }
      case "ls":
      {
        Output = Output[:len(Output) - 1];
        for EntryLine in Output
        {
          Entry := strings.split(EntryLine, " ");
          Node := CreateNode(Entry[1]);
          CurrNode.Childs[Node.Name] = Node;
          Node.Parent = CurrNode;
          if Entry[0] != "dir"
          {
            Node.IsFile = true;
            Node.Size, _ = strconv.parse_int(Entry[0]);
          }
        }
      }
    }
  }
  
  fmt.println("part 1:", ComputeDirSize(Root));
  fmt.println("part 2:", FindDirSizeToDelete(Root, MAX_STRAGE_SIZE - Root.Size));
}