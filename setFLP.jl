using JuMP
using GLPK


# Setting an ip model of SPP
function setFLP(solverSelected, p)

  model = Model(with_optimizer(solverSelected))

  @variable(model, stop[1:12], Bin) #12 arrets -> 12 variables binaires si l'arret est choisi ou non
  @variable(model, supp[1:3], Bin) #3 variables binaires pour la creation des arrets a Carquefou

  D = [0 650 1250 2000;
       650 0 600 1350;
       1250 600 0 750;
       2000 1350 750 0]

  desserte = [0 600 0 0 0 0 0 0 0 0 0 0;    #Ecusson
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

              println(sum(desserte[i,2] for i in 1:30))
#Minimiser les couts
#sum(stop[i] * 1.9 for i in 1:12) + sum(supp[k] * D[1,k] * 5.9 for k in 1:3)
#Maximiser les dessertes
@objective(model, Max, sum((desserte[i,j] for i in 1:30) for j in 1:12))

  @constraint(model, cstr_Landeau, stop[1] == 1)
  @constraint(model, cstr3, sum(stop[i] for i in 9:12) >=1 )
  @constraint(model, nb_arret, sum(stop[i] for i in 1:12) >= p)

  #Contraintes pour calcul des couts
  # @constraint(model, arret_sup1, supp[3] == stop[12])
  # @constraint(model, arret_sup2, supp[2] == stop[11] - stop[12])
  # @constraint(model, arret_sup3, supp[1] <= (stop[10] - stop[11]))
  # @constraint(model, arret_sup4, supp[1] <= (stop[10] - stop[12]))

  return model, stop
end



# Appel pour optimisation
solverSelected = GLPK.Optimizer
model, model_x = setFLP(solverSelected, 6)
println("Solving..."); optimize!(model)

# Afficher les résultats
println("z  = ", objective_value(model))
print("x  = "); println(value.(model_x))
