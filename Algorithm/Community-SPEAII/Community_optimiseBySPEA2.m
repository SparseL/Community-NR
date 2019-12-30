function Population = Community_optimiseBySPEA2(GlobalDummy, inputPopulation, evaluations, isDummy)
% <algorithm> <S>
% Strength Pareto evolutionary algorithm 2

%------------------------------- Reference --------------------------------
% E. Zitzler, M. Laumanns, and L. Thiele, SPEA2: Improving the strength
% Pareto evolutionary algorithm, Proceedings of the Fifth Conference on
% Evolutionary Methods for Design, Optimization and Control with
% Applications to Industrial Problems, 2001, 95-100.
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
    Fitness    = CalFitness(Population.objs);
    maximum = currentEvaluations(GlobalDummy, isDummy) + evaluations;
    %% Optimization
    while currentEvaluations(GlobalDummy, isDummy) < maximum
        MatingPool = TournamentSelection(2,GlobalDummy.N,Fitness);
        Offspring  = Community_GA(Population(MatingPool),GlobalDummy,isDummy);
        [Population,Fitness] = Community_EnvironmentalSelection([Population,Offspring],GlobalDummy.N);
    end
end

function e = currentEvaluations(GlobalDummy, isDummy)
    if isDummy == true  
        e = GlobalDummy.Global.evaluated;
    else
        e = GlobalDummy.evaluated;
    end
end