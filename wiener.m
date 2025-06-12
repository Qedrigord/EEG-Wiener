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

lambda = 1e-6;
W = Rss / (Rss + Rww + lambda * eye(size(Rss)));

sHat = W * eeg;     % estimation

figure;
plot(eeg(1,:));   
hold on;
plot(sHat(1,:));  
legend('raw','denoised');

eeg_test = load('test.mat').test_eeg;  % some test EEG
sHat_test = W * eeg_test;  % apply learned filter

figure;
plot(eeg_test(19,:));   
hold on;
plot(sHat_test(19,:));  
legend('raw','denoised');
