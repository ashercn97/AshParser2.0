# AshParser2.0
This is a super simple, one-file, easy yet effective CLI library in the Julia language. 

## What it does
AshParse has features to build arguements and specify the type, generate ```--help``` outputs, default values, positional args, and more! 

It makes it very easy to create CLI tools (which is shown below!).

#### Step one:
Import the file (I havnet uploaded it to Pkg yet)
```
include("AshParse.jl")
using .ArgParser
```

#### Step two:
Next, specify the flags you want to include in your tool. 

Do this in the format:

```
flags = Dict(
    "name" => Flag("name", number_of_args, "description of the flag for the help generation", default_args),
)
```
#### Step three:
Finally, you can find, parse and process the arguements. 
1. Get the messy array of arguements called from the command line! Super simple, one line.
```
args = ArgParser.get_array()
```

2. Put the args into a temporary structure based on the flags YOU specify (NOTE YOU JUST WRITE THE FLAG NAME, DONT INCLUDE "--")
```
parsed_args = ArgParser.put_in_struct(args, flags)
```

3. And last step: process the args into a super easy to use format for all your command line needs.
```
processed_args = ArgParser.process_args(parsed_args, Dict(
    "name" => Type,
))
```

## Example usage:

```
for arg in processed_args   #processed args is an array of structs
    if arg.flag == "add"    # the flag is the input, for this example it is the add flag
        result = arg.value[1] + arg.value[2]   #  these call the array of values that was put in after
        println("Result of addition: $result")
    elseif arg.flag == "multiply"
        result = arg.value[1] * arg.value[2]
        println("Result of multiplication: $result")
    end
end
```




