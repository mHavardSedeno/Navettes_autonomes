using JuMP, GLPK
include("distance.jl")

nbNav = 2; nbEvent = 28; T = 3600
modelTTP = Model(GLPK.Optimizer)

@variable(modelTTP, 0 <= event[1:nbEvent, 1:nbNav] <= T-1, Int)
@variable(modelTTP, p[1:nbEvent, 1:nbEvent, 1:nbNav], Int)

@objective(modelTTP, Min, sum(2*sum(event[j, nav] - event[j-1, nav] + T*p[j-1, j, nav] for j=2:nbEvent) + event[1, nav] - event[8, nav] + T * p[nbEvent, 1, nav] for nav=1:nbNav))

for navette=1:nbNav
  @constraint(modelTTP, 153 <= event[2, navette] - event[1, navette] + T*p[1, 2, navette]<= 168)
  @constraint(modelTTP, 30 <= event[3, navette] - event[2, navette] + T*p[2, 3, navette]<= 60)
  @constraint(modelTTP, 103 <= event[4, navette] - event[3, navette] + T*p[3, 4, navette]<= 114)
  @constraint(modelTTP, 30 <= event[5, navette] - event[4, navette] + T*p[4, 5, navette]<= 60)
  @constraint(modelTTP, 157 <= event[6, navette] - event[5, navette] + T*p[5, 6, navette]<= 173)
  @constraint(modelTTP, 30 <= event[7, navette] - event[6, navette] + T*p[6,7,navette] <= 60)
  @constraint(modelTTP, 192 <= event[8, navette] - event[7, navette] + T*p[7, 8, navette]<= 213)
  @constraint(modelTTP, 30 <= event[9, navette] - event[8, navette] + T*p[8, 9, navette] <= 60)
  @constraint(modelTTP, 290 <= event[10, navette] - event[9, navette] + T*p[9, 10, navette]<= 321)
  @constraint(modelTTP, 30 <= event[11, navette] - event[10, navette] + T*p[10, 11, navette]<= 60)
  @constraint(modelTTP, 363 <= event[12, navette] - event[11, navette] + T*p[11, 12, navette]<= 401)
  @constraint(modelTTP, 30 <= event[13, navette] - event[12, navette] + T*p[12, 13, navette]<= 60)
  @constraint(modelTTP, 92 <= event[14, navette] - event[13, navette] + T*p[13, 14, navette]<= 101)
  @constraint(modelTTP, 40 <= event[15, navette] - event[14, navette] + T*p[14,15,navette] <= 70)
  @constraint(modelTTP, 92 <= event[16, navette] - event[15, navette] + T*p[15, 16, navette]<= 101)
  @constraint(modelTTP, 30 <= event[17, navette] - event[16, navette] + T*p[16, 17, navette] <= 60)
  @constraint(modelTTP, 363 <= event[18, navette] - event[17, navette] + T*p[17, 18, navette]<= 401)
  @constraint(modelTTP, 30 <= event[19, navette] - event[18, navette] + T*p[18, 19, navette]<= 60)
  @constraint(modelTTP, 290 <= event[20, navette] - event[19, navette] + T*p[19, 20, navette]<= 321)
  @constraint(modelTTP, 30 <= event[21, navette] - event[20, navette] + T*p[20, 21, navette]<= 60)
  @constraint(modelTTP, 192 <= event[22, navette] - event[21, navette] + T*p[21, 22, navette]<= 213)
  @constraint(modelTTP, 30 <= event[23, navette] - event[22, navette] + T*p[22, 23, navette] <= 60)
  @constraint(modelTTP, 157 <= event[24, navette] - event[23, navette] + T*p[23, 24, navette]<= 173)
  @constraint(modelTTP, 30 <= event[25, navette] - event[24, navette] + T*p[24, 25,navette] <= 60)
  @constraint(modelTTP, 103 <= event[26, navette] - event[25, navette] + T*p[25, 26, navette]<= 114)
  @constraint(modelTTP, 30 <= event[27, navette] - event[26, navette] + T*p[26, 27, navette]<= 60)
  @constraint(modelTTP, 153 <= event[28, navette] - event[27, navette] + T*p[27, 28, navette]<= 168)
  @constraint(modelTTP, 40 <= event[1, navette] - event[28, navette] + T*p[28, 1, navette]<= T-70)
end

@constraint(modelTTP, event[1,1] == 0)
for t=1:27
  @constraint(modelTTP, event[t,2] <= event[t+1,2])
end

for nav = 1:nbNav-1
  @constraint(modelTTP, T/nbNav <= event[1, nav+1] - event[1, nav] <= T)
end


optimize!(modelTTP)

# if termination_status(modelTTP) == MOI.OPTIMAL
  println("temps total : ", objective_value(modelTTP))
  println(value.(event))
    for nav in 1:nbNav
      for i=1:28
        print("N", nav," event ", i, ": "); println(value.(event[i, nav]))
      end
    end


# end
