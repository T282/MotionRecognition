function y = unormspecclust(S, k, type, arg)
%% construct adjacency graph
    n = length(S);        
    W = zeros(n);
    
    % epsilon neighbourhood
    if strcmp(type, 'eps')
        eps = arg;
        for i = 1:n
            for j = 2:n
                if S(i, j) <= eps && i ~= j
                    W(i, j) = 1;
                end
            end
        end
    % k-nearest
    elseif strcmp(type, 'knear')
        kn = arg;
        % flag decides if the type of knn is mutual
        flg = 0;
        if kn < 0
            flg = 1;
            kn = -kn;
        end
        for i = 1:n
            [val, ind] = sort(S(i,:));
            for j = 1:kn
                if ind(j) ~= i
                    W(i, j) = exp(-S(i, j));
                end
            end
        end
        for i = 1:n
            for j = 1:n
                if i ~= j && W(i, j) == 0 && W(j, i) ~= 0
                    if flg
                        W(j, i) = 0;
                    else
                        W(i, j) = W(j, i);
                    end
                end
            end
        end
        
    % fully connected graph
    elseif strcmp(type, 'fullc')
        sig = arg;
        for i = 1:n
            for j = 1:n
                if i ~= j
                    W(i ,j) = exp(-(S(i, j)^2)/(sig^2));
                end
            end
        end
    % the input S is the similarity matrix to be used
    else
        W = S;
    end
    
%% degree and laplacian matrix
    D = zeros(n);
    for i = 1:n
        D(i, i) = sum(W(i, :));
    end
    
    L = D - W;
    
%% eigs and kmeans
    [V, ~] = eig(L);
    V = V(:, 1:k);
    [~, y] = vl_kmeans(V', k);
    
end