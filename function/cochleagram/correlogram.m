function c = correlogram(r, winLength, maxDelay)
% Generate a correlogram from responses of a Gammatone filterbank.

if nargin < 2
    winLength = 320;      % default window length in sample points which is 20 ms for 16 KHz sampling frequency
    maxDelay = 200;
end
    
[numChan,sigLength] = size(r);     % number of channels and input signal length

winShift = winLength/2;            % frame shift (default is half frame)
increment = winLength/winShift;    % special treatment for first increment-1 frames
M = floor(sigLength/winShift);     % number of time frames

% calculate autocorrelation for each frame and each channel
fprintf('Getting correlogram...');
c = zeros(numChan,M,maxDelay+1);
for m = 1:M          
    for i = 1:numChan
        fprintf('%02d%%',floor(((m-1)*numChan+i)/(M*numChan)*100));
        if m < increment        % shorter frame lengths for beginning frames
            sig = r(i,1:m*winShift);                               
        else
            startpoint = (m-increment)*winShift;
            sig = r(i,startpoint+1:startpoint+winLength);                                 
        end
        tmp = xcorr(sig,maxDelay,'coeff'); 
        c(i,m,:) = tmp((end+1)/2:end);   
        fprintf('\b\b\b');
    end
end
fprintf('\bDone!\n');