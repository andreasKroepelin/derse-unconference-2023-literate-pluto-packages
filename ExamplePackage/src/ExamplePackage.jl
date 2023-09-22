module ExamplePackage

"""
    dot(x, y)

Compute the dot product between `x` and `y`
"""
function dot(x, y)
    result = zero(eltype(x))

    for i in eachindex(x, y)
        result += x[i] * y[i]
    end

    result  # the last statement is returned
end

export dot

end  # module
