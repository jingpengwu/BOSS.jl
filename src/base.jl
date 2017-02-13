

function Base.getindex{T}( ba::BOSSArray{T,3}, idxes::Union{UnitRange, Int} ... )
    idxes = map(UnitRange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"
    resp = Requests.get(URI(urlPath); headers = ba.headers)
    data = Blosc.decompress(T, resp.data)
    data = reshape(data, map(length, idxes))
    return data
end

function Base.getindex{T}( ba::BOSSArray{T,4}, idxes::Union{UnitRange, Int} ... )
    idxes = map(UnitRange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"*
                    "/$(idxes[4].start-1):$(idxes[4].stop)"
    resp = Requests.get(URI(urlPath); headers = ba.headers)
    data = Blosc.decompress(T, resp.data)
    data = reshape(data, map(length, idxes))
    return data
end

function Base.setindex!{T}(ba::BOSSArray{T,3}, buffer::AbstractArray{T,3},
                            idxes::Union{UnitRange, Int})
    idxes = map(UnitRange, idxes)
    # construct the url
    # note that the start should -1 to match the coordinate system of numpy
    urlPath = "$(ba.urlPrefix)/cutout/$(ba.collectionName)"*
                    "/$(ba.experimentName)"*
                    "/$(ba.channelName)/$(ba.resolutionLevel)"*
                    "/$(idxes[1].start-1):$(idxes[1].stop)"*
                    "/$(idxes[2].start-1):$(idxes[2].stop)"*
                    "/$(idxes[3].start-1):$(idxes[3].stop)"
    data = Blosc.compress( buffer )
    resp = Requests.get(URI(urlPath); data = data, headers = ba.headers)
    return resp
end
