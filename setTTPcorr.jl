using JuMP, GLPK
include("distance.jl")

nbNav = 5; nbEvent = 8; T = 3600
modelTTP = Model(GLPK.Optimizer)

@variable(modelTTP, 0 <= event[1:nbEvent, 1:nbNav] <= T-1, Int)
@variable(modelTTP, p[1:nbEvent, 1:nbEvent, 1:nbNav], Int)

@objective(modelTTP, Min, sum(2*sum(event[j, nav] - event[j-1, nav] + T*p[j-1, j, nav] for j=2:8) + event[1, nav] - event[8, nav] + T * p[8, 1, nav] for nav=1:nbNav))

for navette=1:nbNav
  @constraint(modelTTP, 128 <= event[2, navette] - event[1, navette] + T*p[1, 2, navette]<= 142)
  @constraint(modelTTP, 30 <= event[3, navette] - event[2, navette] + T*p[2, 3, navette]<= 60)
  @constraint(modelTTP, 171 <= event[4, navette] - event[3, navette] + T*p[3, 4, navette]<= 189)
  @constraint(modelTTP, 40 <= event[5, navette] - event[4, navette] + T*p[4, 5, navette]<= 70)
  @constraint(modelTTP, 171 <= event[6, navette] - event[5, navette] + T*p[5, 6, navette]<= 189)
  @constraint(modelTTP, 30 <= event[7, navette] - event[6, navette] + T*p[6,7,navette] <= 60)
  @constraint(modelTTP, 128 <= event[8, navette] - event[7, navette] + T*p[7, 8, navette]<= 142)
  @constraint(modelTTP, 40 <= event[1, navette] - event[8, navette] + T*p[8, 1, navette] <= T - 70)
end

@constraint(modelTTP, event[1,1] == 0)

for nav = 1:nbNav-1
  @constraint(modelTTP, T/nbNav <= event[1, nav+1] - event[1, nav] <= T/nbNav)
end


optimize!(modelTTP)

# if termination_status(modelTTP) == MOI.OPTIMAL
  println("temps total : ", objective_value(modelTTP))
  println(value.(event))
    for nav in 1:nbNav
      for i=1:8
        print("N", nav," event ", i, ": "); println(value.(event[i, nav]))
      end
    end


# end
