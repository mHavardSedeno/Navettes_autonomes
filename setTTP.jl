using JuMP
using GLPK
include("distance.jl")

function setTTP(solverSelected)

  model = Model(with_optimizer(solverSelected))

  T = 3600; nbEvent = 8; nbNav = 1; nbTraj = 2;
  @variable(model, 0 <= event[1:nbEvent,1:nbTraj, 1:nbNav] <= T-1, Int) #évènement correspondant au temps en secondes du  début de l'activité pour la navette 1
  @variable(model, p[1:nbEvent, 1:nbEvent, 1:nbTraj], Int) #évènement correspondant au temps en secondes du  début de l'activité pour la navette 2

  time = [128, 142, 30, 60, 171, 189, 40, 70, 171, 189, 30, 60, 128, 142, 40, 70]
  navette = 1
  # @objective(model, Min, sum(N1_event[j]-N1_event[i], j=1:8, i=1:8)) #8 évènements dans le cas didactique
  # @objective(model, Min, sum(sum(event[j, navette] - event[j-1, navette] +  T*p[j-1, j, navette] for j in 2:nbEvent) + event[1, navette] - event[8, navette] + T*p[8, 1, navette] for navette in 1:nbTraj))
  @objective(model, Min, sum(nbTraj * sum(event[j, traj, navette] - event[j-1, traj, navette] for j in 2:nbEvent) for traj in 1:nbTraj))

for navette in 1:nbNav
  for traj = 1:nbTraj
    @constraint(model, 128 <= event[2, traj, navette]- event[1, traj, navette] <= 142)
    @constraint(model, 30 <= event[3, traj, navette] - event[2, traj, navette] <= 60)
    @constraint(model, 171 <= event[4, traj, navette]-event[3, traj, navette] <= 189)
    @constraint(model, 40 <= event[5, traj, navette] - event[4, traj, navette] <= 70)
    @constraint(model, 171 <= event[6, traj, navette]-event[5, traj, navette] <= 189)
    @constraint(model, 30 <= event[7, traj, navette] - event[6, traj, navette] <= 60)
    @constraint(model, 128 <= event[8, traj, navette]-event[7, traj, navette] <= 142)
    @constraint(model, 40 <= event[1, navette]-event[8, navette] <= T - 70)
  end

  for traj = 1:nbTraj-1
    @constraint(model, 30 <= event[1, traj+1, navette] - event[1, traj, navette] <= T/nbTraj)
  end
end

# @constraint(model, event[1, 1, 2] - event[1, 1, 1] == T/nbNav)

# for navette = 1:nbTraj
#   @constraint(model, 128 <= event[2, navette] - event[1, navette] + T*p[1, 2, navette]<= 142)
#   @constraint(model, 30 <= event[3, navette] - event[2, navette] + T*p[2, 3, navette]<= 60)
#   @constraint(model, 171 <= event[4, navette] - event[3, navette] + T*p[3, 4, navette]<= 189)
#   @constraint(model, 40 <= event[5, navette] - event[4, navette] + T*p[4, 5, navette]<= 70)
#   @constraint(model, 171 <= event[6, navette] - event[5, navette] + T*p[5, 6, navette]<= 189)
#   @constraint(model, 30 <= event[7, navette] - event[6, navette] + T*p[6,7,navette] <= 60)
#   @constraint(model, 128 <= event[8, navette] - event[7, navette] + T*p[7, 8, navette]<= 142)
#   @constraint(model, 40 <= event[1, navette] - event[8, navette] + T*p[8,1, navette] <= T - 70)
# end



  optimize!(model)

  if termination_status(model) == MOI.OPTIMAL
    println("temps total : ", objective_value(model))
    for nav in 1:nbNav
      println("Navette ", nav, " :")
      for traj in 1:nbTraj
        for i=1:8
          print("N", traj," event ", i, ": "); println(value.(event[i, traj, navette]))
        end
      end
    end
  end
  return model, event
end


###########################################

using JuMP, GLPK
include("distance.jl")

nbNav = 2; nbEvent = 8; T = 3600
modelTTP = Model(GLPK.Optimizer)

@variable(modelTTP, 0 <= event[1:nbEvent, 1:nbNav] <= T-1, Int)
@variable(modelTTP, p[1:nbEvent, 1:nbEvent, 1:nbNav], Int)

@objective(modelTTP, Min, sum(2*sum(event[j, nav] - event[j-1, nav] + T*p[j-1, j, nav] for j=2:nbEvent) + event[1, nav] - event[8, nav] + T*p[nbEvent, 1, nav] for nav=1:nbNav))

for navette=1:nbNav
    @constraint(modelTTP, 128 <= event[2, navette] - event[1, navette] + T*p[1, 2, navette]<= 142)
    @constraint(modelTTP, 30 <= event[3, navette] - event[2, navette] + T*p[2, 3, navette]<= 60)
    @constraint(modelTTP, 171 <= event[4, navette] - event[3, navette] + T*p[3, 4, navette]<= 189)
    @constraint(modelTTP, 40 <= event[5, navette] - event[4, navette] + T*p[4, 5, navette]<= 70)
    @constraint(modelTTP, 171 <= event[6, navette] - event[5, navette] + T*p[5, 6, navette]<= 189)
    @constraint(modelTTP, 30 <= event[7, navette] - event[6, navette] + T*p[6,7,navette] <= 60)
    @constraint(modelTTP, 128 <= event[8, navette] - event[7, navette] + T*p[7, 8, navette]<= 142)
    @constraint(modelTTP, 40 <= event[1, navette] - event[8, navette] + T*p[8,1, navette] <= T - 70)
end

@constraint(modelTTP, event[1,1] == 0)

for t=1:nbEvent-1
  @constraint(modelTTP, event[t,2] <= event[t+1,2])
end

for nav = 1:nbNav-1
  @constraint(modelTTP, 30 <= event[1, nav+1] - event[1, nav] <= T/nbNav)
end


optimize!(modelTTP)

# if termination_status(modelTTP) == MOI.OPTIMAL
  println("temps total : ", objective_value(modelTTP))
  println(value.(event))
    for nav in 1:nbNav
      println(value.(event))
      # for i=1:8
      #   print("N", nav," event ", i, ": "); println(value.(event[i, nav]))
      # end
    end


# end
