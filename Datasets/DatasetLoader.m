function [X, T] = DatasetLoader(dataset)
    switch dataset
        case 'iris'
            [X, T] = loadIrisDataset();
        case 'wine'
            [X, T] = loadWineDataset(); 
        case 'ionosphere'
            [X, T] = loadIonosphereDataset();
        case 'htru2'
            [X, T] = loadHTRU2Dataset();
        case 'arrhythmia'
            [X, T] = loadArrhythmiaDataset();
        case 'votes'
            [X, T] = loadCongressionalVotingsDataset();
        case 'ovariancancer'
            [X, T] = loadOvariancancerDataset();
        case 'glass'
            [X, T] = loadGlassDataset();
        case 'yeast'
            [X, T] = loadYeastDataset();
        case 'parkinson'
            [X, T] = loadParkinsonDataset();  
    end
end

%[3]
function [X, T] = loadIrisDataset()
    [X, T] = iris_dataset;
end

%[6]
function [X, T] = loadWineDataset()
    [X, T] = wine_dataset;
end

%[4]
function [X, T] = loadIonosphereDataset()
    load ionosphere;
    t = char(Y)';
    t = strrep(t,'g','1');
    t = strrep(t,'b','0'); 
    T = str2num(t');
end

%[10]
function [X, T] = loadHTRU2Dataset()
    load Datasets/HTRU_2/HTRU_2.csv
    X = HTRU_2(:,1:end-1);
    T = HTRU_2(:,end);
end

%[8]
function [X, T] = loadArrhythmiaDataset()
    load arrhythmia;
    X = X';
    binDim = length(dec2bin(max(Y)));
    Y = dec2bin(Y, binDim);
    targets = zeros(size(Y, 1), binDim);
    for i=1:size(targets, 1)
        targets(i, : ) = str2num(Y(i, : )')';
    end
    targets = targets';
    T = targets;
end

%[2]
function [X, T] = loadCongressionalVotingsDataset()
    f = fopen('Datasets/CongressionalVotings/house-votes-84.data');
    
    X = [];
    T = [];

    tline = fgetl(f);
    while ischar(tline)
        tline = strrep(tline,',y',',1');
        tline = strrep(tline,',n',',0');
        tline = strrep(tline,',?',',0.5');
        tline = strsplit(tline, ',');
      
        T = [T strcmp(tline{1}, 'democrat')];
        
        tline = tline(2:end);
        tline = cellfun(@str2num, tline);
        X = [X; tline];  
        tline = fgetl(f);
    end
    X = X';
    fclose(f);
end

function [X, T] = loadOvariancancerDataset()
    load ovariancancer.mat;
    inputs = obs';
    targets = zeros(1, size(grp, 1));
    for i=1:size(grp, 1)
       if grp{i} == 'Cancer'
           targets(i) = 1;
       else
           targets(i) = 0;
       end
    end
    X = inputs;
    T = targets;
end

%[20 5]
function [X, T] = loadGlassDataset()
    load Datasets/Glass/glass.data;

    inputs = glass(:, 2:size(glass, 2)-1)';
    Y = glass(:, size(glass, 2));
    matrixSize = max(Y);
    targets = zeros(matrixSize, size(Y, 1));
    for i=1:size(Y, 1)
       targets(Y(i), i) = 1; 
    end
    
    X = inputs;
    T = targets;
end

%[30]
function [X, T] = loadYeastDataset()
    f = fopen('Datasets/Yeast/yeast.data');
    
    X = [];
    T = [];

    tline = fgetl(f);
    while ischar(tline)
        tline = strsplit(tline);
        
        switch tline{end}
            case 'CYT'
                t = [0 0 0 0 0 0 0 0 0 1];
            case 'NUC'
                t = [0 0 0 0 0 0 0 0 1 0];
            case 'MIT'
                t = [0 0 0 0 0 0 0 1 0 0];
            case 'ME3'
                t = [0 0 0 0 0 0 1 0 0 0];
            case 'ME2'
                t = [0 0 0 0 0 1 0 0 0 0];
            case 'ME1'
                t = [0 0 0 0 1 0 0 0 0 0];
            case 'EXC'
                t = [0 0 0 1 0 0 0 0 0 0];
            case 'VAC'
                t = [0 0 1 0 0 0 0 0 0 0];
            case 'POX'
                t = [0 1 0 0 0 0 0 0 0 0];
            case 'ERL'
                t = [1 0 0 0 0 0 0 0 0 0];
        end
        T = [T; t];
        
        x = cellfun(@str2num, tline(2:end-1));
        X = [X; x];
        
        tline = fgetl(f);
    end
    
    fclose(f); 
    
    X = X';
    T = T';
end

%[4]
function [X, T] = loadParkinsonDataset()
    load Datasets\Parkinson\train_data.txt;
    load Datasets\Parkinson\test_data.txt;
    train = [train_data(:, 1:27) train_data(:, 29)];
    data = [test_data; train];
    X = data(:, 1:27)';
    T = data(:, 28)';
end

