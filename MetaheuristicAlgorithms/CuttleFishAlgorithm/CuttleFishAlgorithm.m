%{
1- Initialize the population with random solutions,
calculate and keep the best solution and the average
value of the best solution’s points.
2- Use interaction operator between chromatophores
and iridophores cells in case 1 and 2, to produce a
new solution based on the reflection and the visibility
of pattern (global search).
3- Use iridophores cells operators in case 3 and 4 to
calculate new solutions based on the reflected light
coming from best solution and the visibility of
matching pattern (local search).
4- Use leucophores cells operator in case 5 to produce
new solution by reflecting light from the area around
the best solution and visibility of the pattern (local
search).
5- Use leucophores cells operator in case 6 for random
solution by reflecting incoming light (global search).
%}

function BestPosition = CuttleFishAlgorithm(params, fitness)

    %% INITIALIZATION
    N = params{1};
    max_iter = params{2};
    lower = params{3};
    upper = params{4};
    dim = params{5};

    r1 = 1;
    r2 = -0.5;
    v1 = 1;
    v2 = -1;

    x = init(N, dim, lower, upper);
    fit = fitness(x);
    minfit = min(fit);
    prevMinfit = minfit;
    BestIdx = find(fit == minfit);
    BestPosition = x(BestIdx(1), :);
    xCurrIdx = BestIdx;
    xCurr = x(xCurrIdx(1), :);
    fitCurr = fit;

    %divide population into 4 groups
    gSplit = zeros(4, 1);
    splitN = floor(N / 4);
    for i=1:3
        gSplit(i) = splitN;
    end
    gSplit(4) = N - 3 * splitN;
    groupsC = mat2cell(x, gSplit, dim);

    %% CALCULATIONS

    for t=1:max_iter
        %calculate the average value of the best solution
        % !!!! which average ? ordinary arithmetic ? !!!!
        AVBest = 0;%mean(BestPosition);

        % Case 1 & 2
        G = groupsC{1};
        for cIdx=1:size(G, 1)
            cell = G(cIdx, :);
            %calculations
            R = rand() * (r1 - r2) + r2;
            V = 1;

            reflection = R * cell;
            visibility = V * (BestPosition - cell);
            newcell = reflection + visibility;
            x(cIdx, :) = newcell;

            fit = fitness(newcell);
            if fit < minfit
                minfit = fit;
                BestPosition = x(cIdx, :);
                fitCurr = fit;
                xCurr = BestPosition;
            elseif fit < fitCurr
                fitCurr = fit;
                xCurr = x(cIdx, :);
            end
        end
        prevGroupSize = size(G, 1);

        % Case 3 & 4
        G = groupsC{2};
        for cIdx=1:size(G, 1)
            cell = G(cIdx, :);
             %calculations
            R = 1;
            V = rand() * (v1 - v2) + v2;

            reflection = R * BestPosition;
            visibility = V * (BestPosition - cell);
            newcell = reflection + visibility;
            x(prevGroupSize + cIdx, :) = newcell;

            fit = fitness(newcell);
            if fit < minfit
                minfit = fit;
                BestPosition = x(prevGroupSize + cIdx, :);
                fitCurr = fit;
                xCurr = BestPosition;
            elseif fit < fitCurr
                fitCurr = fit;
                xCurr = x(prevGroupSize + cIdx, :);
            end
        end
        prevGroupSize = prevGroupSize + size(G, 1);

        % Case 5
        G = groupsC{3};
        for cIdx=1:size(G, 1)
            cell = G(cIdx, :);
             %calculations
            R = 1;
            V = rand() * (v1 - v2) + v2;

            reflection = R * BestPosition;
            visibility = V * (BestPosition - AVBest);
            newcell = reflection + visibility;
            x(prevGroupSize + cIdx, :) = newcell;

            fit = fitness(newcell);
            if fit < minfit
                minfit = fit;
                BestPosition = x(prevGroupSize + cIdx, :);
                fitCurr = fit;
                xCurr = BestPosition;
            elseif fit < fitCurr
                fitCurr = fit;
                xCurr = x(prevGroupSize + cIdx, :);
            end
        end
        prevGroupSize = prevGroupSize + size(G, 1);

        % Case 6
        G = groupsC{4};
        for cIdx=1:size(G, 1)
            cell = G(cIdx, :);
            for i=1:dim
                newcell(i) = lower + (upper - lower) * rand();
            end
            x(prevGroupSize + cIdx, :) = newcell;

            fit = fitness(newcell);
            if fit < minfit
                minfit = fit;
                BestPosition = x(prevGroupSize + cIdx, :);
                fitCurr = fit;
                xCurr = BestPosition;
            elseif fit < fitCurr
                fitCurr = fit;
                xCurr = x(prevGroupSize + cIdx, :);
            end
        end
        if prevMinfit ~= minfit
             %disp(strcat(num2str(t), ':    ', num2str(minfit, '%10.15e')))
            prevMinfit = minfit;
        end

    end
    % disp(strcat('Best: ', num2str(minfit, '%10.15e')))

end