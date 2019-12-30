classdef NREG7 < PROBLEM
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
% 1     MUSK1                               476     166       2
% 2     Semeion_handwritten_digit          1593     256      10
% 3     LSVT_voice_rehabilitation           126     310       2
% 4     ISOLET                             1557     617      26

    properties(Access = private)
        TrainIn;    % Input of training set
        TrainOut;   % Output of training set
    end
    methods
        %% Initialization
        function obj = NREG7()
            % Load data
            dataNo = obj.Global.ParameterSet(2);
            str = {'karate','polbooks','football','lesmis','dolphins','celegansneural'};
            CallStack = dbstack('-completenames');
            load(fullfile(fileparts(CallStack(1).file),'Dataset_EGA_2.mat'),'DatasetA');
%             Data = Dataset.(str{dataNo});
            obj.TrainIn     = DatasetA.(str{dataNo});
            load(fullfile(fileparts(CallStack(1).file),'Dataset_EGY_2.mat'),'Datasety');
            obj.TrainOut    = Datasety.(str{dataNo});
            % Parameter setting
            obj.Global.M        = 2;
            obj.Global.D        = size(obj.TrainOut,2).^2;
            obj.Global.lower    = zeros(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.encoding = 'binary';
        end
        %% Generate initial population
%         function PopDec = Init(obj,N)
% %             PopDec = (rand(N,obj.Global.D)).*randi([0 1],N,obj.Global.D);
%             PopDec = randi([0 1],N,obj.Global.D);
%         end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            PopDec   = logical(PopDec);
            PopObj   = zeros(size(PopDec,1),2);
            for i = 1 : size(PopObj,1)
                TransferedPop = reshape(PopDec(i,:),sqrt(obj.Global.D),sqrt(obj.Global.D));
                % Clear self connecting
                TransferedPop(logical(eye(size(TransferedPop))))=0;
                for j = 1:sqrt(obj.Global.D)
                    temp = (obj.TrainIn(:,:,j)*TransferedPop(:,j)-obj.TrainOut(:,j));
                    PopObj(i,1) = sum(temp.^2)+PopObj(i,1);
                end
                PopObj(i,2) = sum(sum(TransferedPop));
            end
            PopObj(:,1) = PopObj(:,1)/(size(obj.TrainOut,1)*sqrt(obj.Global.D));
        end
    end
end