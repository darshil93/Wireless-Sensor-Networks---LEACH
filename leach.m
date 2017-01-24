function [nodeArch, clusterNode] = leach(clusterModel, clusterFunParam)
% Create the new node architecture using leach algorithm in beginning 
%  of each rond. This function is called by newCluster function.
%   
%   Input:
%       clusterModel        Cluster model by newCluster function
%       clusterFunParam     Parameters for the cluster function
%                   [r ]
%   Example:
%       [nodeArch, clusterNode] = feval('leach', clusterModel, clusterFunParam);
%
% Hossein Dehghan, hd.dehghan@gmail.com
% Ver 1. 2/2013
    
    nodeArch = clusterModel.nodeArch;
    netArch  = clusterModel.netArch;
    r = clusterFunParam(1); % round no
    p = clusterModel.p;
    N = nodeArch.numNode; % number of nodes
    
    %%%%%%%% reset the CH afret numCluster round
    if (mod(r, clusterModel.numCluster) == 0)
        for i = 1:N
            nodeArch.node(i).G = 0; % not selected for CH
        end
    end
    
    %%%%%%%% Checking if there is a dead node
    locAlive = find(~nodeArch.dead); % find the nodes that are alive
    for i = locAlive
        if nodeArch.node(i).energy <= 0
            nodeArch.node(i).type = 'D';
            nodeArch.dead(i) = 1;
        else
            nodeArch.node(i).type = 'N';
        end
    end
    nodeArch.numDead = sum(nodeArch.dead);
    
    %%%%%%%% find the cluster head
    % define cluster structure
    clusterNode     = struct();
    %
    locAlive = find(~nodeArch.dead); % find the nodes that are alive
    countCHs = 0;
    for i = locAlive % seach in alive nodes
        temp_rand = rand;
        if (nodeArch.node(i).G <= 0) && ...
           (temp_rand <= prob(r, p)) && ...
           (nodeArch.node(i).energy > 0)

            countCHs = countCHs+1;

            nodeArch.node(i).type          = 'C';
            nodeArch.node(1,1).G           = round(1/p)-1;
            clusterNode.no(countCHs)       = i; % the no of node
            xLoc = nodeArch.node(i).x; % x location of CH
            yLoc = nodeArch.node(i).y; % y location of CH
            clusterNode.loc(countCHs, 1)   = xLoc;
            clusterNode.loc(countCHs, 2)   = yLoc;
            % Calculate distance of CH from BS
            clusterNode.distance(countCHs) = sqrt((xLoc - netArch.Sink.x)^2 + ...
                                                  (yLoc - netArch.Sink.y)^2);            
        end % if
    end % for
    clusterNode.countCHs = countCHs;
end