
im = rgb2gray(imread('im1.png'));
sz = size(im);
pts = [];

for i = 1:sz(1)
    for j = 1:sz(2)
        if im(i, j) < 128
            pts = [pts [i;j]];
        end
    end
end

n = length(pts);

% S is not the similarity matrix, but the distance matrix
S = zeros(n);
for i = 1:n
    for j = 1:n
        S(i, j) = norm(pts(:, i) - pts(:, j));
    end
end

assignments = unormspecclust(S, 2, 'fullc', sqrt(var(S(:))));

% plot the points
colors = ['b' 'g' 'r' 'c' 'm' 'y' 'k' 'w'];
for i = 1:n
    plot(pts(1, i), pts(2, i), strcat(colors(assignments(i)), 'o'));
    hold on;
end
