using QML
using CSV
using DataFrames

const DATASET_REF = Ref(DataFrame())


function read_file(source)
    path = strip(source)

    if isempty(path)
        return "No path was given."
    end
    if !isfile(path)
        return "This file does not exist."
    end
    if !(endswith(lowercase(path), ".csv") || endswith(lowercase(path), ".xlsx"))
        return "Incorrect file format"
    end

    try 
        df = CSV.read(path, DataFrame)
        DATASET_REF[] = df
        return "File loaded, Rows: $(nrow(df)) Columns: $(ncol(df))"
    catch e
        return "There was an error while loading the file: " * sprint(showerror, e)
    end
end

@qmlfunction read_file


loadqml("UI/main.qml")
exec()