using JuMP
using GLPK
include("distance.jl")
include("setFLP.jl")
include("setTTP.jl")


# Appel pour optimisation sur FLP

# solverSelected = GLPK.Optimizer
# model, model_x, model_zone = setFLP(solverSelected, 12)
# println("Solving..."); optimize!(model)
#
# # Afficher les résultats
# println("densité totale desservie = ", objective_value(model))
# print("stations ouvertes = "); println(value.(model_x))
# print("zones ouvertes = "); println(value.(model_zone))
# solverSelected = GLPK.Optimizer
# model, model_event = setTTP(solverSelected)
# println("Solving..."); optimize!(model)


#Appel pour optimisation sur TTP

# solverSelected = GLPK.Optimizer
# model, model_event = setTTP(solverSelected)
# println("Solving..."); optimize!(model)
#
# for i=1:8
#   print("event ", i, ": "); println(value.(model_event))
# end
