function obj = Community_WeightIndividual(GlobalDummy)
% ----------------------------------------------------------------------- 
%  Community_WeightIndividual.m 
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
         
if nargin > 0
    xPrimeSize = GlobalDummy.D;
    tempD = sqrt(GlobalDummy.Global.D);
    x = reshape(GlobalDummy.xPrime.dec, tempD, tempD);
    if isempty(GlobalDummy.Index)
        xPrimeVar = GlobalDummy.xPrime.dec;
        xIndex = GlobalDummy.xIndex;
        yIndex = GlobalDummy.yIndex;
        xg = xPrimeVar(xIndex,yIndex);
    else
        Index = GlobalDummy.Index;
        xg = x(Index,Index);
        xg = reshape(xg,1,GlobalDummy.D);
    end
    obj = xg;
	switch GlobalDummy.Global.encoding
        case 'binary'
			for i = 1:GlobalDummy.N-1
				xgroups = xg;              
				for j = 1:xPrimeSize            
					if rand > 0.8               
						if xgroups(j) == 1                   
							xgroups(j) = 0;%% can be changed if encoding 'binary'
						else
						xgroups(j) = 1;
						end
					end
				end
				obj = [obj;xgroups];
			end
		case 'real'
			for i = 1:GlobalDummy.N-1
				xgroups = xg;              
				for j = 1:xPrimeSize            
					if rand > 0.8               
						xgroups(j) = -1+2*rand;
					end
				end
				obj = [obj;xgroups];
			end
	end
end
end