function clusterModel = dissEnergyCH(clusterModel, roundArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       clusterModel     architecture of nodes, network
%       roundArch        round Architecture
%   Example:
%       r = 10; % round no = 10
%       clusterModel = newCluster(netArch, nodeArch, 'def', r);
%       clusterModel = dissEnergyCH(clusterModel);

    nodeArch = clusterModel.nodeArch;
    netArch  = clusterModel.netArch;
    cluster  = clusterModel.clusterNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
    if cluster.countCHs == 0
        return
    end
    n = length(cluster.no); % Number of CHs
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    packetLength = roundArch.packetLength;
    ctrPacketLength = roundArch.ctrPacketLength;
    for i = 1:n
        chNo = cluster.no(i);
        distance = cluster.distance(i);
        energy = nodeArch.node(chNo).energy;
        % energy for aggregation the data + energy for transfering to BS
        if(distance >= d0)
             nodeArch.node(chNo).energy = energy - ...
                 ((ETX+EDA) * packetLength + Emp * packetLength * (distance ^ 4));
        else
             nodeArch.node(chNo).energy = energy - ...
                 ((ETX+EDA) * packetLength + Efs * packetLength * (distance ^ 2));
        end
        nodeArch.node(chNo).energy = nodeArch.node(chNo).energy - ...
            ctrPacketLength * ERX * round(nodeArch.numNode / clusterModel.numCluster);
    end
    
    clusterModel.nodeArch = nodeArch;
end