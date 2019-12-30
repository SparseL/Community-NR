function weightIndList = Community_selectxPrimes(input,amount, method)
% Implements the selection of the x' solutions in WOF-SMPSO. 
% Three methods can be chosen. The first one uses the largest Crowding
% Distance values from the first non-dominated front. The second one
% uses a tournament selection on the population based on
% Pareto-dominance and Crowding Distance. The third option is 
% introduced in publication (1), see above, based on
% reference directions for the first m+1 chosen solutions and selects
% random solutions afterwards.    

% ----------------------------------------------------------------------- 
%  Community_selectxPrimes.m 
%  Copyright (C) 2019 Kai Wu
% 
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%  Author of this Code: 
%   Kai Wu <Kaiwu@stu.xidian.edu.cn>
%
%  This file belongs to the following publications:
%
%  1) Kai Wu, Jingl Liu, Xingxing Hao, Penghui Liu and Fang Shen
%     "An Evolutionary Multi-Objective Framework for Complex 
%     Network Reconstruction Using Community Structure" submitted to IEEE TEVC
%
%  Date of publication: 12.25.2019 
%  Last Update: 12.25.2019 
% -----------------------------------------------------------------------
    
    inputSize = size(input,2);
    switch method 
        case 1 %largest Crowding Distance from first front
            inFrontNo    = NDSort(input.objs,inf);
            weightIndList = [];
            i = 1;
            if inputSize < amount
                weightIndList = input;
            else
                while size(weightIndList,2) < amount 
                    left = amount - size(weightIndList,2);
                    theFront = inFrontNo == i;
                    newPop = input(theFront);
                    FrontNo    = NDSort(newPop.objs,inf);
                    CrowdDis   = CrowdingDistance(newPop.objs,FrontNo);
                    [~,I] = sort(CrowdDis,'descend');
                    until=min(left,size(newPop,2));
                    weightIndList = [weightIndList,newPop(I(1:until))];
                    i=i+1;
                end
            end
        case 2 %tournament selection by front and CD
            FrontNo    = NDSort(input.objs,inf);
            CrowdDis   = CrowdingDistance(input.objs,FrontNo);%%
            weightIndList = input(TournamentSelection(2,amount,FrontNo,-CrowdDis));
        case 3 % first m+1 by reference lines + fill with random
            objValues = input.objs;
            m = size(objValues,2);
            weightIndList = [];
            for i = 1:m
                vec = ones(1,m);
                vec(1,i) = 0;
                angles = pdist2(vec,objValues,'cosine');
                [minAngle,minIndex] = min(angles);
                weightIndList = [weightIndList,input(minIndex)];
            end
            if size(weightIndList,2) < amount
                vec = ones(1,m);
                angles = pdist2(vec,objValues,'cosine');
                [minAngle,minIndex] = min(angles);
                weightIndList = [weightIndList,input(minIndex)];
            end
            while size(weightIndList,2) < amount
                ind = input(randi([1 inputSize],1,1));
                weightIndList = [weightIndList,ind];
            end
        case 4 % first m+1 by reference lines + fill with random
            objValues = input.objs;
            if inputSize < amount
                weightIndList = input;
            else
                [~,m] = min(objValues(1,:));
                weightIndList = input(m(1));
            end
    end
end