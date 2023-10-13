include("ArgParser.jl")
using .ArgParser


flags = Dict(
    "add" => Flag("add", 1, "Add a new todolist item", nothing),
    "view" => Flag("view", 0, "View the current todolist", nothing),
    "remove" => Flag("remove", 1, "Remove a specified index item from the todolist", nothing),
    "delete" => Flag("delete", 0, "Delete all of the content", nothing)
)

args = ArgParser.get_array()
parsed_args = ArgParser.put_in_struct(args, flags)

processed_args = ArgParser.process_args(parsed_args, Dict(
    "add" => String,
    "view" => nothing,
    "remove" => String,
))



function add_todo(input)
    path = "./todo_list.txt"
    file = open(path, "a")
    write(file, "$(input)\n")
    close(file)
end

function remove_item(index)
    path = "./todo_list.txt"
    file = open(path, "r")
    lines = []
    for line in eachline(file)
        push!(lines, line)
    end
    close(file)
    file = open(path, "w")
    deleteat!(lines, index)
    write(file, lines[1])
    close(file)
    file = open(path, "a")
    for line in 2:length(lines)
        write(file, lines[line])
    end
    close(file)
end

function show_todo()
    path = "./todo_list.txt"
    println("Todo List: \n\n")
    file = open(path, "r")

    for line in eachline(file)
        println(line)
    end
    close(file)
end

for arg in processed_args
    if arg.flag == "add"
        add_todo(arg.value)
    elseif arg.flag == "view"
        show_todo()
    elseif arg.flag == "remove"
        remove_item(parse(Int, arg.value))
    elseif arg.flag == "delete"
        file = open("./todo_list.txt", "w")
        close(file)
    end
end
