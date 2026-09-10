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