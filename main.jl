include("PROMETHEE.jl")
using  .PROMETHEE_mod
using HTTP, CSV, DataFrames

function main()
    data_url = "https://raw.githubusercontent.com/diogoflim/Dados/main/data.txt"
    file = CSV.File(HTTP.get(data_url).body; header = 1)
    raw_data = DataFrame(file)
    alternative_names = vec(raw_data[!,"Alternative"])
    X = Array(raw_data[!,Not(r"Alternative")])
    q = [5 for i in 1:12]
    p = [10 for i in 1:12]
    s = [0 for i in 1:12]
    w = [1/12 for i in 1:12]
    pref = [5 for i in 1:12]
    flows = PROMETHEE_mod.Flows_fn(X,q,p,s,w,pref, alternative_names)
    sort!(flows, :Net_flows, rev=true)
    return flows
end
main()