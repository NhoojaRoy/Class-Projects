using LinearAlgebra
using FileIO
using Images

img = load("Matisse.jpeg")
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



# It is clear from the SVD for this specific code that breaking down the channels and storing only the first k
# singular values is in some way efficient. However, for this specific case, using the 2-norm v/s Frobenius Norm seems
# to have minimal marginal difference i.e. both k values (equivalently number of singular values required) seem to be the same.
#
# Claude Code was used to debug syntax, and add the RGB channe; deconstruction. I am freshly learning Julia so some references to
# existing libraries were made using GeminiAi.