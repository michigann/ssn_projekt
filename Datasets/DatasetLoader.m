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
        case 'iris'
            [X, T] = loadIrisDataset();
        case 'wine'
            [X, T] = loadWineDataset();
        case 'iris'
            [X, T] = loadIrisDataset();
        case 'wine'
            [X, T] = loadWineDataset();
        case 'iris'
            [X, T] = loadIrisDataset();
        case 'wine'
            [X, T] = loadWineDataset();    
    end
end

function [X, T] = loadIrisDataset()
    [X, T] = iris_dataset;
end

function [X, T] = loadWineDataset()
    [X, T] = wine_dataset;
end

function [X, T] = loadIonosphereDataset()
    load ionosphere;
    t = char(Y)';
    t = strrep(t,'g','1');
    t = strrep(t,'b','0'); 
    T = str2num(t');
end

function [X, T] = loadHTRU2Dataset()
    load '/Datasets/HTRU_2/HTRU_2.csv'
    X = HTRU_2(:,1:end-1);
    T = HTRU_2(:,end);
end


