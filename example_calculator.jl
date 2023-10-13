# calculator.jl
include("AshParse.jl")
using .ArgParser

# Define the available flags
flags = Dict(
    "add" => Flag("add", 2, "Add two numbers", nothing),
    "multiply" => Flag("multiply", 2, "Multiply two numbers", nothing)
)

# Parse the command line arguments
args = ArgParser.get_array()
parsed_args = ArgParser.put_in_struct(args, flags)

# Process the parsed arguments
processed_args = ArgParser.process_args(parsed_args, Dict(
    "add" => Int,
    "multiply" => Int
))

# Execute the specified operation
for arg in processed_args
    if arg.flag == "add"
        result = arg.value[1] + arg.value[2]
        println("Result of addition: $result")
    elseif arg.flag == "multiply"
        result = arg.value[1] * arg.value[2]
        println("Result of multiplication: $result")
    end
end
