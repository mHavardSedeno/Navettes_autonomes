using JuMP
using GLPK


# Setting an ip model of SPP
function setFLP(solverSelected, p)

  model = Model(with_optimizer(solverSelected))

  @variable(model, stop[1:12], Bin) #12 arrets -> 12 variables binaires si l'arret est choisi ou non
  @variable(model, supp[1:3], Bin) #3 variables binaires pour la creation des arrets a Carquefou
  @variable(model, zone[1:30], Int)

  #Matrice des 30 densités de population touchées par chaque station
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

#Minimiser les couts
#sum(stop[i] * 1.9 for i in 1:12) + sum(supp[k] * D[1,k] * 5.9 for k in 1:3)
#Maximiser les dessertes
# @objective(model, Max, sum(zone[i] for i in 1:30))
@objective(model, Min, sum(stop[i] * 1.9 for i in 1:12) + sum(supp[k] * D[1,k] * 5.9 for k in 1:3)-sum(zone[i] for i in 1:30))

  #On veut forcément ouvrir la station de Landeau
  @constraint(model, cstr_Landeau, stop[1] == 1)
  #On veut forcément ouvrir la station de 2e
  @constraint(model, cstr_bidon, stop[2] == 1)
  #On veut forcément ouvrir la station de Carquefou Gare
  @constraint(model, cstr_Gare, stop[9] == 1)
  #On veut ouvrir au moins un des 3 arrêts après Carquefou Gare
  @constraint(model, cstr3, sum(stop[i] for i in 10:12) >=1 )
  #Le nombre de stations ouvertes doit être supérieur à p
  @constraint(model, nb_arret, sum(stop[i] for i in 1:12) <= p)
  #Zones desservies par une station ouverte
  @constraint(model, desservie1, zone[1] <= sum(desserte[1,j]*stop[j] for j in 1:12))
  @constraint(model, desservie2, zone[2] <= sum(desserte[2,j]*stop[j] for j in 1:12))
  @constraint(model, desservie3, zone[3] == sum(desserte[3,j]*stop[j] for j in 1:12))
  @constraint(model, desservie4, zone[4] == sum(desserte[4,j]*stop[j] for j in 1:12))
  @constraint(model, desservie5, zone[5] == sum(desserte[5,j]*stop[j] for j in 1:12))
  @constraint(model, desservie6, zone[6] == sum(desserte[6,j]*stop[j] for j in 1:12))
  @constraint(model, desservie7, zone[7] == sum(desserte[7,j]*stop[j] for j in 1:12))
  @constraint(model, desservie8, zone[8] == sum(desserte[8,j]*stop[j] for j in 1:12))
  @constraint(model, desservie9, zone[9] == sum(desserte[9,j]*stop[j] for j in 1:12))
  @constraint(model, desservie10, zone[10] == sum(desserte[10,j]*stop[j] for j in 1:12))
  @constraint(model, desservie11, zone[11] <= sum(desserte[11,j]*stop[j] for j in 1:12))
  @constraint(model, desservie12, zone[12] <= sum(desserte[12,j]*stop[j] for j in 1:12))
  @constraint(model, desservie13, zone[13] == sum(desserte[13,j]*stop[j] for j in 1:12))
  @constraint(model, desservie14, zone[14] == sum(desserte[14,j]*stop[j] for j in 1:12))
  @constraint(model, desservie15, zone[15] == sum(desserte[15,j]*stop[j] for j in 1:12))
  @constraint(model, desservie16, zone[16] == sum(desserte[16,j]*stop[j] for j in 1:12))
  @constraint(model, desservie17, zone[17] == sum(desserte[17,j]*stop[j] for j in 1:12))
  @constraint(model, desservie18, zone[18] == sum(desserte[18,j]*stop[j] for j in 1:12))
  @constraint(model, desservie19, zone[19] == sum(desserte[19,j]*stop[j] for j in 1:12))
  @constraint(model, desservie20, zone[20] == sum(desserte[20,j]*stop[j] for j in 1:12))
  @constraint(model, desservie21, zone[21] <= sum(desserte[21,j]*stop[j] for j in 1:12))
  @constraint(model, desservie22, zone[22] <= sum(desserte[22,j]*stop[j] for j in 1:12))
  @constraint(model, desservie23, zone[23] == sum(desserte[23,j]*stop[j] for j in 1:12))
  @constraint(model, desservie24, zone[24] == sum(desserte[24,j]*stop[j] for j in 1:12))
  @constraint(model, desservie25, zone[25] == sum(desserte[25,j]*stop[j] for j in 1:12))
  @constraint(model, desservie26, zone[26] == sum(desserte[26,j]*stop[j] for j in 1:12))
  @constraint(model, desservie27, zone[27] == sum(desserte[27,j]*stop[j] for j in 1:12))
  @constraint(model, desservie28, zone[28] == sum(desserte[28,j]*stop[j] for j in 1:12))
  @constraint(model, desservie29, zone[29] == sum(desserte[29,j]*stop[j] for j in 1:12))
  @constraint(model, desservie30, zone[30] == sum(desserte[30,j]*stop[j] for j in 1:12))

  #Contraintes pour calcul des couts
  # @constraint(model, arret_sup1, supp[3] == stop[12])
  # @constraint(model, arret_sup2, supp[2] == stop[11] - stop[12])
  # @constraint(model, arret_sup3, supp[1] <= (stop[10] - stop[11]))
  # @constraint(model, arret_sup4, supp[1] <= (stop[10] - stop[12]))

  # println("model : ", model)
  return model, stop, zone
end



# Appel pour optimisation
solverSelected = GLPK.Optimizer
model, model_x, model_zone = setFLP(solverSelected, 7)
println("Solving..."); optimize!(model)

# Afficher les résultats
println("z  = ", objective_value(model))
print("x  = "); println(value.(model_x))
print("zones : "); println(value.(model_zone))
