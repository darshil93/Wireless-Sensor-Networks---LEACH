function kOpt = clusterOptimum(netArch, nodeArch, dBS)
% calculate the optimum valuse for number of nodes
%
%   Input:
%       netArch     network model
%       nodeArch    nodes model
%       dBS         length from base station
%   Example:
%       dBS = sqrt(netArch.Sink.x ^ 2 + netArch.Sink.y ^ 2);
%       numClusters     = clusterOptimum(netArch, nodeArch, dBS);

    N    = nodeArch.numNode; % number of nodes
    M    = sqrt(netArch.Yard.Length * netArch.Yard.Width);
    kOpt = sqrt(N) / sqrt(2*pi) * ...
           sqrt(netArch.Energy.freeSpace / netArch.Energy.multiPath) * ...
           M / dBS ^ 2;
    kOpt = round(kOpt);
end