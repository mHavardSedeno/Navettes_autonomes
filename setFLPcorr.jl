using JuMP
using GLPK
include("distance.jl")


# Setting an ip model of SPP
function setFLPcorr(solverSelected, p)

  model = Model(with_optimizer(solverSelected))

  @variable(model, stop[1:12], Bin) #12 arrets -> 12 variables binaires si l'arret est choisi ou non
  @variable(model, loti[1:30], Int) #30 lotissements à desservir
  @variable(model, desservie[1:30], Bin) #Indique si le lotissement i est desservi
  @variable(model, satisf[1:30], Int)

  demande = [0 600 0 0 0 0 0 0 0 0 0 0;    #Ecusson
             0 500 0 0 0 0 0 0 0 0 0 0;    #Tazieff
             0 200 200 0 0 0 0 0 0 0 0 0;  #Mousquetaires
             0 200 200 0 0 0 0 0 0 0 0 0;  #Reich
             0 0 200 0 0 0 0 0 0 0 0 0;     #Camelias
             0 0 200 0 0 0 0 0 0 0 0 0;    #Coletrie
             0 0 0 200 0 0 0 0 0 0 0 0;    #ZRGarde
             0 0 0 100 0 0 0 0 0 0 0 0;    #ZAGarde
             0 0 0 0 100 0 0 0 0 0 0 0;    #Terte
             0 0 0 0 100 0 0 0 0 0 0 0;    #Bele
             0 0 0 0 100 0 0 0 0 0 0 0;    #Bretagne
             0 0 0 0 0 100 100 0 0 0 0 0;  #Giraudiere
             0 0 0 0 0 100 100 0 0 0 0 0;  #Cadranieres
             0 0 0 0 0 100 100 0 0 0 0 0;  #Jonquilles
             0 0 0 0 0 0 100 0 0 0 0 0;    #LyceeCarquef
             0 0 0 0 0 0 100 0 0 0 0 0;    #Antilles
             0 0 0 0 0 0 0 100 0 0 0 0;    #Clio
             0 0 0 0 0 0 0 100 0 0 0 0;    #Hallouart
             0 0 0 0 0 0 0 50 0 0 0 0;     #Hugo
             0 0 0 0 0 0 0 0 100 0 0 0;    #Argonautes
             0 0 0 0 0 0 0 0 200 0 0 0;    #Maurois
             0 0 0 0 0 0 0 0 100 0 0 0;    #Armand
             0 0 0 0 0 0 0 0 0 200 0 0;    #Halles
             0 0 0 0 0 0 0 0 0 200 0 0;    #Centre
             0 0 0 0 0 0 0 0 0 200 0 0;    #Ecomard
             0 0 0 0 0 0 0 0 0 200 0 0;    #Gue
             0 0 0 0 0 0 0 0 0 200 0 0;    #Pompidou
             0 0 0 0 0 0 0 0 0 0 200 0;    #Fleuriaye
             0 0 0 0 0 0 0 0 0 0 0 100;    #Souchais
             0 0 0 0 0 0 0 0 0 0 0 100;    #Ampere
             ]


  @objective(model, Max, sum(satisf[1:30]))

  @constraint(model, donknow, satisf[1:30] == loti[i] * desservie[i] for i in 1:30)
  @constraint(model, desservie1, loti[1] <= stop[2])
  @constraint(model, desservie2, loti[2] <= stop[2])
  @constraint(model, desservie3, loti[3] <= stop[2] + stop[3])
  @constraint(model, desservie4, loti[4] <= stop[2] + stop[3])
  @constraint(model, desservie5, loti[5] <= stop[3])
  @constraint(model, desservie6, loti[6] <= stop[3])
  @constraint(model, desservie7, loti[7] <= stop[4])
  @constraint(model, desservie8, loti[8] <= stop[4])
  @constraint(model, desservie9, loti[9] <= stop[5])
  @constraint(model, desservie10, loti[10] <= stop[5])
  @constraint(model, desservie11, loti[11] <= stop[5])
  @constraint(model, desservie12, loti[12] <= stop[6] + stop[7])
  @constraint(model, desservie13, loti[13] <= stop[6] + stop[7])
  @constraint(model, desservie14, loti[14] <= stop[6] + stop[7])
  @constraint(model, desservie15, loti[15] <= stop[7])
  @constraint(model, desservie16, loti[16] <= stop[7])
  @constraint(model, desservie17, loti[17] <= stop[8])
  @constraint(model, desservie18, loti[18] <= stop[8])
  @constraint(model, desservie19, loti[19] <= stop[8])
  @constraint(model, desservie20, loti[20] <= stop[9])
  @constraint(model, desservie21, loti[21] <= stop[9])
  @constraint(model, desservie22, loti[22] <= stop[9])
  @constraint(model, desservie23, loti[23] <= stop[10])
  @constraint(model, desservie24, loti[24] <= stop[10])
  @constraint(model, desservie25, loti[25] <= stop[10])
  @constraint(model, desservie26, loti[26] <= stop[10])
  @constraint(model, desservie27, loti[27] <= stop[10])
  @constraint(model, desservie28, loti[28] <= stop[11])
  @constraint(model, desservie29, loti[29] <= stop[12])
  @constraint(model, desservie30, loti[30] <= stop[12])

  @constraint(model, cstr2, sum(stop[i] for i in 1:12) == p)

  # println("model : ", model)
  return model, stop, loti
end



# Appel pour optimisation
solverSelected = GLPK.Optimizer
model, model_x, model_loti = setFLPcorr(solverSelected, 8)
println("Solving..."); optimize!(model)

# Afficher les résultats
println("z  = ", objective_value(model))
print("x  = "); println(value.(model_x))
print("zones : "); println(value.(model_loti))
