function Population = Community_optimiseBySMSEMOA(GlobalDummy, inputPopulation, evaluations, isDummy)
% <algorithm> <S>
% S metric selection based evolutionary multiobjective optimization
% algorithm

%------------------------------- Reference --------------------------------
% M. Emmerich, N. Beume, and B. Naujoks, An EMO algorithm using the
% hypervolume measure as selection criterion, Proceedings of the
% International Conference on Evolutionary Multi-Criterion Optimization,
% 2005, 62-76.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Generate random population
    Population = inputPopulation;
    FrontNo    = NDSort(Population.objs,inf);
    maximum = currentEvaluations(GlobalDummy, isDummy) + evaluations;
    %% Optimization
    while currentEvaluations(GlobalDummy, isDummy) < maximum
        for i = 1 : GlobalDummy.N
            drawnow();
            Offspring = Community_GAhalf(Population(randperm(end,2)),GlobalDummy,isDummy);
            [Population,FrontNo] = Reduce([Population,Offspring],FrontNo);
        end
    end
end

function e = currentEvaluations(GlobalDummy, isDummy)
    if isDummy == true  
        e = GlobalDummy.Global.evaluated;
    else
        e = GlobalDummy.evaluated;
    end
end