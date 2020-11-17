using JuMP
using GLPK


# Setting an ip model of SPP
function setFLP(solverSelected)

  model = Model(with_optimizer(solverSelected))

  @variable(model, stop[1:12], Bin) #12 arrets -> 12 variables binaires si l'arret est choisi ou non
  @variable(model, supp[1:3], Bin) #3 variables binaires pour la creation des arrets a Carquefou

  D = [0 650 1250 2000;
       650 0 600 1350;
       1250 600 0 750;
       2000 1350 750 0]

  @objective(model, Min, sum(stop[i] * 1.9 for i in 1:12) + sum(supp[k] * D[1,k] * 5.9 for k in 1:3))
#  @objective(model, Max, sum(stop[i] * 600 for i in 1:12))

  @constraint(model, cstr1, stop[6] + stop[7] >= 1)
  @constraint(model, cstr2, stop[2] + stop[3] >= 1)
  @constraint(model, arret_sup1, supp[3] == stop[12])
  @constraint(model, arret_sup2, supp[2] == stop[11] - stop[12])
  @constraint(model, arret_sup3, supp[1] <= (stop[10] - stop[11]))
  @constraint(model, arret_sup4, supp[1] <= (stop[10] - stop[12]))

  return model, stop
end



# Appel pour optimisation
solverSelected = GLPK.Optimizer
model, model_x = setFLP(solverSelected)
println("Solving..."); optimize!(model)

# Afficher les résultats
println("z  = ", objective_value(model))
print("x  = "); println(value.(model_x))
