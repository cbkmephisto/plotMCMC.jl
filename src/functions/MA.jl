function MA(vec)
    """
    Calculate moving average of a vector and
    return the MA vector
    """
    xsum=zeros(length(vec))
    xma=zeros(length(vec))
    for xi in 1:length(vec)
        if xi!=1
            xsum[xi]=xsum[xi-1]+vec[xi]
            xma[xi]=xsum[xi]/xi
        else
            xsum[xi]=vec[xi]
            xma[xi]=vec[xi]
        end
    end
    return xma
end

