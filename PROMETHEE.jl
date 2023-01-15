module PROMETHEE_mod

export Flows_fn
using LinearAlgebra, DataFrames

function Flows_fn(Decision_Matrix::Matrix, q_thresholds::Vector, p_thresholds::Vector, 
                    scurve_thresholds::Vector, weights::Vector, pref_fn::Vector; alternative_names::Vector)
    #=
    This function returns the flows of PROMETHEE I and PROMETHEE II

    inputs: 
        Decision_Matrix - matrix of size=(m,n) with the performances of $m$ alternatives regarding $n$ criteria.
        q_thresholds - a n-dimensional vector receiving indifference thresholds for the criteria
        p_thresholds - a n-dimensional vector receiving preference thresholds for the criteria
        scurve_thresholds- a n-dimensional vector receiving the scurve thresholds to be used in case the Gaussian function is chosen
        weights: a n-dimensional vector receiving weights for the criteria
        pref_function: a n-dimensional vector receiving as input integers between 1 and 6 that indicate the preference function for each criterion 
        alternative_names - vector of strings receiving the name of the alternatives

    possible outputs:
        results: DataFrame with net, positive and negative flows for each alternative
        net_flows: m-dimensional vector of net flows
        pos_flows: m-dimensional vector of positive flows
        neg_flows: m-dimensional vector of negative flows
    =#
    
    m, n = size(Decision_Matrix) #m is the number of alternatives, n is the number of criteria
    D = zeros(m,m,n) # 3-dimensional array that will receive n matrices (mxm) of pairwise differences 
    P = zeros(m,m,n) # 3-dimensional array that will receive n matrices (mxm) of preference functions according with the given p_thresholds
    
    for j in 1:n
        for u in 1:m
            for v in 1:m
                D[u,v,j] = Decision_Matrix[u,j] - Decision_Matrix[v,j]
                
                if pref_fn[j] == 1 D[u,v,j] <=0 ? P[u,v,j] = 0 : P[u,v,j] = 1 end              
                if pref_fn[j] == 2 D[u,v,j] <= q_thresholds[j] ? P[u,v,j] = 0 : P[u,v,j] = 1 end
                if pref_fn[j] == 3 D[u,v,j] <= 0 ? P[u,v,j] = 0 : 
                    D[u,v,j] <= p_thresholds[j] ? P[u,v,j] = D[u,v,j]/p_thresholds[j] : 
                    P[u,v,j] = 1 
                end
                if pref_fn[j] == 4 D[u,v,j] <= q_thresholds[j] ? P[u,v,j] = 0 : 
                    D[u,v,j] <= p_thresholds[j] ? P[u,v,j] = 0.5 : P[u,v,j] = 1 
                end
                
                if pref_fn[j] == 5 D[u,v,j] <= q_thresholds[j] ? P[u,v,j] = 0 : 
                D[u,v,j] <= p_thresholds[j] ? P[u,v,j]=(D[u,v,j]-q_thresholds[j])/(p_thresholds[j]-q_thresholds[j]) : 
                P[u,v,j] = 1 
                end
                if pref_fn[j] == 6 D[u,v,j] <=0 ? P[u,v,j] = 0 : P[u,v,j] = 1 - exp(-(D[u,v,j]^2 / 2*scurve_thresholds[j]^2)) end              
            end
        end    
    end
           
    Aggregated_P = zeros(m,m)
    for u in 1:m
        for v in 1:m
            Aggregated_P[u,v] = dot(P[u,v,:],weights)     
        end 
    end
    #Aggregated_P = DataFrames(Aggregated_P)
    pos_flows = [sum(Aggregated_P[i,:]) / (m-1) for i in 1:m] # Vector of positive flows
    neg_flows = [sum(Aggregated_P[:,j]) / (m-1) for j in 1:m] # Vector of negative flows
    net_flows = pos_flows - neg_flows

    flows = DataFrame(Alternative = alternative_names,
                        Positive_flows = pos_flows,
                        Negative_flows = neg_flows,
                        Net_flows = net_flows)
    return flows

end # end function PROMETHEE
end # end module