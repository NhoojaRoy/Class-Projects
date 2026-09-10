using LinearAlgebra

A = [1 im;
    im -1]

F = eigen(A)
Λ, V = Diagonal(F.values), F.vectors

println("\nEigenvalues")
display(Λ)
println("\nEigenvectors")
display(V)

C = V * Λ * V'

println("\nConjugate Transpose Decomposition Matrix")
display(C)

B = V * Λ * inv(V)

println("\nInverse Decomposition Matrix")
display(B)

println("\nDeterminant of V:")
println(det(V))

r = rank(A)
vr = rank(V)


println("\nRank of A:")
display(r)

println("\nRank of V:")
display(vr)
