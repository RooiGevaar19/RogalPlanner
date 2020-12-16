# RogalPlanner

A console planning app that uses RogalScript

Paul Lipkowski (RooiGevaar19) and his fiancee Rozalia :heart:

Since 5/18/2020, proudly written in FreePascal :smile:

## Before you compile
- Have a Unix-like or Windows system
- Have a FreePascal Compiler (FPC), version 3.0.4+
- Have Lazarus IDE, version 1.6.4+
- Have installed **SQLite3** or (if using Windows) attached a `SQLite3.dll` file alongside the `rogal.exe` executable.
- Find either `compile.sh` (Unix) or `compile.bat` (Windows) and compile it! 

## Before you use:
- Windows users need to have installed **SQLite3** or attached a `SQLite3.dll` file alongside the `rogal.exe` executable.
- Linux users need to have installed **SQLite3**
- Running file without any parameters (`./rogal`) runs a blank aplication
- Running file with 1 parameter (`./rogal PATH_TO_FILE`) runs a script being located in `PATH_TO_FILE`. For example, `./rogal examples/base.rgs` runs `examples/base.rgs` script file.

## Current functions

**Tag management**:
- `add tag 'name'`
- `get tags`
- `get all tags`
- `get top N tags`
- `get tags of (name='STR',color='Default')` – the expression between parentheses is SQL compatible
- `get tag #id`
- `get database location`
- `get db location`
- `delete tag #id`
- `print 'text'`
- `run file 'path_to_file'`