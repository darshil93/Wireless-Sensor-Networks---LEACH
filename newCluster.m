function clusterModel = newCluster(netArch, nodeArch, ...
                        clusterFun, clusterFunParam, p_numCluster)
% Create the network architecture with desired parameters
%   
%   Input:
%       clusterFun          Function name for clustering algorithm.
%       clusterFunParam     Parameters for the cluster function
%       numCluster          Number of clusters (CHs)
%       netArch             Network model
%       nodeArch            Nodes model
%   Example:
%       clusterModel = newCluster();

    % set the parameters
    if ~exist('clusterFun','var')
        clusterFun = 'leach'; % default for clustering the node is leach algorithm
    end
    if strcmp(clusterFun, 'def')
        clusterFun = 'leach'; % default for clustering the node is leach algorithm
    end
    clusterModel.clusterFun = clusterFun;
   
    if ~exist('clusterFunParam','var')
        clusterFunParam = [];
    end
    clusterModel.clusterFunParam = clusterFunParam;
   
    if ~exist('netArch','var')
        netArch = newNetwork();
    end
    clusterModel.netArch = netArch;
    
    if ~exist('nodeArch','var')
        nodeArch = newNodes();
    end
    clusterModel.nodeArch = nodeArch;
    
    if ~exist('p_numCluster','var')
        dBS        = sqrt((netArch.Sink.x - netArch.Yard.Length) ^ 2 + ...
                          (netArch.Sink.y - netArch.Yard.Width) ^ 2);
        numCluster = clusterOptimum(netArch, nodeArch, dBS); 
        p = 1 / numCluster;
    else
        if p_numCluster < 1
            p = p_numCluster;
            numCluster = 1 / p;
        else
            numCluster = p_numCluster;
            p = 1 / numCluster;
        end
    end
    %p = Optimal Election Probability of a node to become cluster head
    clusterModel.numCluster = numCluster;
    clusterModel.p          = p;
    
    % run the clustering algorithm
    addpath Cluster % put the clustering algorithm in the cluster folder
    [nodeArch, clusterNode] = feval(clusterFun, clusterModel, clusterFunParam); % execute the cluster function
    
    clusterModel.nodeArch = nodeArch;       % new architecture of nodes
    clusterModel.clusterNode = clusterNode; % the CHs
end