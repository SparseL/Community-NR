function [outIndexList, groups] = Community_createGroups(xPrime)
% Creates groups of the varibales. Three diffeent methods can be
% chosen. The first one uses linear groups, the second orders variables
% by absolute values, the third is a random grouping. 
    
% ----------------------------------------------------------------------- 
%  Community_createGroups.m 
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
    %community-based Grouping
    vars = xPrime.dec;
    vars(abs(vars)>0.05) = 1; vars(abs(vars)<0.05) = 0;
    % 1*MM->M*M
    numberOfNodes = sqrt(length(xPrime.dec));
    varsafter = reshape(vars,numberOfNodes,numberOfNodes);
    modvec = cluster_jl(varsafter);
    outIndexList = modvec.COM{end};
    groups = length(modvec.SIZE{end});
end