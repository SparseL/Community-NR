classdef C_WeightIndividual < handle
% C_WeightIndividual - The class of an individual used in CEMNR to store
% variables. It is derived from the "INDIVIDUAL" class of the
% PlatEMO framework and adjusted to fit the CEMNR  algorithm. 

% ----------------------------------------------------------------------- 
%  C_WeightIndividual.m 
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
    
% Original copyright disclaimer of the "Individual" class of the 
% PlatEMO framework version 1.5: 
    
    properties(SetAccess = private)
        dec;        % Decision variables of the individual
        obj;        % Objective values of the individual
        con;        % Constraint values of the individual
        add;        % Additional properties of the individual
        ind;        % the actual individual to extract later
    end
    methods
        %% Constructor
        function obj = C_WeightIndividual(variables, GlobalDummy, addValues)
            
            if nargin > 0
                obj = C_WeightIndividual;
                if isempty(GlobalDummy.Index)
                    tempIND = GlobalDummy.xPrime.dec;
                    xIndex = GlobalDummy.xIndex;
                    yIndex = GlobalDummy.yIndex;
                    tempIND(xIndex,yIndex) = variables;
                else
                    Index = GlobalDummy.Index;
                    tempD = sqrt(GlobalDummy.Global.D);
                    x = reshape(GlobalDummy.xPrime.dec, tempD, tempD);
                    xgroups = reshape(variables,sqrt(GlobalDummy.D),sqrt(GlobalDummy.D));
                    x(Index,Index) = xgroups;
                    tempIND = reshape(x,1,GlobalDummy.Global.D);
                end

                obj.dec = variables;
                obj.ind = INDIVIDUAL(tempIND);
                obj.obj = obj.ind.obj;
                obj.con = obj.ind.con;

                if nargin > 3
                    CallStack = dbstack();
                    Field     = CallStack(2).name;
                    obj.add.(Field) = addValues;
                end
            end
            
        end
        %% Get the matrix of decision variables of the population
        function value = decs(obj)
        %decs - Get the matrix of decision variables of the population
        %
        %   A = obj.decs returns the matrix of decision variables of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.dec);
        end
        %% Get the matrix of objective values of the population
        function value = objs(obj)
        %objs - Get the matrix of objective values of the population
        %
        %   A = obj.objs returns the matrix of objective values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.obj);
        end
        %% Get the matrix of constraint values of the population
        function value = cons(obj)
        %cons - Get the matrix of constraint values of the population
        %
        %   A = obj.cons returns the matrix of constraint values of the
        %   population obj, where obj is an array of INDIVIDUAL objects.
        
            value = cat(1,obj.con);
        end
        %% Get the matrix of additional property of the population
        function value = adds(obj,addValue)
        %adds - Get the matrix of additional property values of the population
        %
        %   A = obj.adds(AddProper) returns the matrix of the values of the
        %   additional property of the INDIVIDUAL objects obj. The name of
        %   the additional property is same to the function name of the
        %   caller, that is, the values of one additional property of the
        %   individuals can only be obtained by the function which created
        %   them. If any individual in obj does not contain the specified
        %   additional property, assign it a default value specified in
        %   AddProper.
        
            CallStack = dbstack();
            Field     = CallStack(2).name;
            value     = zeros(length(obj),size(addValue,2));
            for i = 1 : length(obj)
                if ~isfield(obj(i).add,Field)
                    obj(i).add.(Field) = addValue(i,:);
                end
                value(i,:) = obj(i).add.(Field);
            end
        end
    end
end