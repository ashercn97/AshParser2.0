module ArgParser

export Flag, Argu, Put, parse_args

struct Flag
    flag::String
    num_args::Int
    description::String
    default::Union{Nothing, String}
end

struct Argu
    flag::Flag
    arg::String
end

struct Put
    flag::String
    value
end

function get_array()
    arg_array = []
    for arg in ARGS
        push!(arg_array, arg)
    end
    return arg_array
end

function put_in_struct(arg_array::Array, flag_defs::Dict{String, Flag})
    flag_sym = "--"
    parsed_array = []
    i = 1
    while i <= length(arg_array)
        found = false
        if arg_array[i] == "--help"
            print_help(flag_defs)
            return []
        end
        for (flag_name, flag) in flag_defs
            if occursin("$(flag_sym)$(flag_name)", arg_array[i])
                num_args = flag.num_args
                if num_args > 0
                    if i + num_args <= length(arg_array)
                        parsed = Argu(flag, join(arg_array[i + 1:i + num_args], " ")) # Join the argument array into a single string
                        push!(parsed_array, parsed)
                    else
                        println("Flag $(flag_sym)$(flag_name) is missing its argument.")
                    end
                    i += num_args + 1  # Move to the next argument after the flag and its arguments
                else
                    parsed = Argu(flag, "")
                    push!(parsed_array, parsed)
                    i += 1  # Move to the next argument
                end
                found = true
                break
            end
        end
        if !found
            # Check if the argument starts with a digit, indicating a positional argument
            if isdigit(arg_array[i][1])
                push!(parsed_array, Argu(Flag("", 0, ""), arg_array[i]))
            else
                println("Unrecognized argument: $(arg_array[i])")
            end
            i += 1
        end
    end

    return parsed_array
end

function process_args(parsed_args, flag_arg_types)
    processed_args = []
    for arg in parsed_args
        if arg.flag.flag == ""
            # This is a positional argument, handle it differently
            processed_arg = convert_arg("", arg.arg, flag_arg_types)
        else
            flag = arg.flag.flag
            num_args = arg.flag.num_args
            arg_value = arg.arg
            if num_args == 1
                processed_arg = convert_arg(flag, arg_value, flag_arg_types)
            else
                arg_values = split(arg_value)
                processed_arg = [convert_arg(flag, val, flag_arg_types) for val in arg_values]
            end
        end
        push!(processed_args, Put(arg.flag.flag, processed_arg))
    end
    return processed_args
end

function convert_arg(flag, arg, flag_arg_types)
    if haskey(flag_arg_types, flag)
        if flag_arg_types[flag] == String
            return arg
        else
            return parse(flag_arg_types[flag], arg)
        end
    else
        return arg
    end
end

function print_help(flag_defs::Dict{String, Flag})
    println("Usage: julia file_name.jl [flags] [args]")
    println("\nFlags:")
    for (flag_name, flag) in flag_defs
        if flag.flag != ""
            default_value = flag.default == nothing ? "" : " (default: $(flag.default))"
            println("  --$(flag_name) [args]  $(flag.description)$default_value")
        end
    end
end

end
