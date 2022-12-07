package advent_of_code

import "core:os"
import "core:strconv"
import "core:strings"
import "core:fmt"


MAX_STRAGE_SIZE    :: 70_000_000
UPDATE_STRAGE_SIZE :: 30_000_000
MAX_NODE_COUNT :: 100_000


fs_node_id :: u32;

fs_node :: struct
{
  Parent : fs_node_id,
  Childs : map[string]fs_node_id,
  Name   : string,
  IsFile : bool,
  Size   : int,
}

fs :: struct
{
  FSNodes : [MAX_NODE_COUNT]fs_node,
  NodeCount :u32,
}

CreateNode :: proc(using FileSystem : ^fs, Name : string) -> (Node :^fs_node, NodeID : fs_node_id)
{
  assert(NodeCount < len(FSNodes));
  NodeID = NodeCount; NodeCount += 1;
  Node = &FSNodes[NodeID];
  Node.Childs = make(map[string]fs_node_id);
  Node.Name = Name;
  return;
}

GetNodeByID :: proc(using FileSystem : ^fs, ID : fs_node_id) -> (Node :^fs_node)
{
  assert(ID < len(FSNodes));
  Node = &FSNodes[ID];
  return;
}

ComputeDirSize :: proc(using FileSystem : ^fs, NodeID : fs_node_id) -> (Answer :int)
{
  Node := GetNodeByID(FileSystem, NodeID);
  assert(Node.IsFile == false);
  
  for ChildName in Node.Childs
  {
    ChildID := Node.Childs[ChildName];
    Child := GetNodeByID(FileSystem, ChildID);
    if !Child.IsFile 
    {
      Answer += ComputeDirSize(FileSystem, ChildID);
    }
    
    Node.Size += Child.Size
  }
  
  if Node.Size < 100000
  {
    Answer += Node.Size;
  }
  return;
}

FindDirSizeToDelete :: proc(using FileSystem : ^fs, NodeID : fs_node_id, FreeSpace :int) -> (Answer : int)
{
  Node := GetNodeByID(FileSystem, NodeID);
  assert(Node.IsFile == false);
  if FreeSpace + Node.Size >= UPDATE_STRAGE_SIZE 
  {
    Answer = Node.Size;
    for ChildName in Node.Childs
    {
      ChildID := Node.Childs[ChildName];
      Child := GetNodeByID(FileSystem, ChildID);
      
      if !Child.IsFile 
      {
        TestSize := FindDirSizeToDelete(FileSystem, ChildID, FreeSpace);
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
  
  FileSystem := new(fs);
  
  CurrentDir :string;
  Root, RootID := CreateNode(FileSystem, "/");
  CurrNode :^fs_node;
  CurrNodeID :fs_node_id;
  
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
            CurrNodeID = RootID;
          }
          case "..": 
          {
            CurrNodeID = CurrNode.Parent;
          }
          case: 
          {
            CurrNodeID = CurrNode.Childs[DestDir];
          }
        }
        CurrNode = GetNodeByID(FileSystem, CurrNodeID);
      }
      case "ls":
      {
        Output = Output[:len(Output) - 1];
        for EntryLine in Output
        {
          Entry := strings.split(EntryLine, " ");
          Node, ID := CreateNode(FileSystem, Entry[1]);
          CurrNode.Childs[Node.Name] = ID;
          Node.Parent = CurrNodeID;
          if Entry[0] != "dir"
          {
            Node.IsFile = true;
            Node.Size, _ = strconv.parse_int(Entry[0]);
          }
        }
      }
    }
  }
  
  fmt.println("part 1:", ComputeDirSize(FileSystem, RootID));
  fmt.println("part 2:", FindDirSizeToDelete(FileSystem, RootID, MAX_STRAGE_SIZE - Root.Size));
}