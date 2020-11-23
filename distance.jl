#Données
coord = [47.23241 -1.516079;
        47.240043 -1.512399;
        47.245229 -1.509943;
        47.252978 -1.505651;
        47.262416 -1.500158;
        47.274675 -1.493163;
        47.276644 -1.491907;
        47.282933 -1.486125;
        47.295268 -1.485513;
        47.297251 -1.492025;
        47.299027 -1.499150;
        47.304760 -1.502969]

#Calcul
function distance(lat1, lon1, lat2, lon2)

        R = 6371e3; # metres
        φ1 = lat1 * π/180; # φ, λ in radians
        φ2 = lat2 * π/180;
        Δφ = (lat2-lat1) * π/180;
        Δλ = (lon2-lon1) * π/180;

        a = sin(Δφ/2) * sin(Δφ/2) +
                  cos(φ1) * cos(φ2) *
                  sin(Δλ/2) * sin(Δλ/2);
        c = 2 * atan(sqrt(a), sqrt(1-a));

        d = R * c; # in metres

        return d
end

function OD_distance(points)
        dist = []

        for i in 1:11
                d_curr = distance(coord[i,1], coord[i,2], coord[i+1,1], coord[i+1,2])
                push!(dist, d_curr)
        end
        
        return dist
end
