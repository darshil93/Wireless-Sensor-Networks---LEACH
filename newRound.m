function NetRound = newRound(numRound, packetLength, ctrPacketLength)
% Create the round architecture for specific parameters
%   
%   Input:
%       numRound            Number of rounds
%       packetLength        Length of packet that sent for CH to BS
%       ctrPacketLength     Length of packet that sent for nodes to CH
%   Example:
%       NetRound = newRound();

    if ~exist('numRound','var')
        NetRound.numRound = 9999; % default of the maximum round is 9999
    else
        NetRound.numRound = numRound;
    end
    if ~exist('packetLength','var')
        NetRound.packetLength = 6400; % default of the packet length is 6400
    else
        NetRound.packetLength = packetLength;
    end
    if ~exist('ctrPacketLength','var')
        NetRound.ctrPacketLength = 200;
    else
        NetRound.ctrPacketLength = ctrPacketLength;
    end
end