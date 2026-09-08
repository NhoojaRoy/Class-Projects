using LinearAlgebra
using FileIO
using Images

img = load("/Users/nhoojaroy/Desktop/Smoke Simulation/Class-Projects/Matisse.jpeg")
display(img)
display(size(img))
R = Float64.(red.(img))
G = Float64.(green.(img))
B = Float64.(blue.(img))

function specific_decomp(channel, k)
    F = svd(channel)
    return F.U[:, 1:k] * Diagonal(F.S[1:k]) * F.Vt[1:k, :]
end

function find_k(gray_matrix, F)
    start = 4
    needed = length(F.S)
    for k in start:length(F.S)
        if norm(gray_matrix - specific_decomp(gray_matrix, k), 2) <= 0.05 * norm(gray_matrix, 2)
            needed = k
            break
        end
    end
    println("l-2 Norm")
    for m in needed-5: needed
        err = norm(gray_matrix - specific_decomp(gray_matrix, m))
        display(err)
    end
    return needed
end

function find_k_F(gray_matrix, F)
    start = 4
    needed = length(F.S)
    for k in start:length(F.S)
        if norm(gray_matrix - specific_decomp(gray_matrix, k)) <= 0.05 * norm(gray_matrix)
            needed = k
            break
        end
    end
    println("Frobenius Norm")
    for m in needed-5: needed
        err = norm(gray_matrix - specific_decomp(gray_matrix, m))
        display(err)
    end
    return needed
end

function reconstruct(kF)
    R_approx2 = clamp.(specific_decomp(R, kF), 0.0, 1.0)
    G_approx2 = clamp.(specific_decomp(G, kF), 0.0, 1.0)
    B_approx2 = clamp.(specific_decomp(B, kF), 0.0, 1.0)
    reconstructed = RGB.(R_approx2, G_approx2, B_approx2)
    display(reconstructed)
    return reconstructed
end


gray = (R .+ G .+ B) ./ 3
F = svd(gray)
k = find_k(gray, F)
kF = find_k_F(gray, F)

img_k = reconstruct(k)
img_kF = reconstruct(kF)

save("reconstructed_k.jpg", img_k)
save("reconstructed_kF.jpg", img_kF)

display(k)
display(kF)



"""
Project Report:

1. The 2-norm implemented on the image matrix gave a bound of k = 195 singular values for a relative error of
    5%. The F-norm similarly pointed towards a set of the first 195 singular values to contain the compression error to less than 5%.
    The error values for the last two k = 194, 195 for each of the norms are:
        Frobenius: 13.435309919693124, 13.325011055009652
        2-Norm: 13.435309919693124, 13.325011055009652

    For the last few error values for k -> 195, it also looks like the errors are floating close to each other, which is an interesting
    finding for the matrix.

2. If A is an m x n, A_k can be stored with k(m+n+1) many values, because compressing the matrix means we are only storing the first k-singular values.
    In the expression this is + k term, in k x m + k x n + k. Similarly, we are only storing first k columns of U, and first k rows of the V^* matrix,
    totaling to k(m + n + 1)

3. AI was used to aid the completion of this project. I am new to Julia so it was primarily used to query translations of python code to Julia, and find
    needed libraries for project complettion. Particularly, Claude AI was used for the RGB deconstruction process, originally, the reconstructed image I created was grayscale.
    For library and function/ method queries Gemini was used.

4. Not sure how to check storage space of each original, and compressed matrices for this scenario. Since some deconstruction into RGB channel was made, I am expecting to have to find
    storage(R+G+B), or something similar.

"""