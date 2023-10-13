include("PROMETHEE.jl")
using  .PROMETHEE_mod
using HTTP, CSV, DataFrames, MLJ

function main()
    #Generating a synthetic Decision Matrix
    c = mapreduce(permutedims, vcat, [[j for i in 1:6] for j in 100:-10:10])
    X , y = make_blobs(10, 6; centers = c,  as_table=false, rng = 2)
    X_df = DataFrame(X,:auto)
    println("\nOur Decision Matrix is:\n $X_df")
    n = size(X)[2]
    q = [5 for i in 1:n]
    p = [10 for i in 1:n]
    s = [0 for i in 1:n]
    w = [1/n for i in 1:n]
    pref = [5 for i in 1:n]
    flows_df, pos_flows, neg_flows, net_flows = PROMETHEE_mod.Flows_fn(X,q,p,s,w,pref; alternative_names=nothing)
    sort!(flows_df, :Net_flows, rev=true)
    return flows_df, pos_flows, neg_flows, net_flows
end
flows_df, pos_flows, neg_flows, net_flows = main()

println("\nThe flows obtained for this Decision Matrix (ordered by the net flows) are:\n $flows_df")

#= 
Based on the positive and negative flows, one could obtain the PROMETHEE-I relations running the following loop:

   P1_Matrix = Array{String}(undef,m,m)
    for i in 1:m
        for j in 1:m
            P1_Matrix[i,j] = "-"
            if ((pos_flows[i]>pos_flows[j] && neg_flows[i]<neg_flows[j]) || 
                (pos_flows[i]==pos_flows[j] && neg_flows[i]<neg_flows[j])||
                (pos_flows[i]>pos_flows[j] && neg_flows[i]==neg_flows[j]))
                P1_Matrix[i,j]="P"
            end
            if pos_flows[i]==pos_flows[j] && neg_flows[i]==neg_flows[j]
                P1_Matrix[i,j]="I"
            end
            if ((pos_flows[i]>pos_flows[j] && neg_flows[i]>neg_flows[j]) || 
                (pos_flows[i]<pos_flows[j] && neg_flows[i]<neg_flows[j]))
                P1_Matrix[i,j]="R"
            end
        end
    end
=#