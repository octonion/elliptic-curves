

mutable struct EllipticCurve
    a1
    a2
    a3
    a4
    a6
end

mutable struct Point
    x
    y
    E
end

function Base.:(-)(a::Point)
    Point(a.x,-a.E.a1*a.x-a.E.a3-a.y,a.E)
end

function Base.:(+)(a::Point, b::Point)
    if !(a.E == b.E)
        error("error: elliptic curve must be the same")
    end
    if (a == b)
        L = (3*a.x^2+2*a.E.a2*a.x-a.E.a1*a.y+a.E.a4)//(2*a.y+a.E.a1*a.x+a.E.a3)
        x = L^2+L*a.E.a1-a.E.a2-2*a.x
        y = L*x-L*a.x+a.y
        Point(x,-y,a.E)
    else
        L = (b.y-a.y)//(b.x-a.x)
        x = L^2+L*a.E.a1-a.E.a2-a.x-b.x
        y = L*x-L*a.x+a.y
        Point(x,-y,a.E)
    end
end

function Base.:(*)(n::Integer, P::Point)
    Q = nothing
    F = P
    m = n
    while m >= 1
        if (m % 2==1)
            if Q==nothing
                Q = F
            else
                Q += F
            end
        end
        m = floor(m/2)
        F += F
    end
    Q
end

E = EllipticCurve(BigInt(0),BigInt(109),BigInt(0),BigInt(224),BigInt(0))

P = Point(BigInt(-100),BigInt(260),E)
    
println(P)
println(-P)
println(P+P)
Q = 9*P

sa = (56-Q.x+Q.y)//(56-14*Q.x)
sb = (56-Q.x-Q.y)//(56-14*Q.x)
sc = (-28-6*Q.x)//(28-7*Q.x)
l = lcm(denominator(sa),denominator(sb),denominator(sc))
println(numerator(sa*l))
println(numerator(sb*l))
println(numerator(sc*l))

