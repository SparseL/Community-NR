classdef NRFCM9 < PROBLEM
% <problem> <Sparse MOP>
% The feature selection problem
% dataNo --- 1 --- Number of dataset

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% The datasets are taken from the UCI machine learning repository in
% http://archive.ics.uci.edu/ml/index.php
% No.   Name                              Samples Features Classes

    properties(Access = private)
        TrainIn;    % Input of training set
        TrainOut;   % Output of training set
    end
    methods
        %% Initialization
        function obj = NRFCM9()
            % Load data
            dataNo = obj.Global.ParameterSet(4);
            str = {'karate','polbooks','football','lesmis','dolphins','celegansneural'};
            CallStack = dbstack('-completenames');
            load(fullfile(fileparts(CallStack(1).file),'Dataset_FCMA_2.mat'),'DatasetA');
%             Data = Dataset.(str{dataNo});
            obj.TrainIn     = DatasetA.(str{dataNo});
            load(fullfile(fileparts(CallStack(1).file),'Dataset_FCMY_2.mat'),'Datasety');
            obj.TrainOut    = Datasety.(str{dataNo});
            % Parameter setting
            obj.Global.M        = 2;
            obj.Global.D        = size(obj.TrainOut,2).^2;
            obj.Global.lower    = -1.*ones(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            PopObj   = zeros(size(PopDec,1),2);
            for i = 1 : size(PopObj,1)
                TransferedPop = reshape(PopDec(i,:),sqrt(obj.Global.D),sqrt(obj.Global.D));
                % Clear self connecting
                TransferedPop(logical(eye(size(TransferedPop))))=0;
                for j = 1:sqrt(obj.Global.D)
                    temp = (sigmoid(obj.TrainIn*TransferedPop(:,j))-obj.TrainOut(:,j));
                    PopObj(i,1) = sum(temp.^2)+PopObj(i,1);
                end
                PopObj(i,2) = sum(sum(abs(TransferedPop)));
            end
            PopObj(:,1) = PopObj(:,1)/(size(obj.TrainOut,1)*sqrt(obj.Global.D));
        end
    end
end

function sigm = sigmoid(x)

    sigm = 1 ./ (1 + exp(-x));
end