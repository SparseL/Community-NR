function Population = Community_optimiseByNSGAII(GlobalDummy, inputPopulation, evaluations, isDummy)
% <algorithm> <N>
% Nondominated sorting genetic algorithm II

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
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
    [~,FrontNo,CrowdDis] = Community_EnvironmentalSelection(Population,GlobalDummy.N);
	maximum = currentEvaluations(GlobalDummy, isDummy) + evaluations;
    %% Optimization
    while currentEvaluations(GlobalDummy, isDummy) < maximum
        MatingPool = TournamentSelection(2,GlobalDummy.N,FrontNo,-CrowdDis);
        Offspring  = Community_GA(Population(MatingPool),GlobalDummy,isDummy);
        [Population,FrontNo,CrowdDis] = Community_EnvironmentalSelection([Population,Offspring],GlobalDummy.N);
    end
end

function e = currentEvaluations(GlobalDummy, isDummy)
    if isDummy == true  
        e = GlobalDummy.Global.evaluated;
    else
        e = GlobalDummy.evaluated;
    end
end