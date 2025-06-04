data = load('train.mat');
eeg = data.train_eeg;
blinks = data.blinks;

allIdx   = 1:size(eeg,2);
blinkIdx = blinks;                      % artifact frames
cleanIdx = setdiff(allIdx, blinkIdx);   % artifact-free frames

W = eeg(:, blinkIdx );   %  (#blink × nChan)  artifacts (blinks)
S = eeg(:, cleanIdx );   %  (#clean × nChan)  EEG

% ----- ensure zero mean -----
W = detrend(W, 'constant');
S = detrend(S, 'constant');

% ----- covariances -----
Rww = (W * W.');     % noise covariance
Rss = (S * S.');     % EEG covariance

sHat = Rss * inv(Rss + Rww) * eeg;     % estimation

figure;
plot(eeg(1,:));   
hold on;
plot(sHat(1,:));  
legend('raw','denoised');
