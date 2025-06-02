% Aggelopous Sokratis 10396
% Skoularikis Anastasios 10458
close all

% Load data
data = load('train.mat');
eeg = data.train_eeg;
blinks = data.blinks;

% Plot EEG signal
figure;
plot(eeg(1, :), 'black');
title('EEG');
xlabel('Sample Index');
ylabel('Amplitude');
hold on;

seperate_blinks = split_blink_segments(blinks);

% Draw transparent patches for each blink 
y_limits = ylim;
for i = 1:length(seperate_blinks)
    blink = seperate_blinks{i};
    patch([blink(1) blink(end) blink(end) blink(1)], [y_limits(1) y_limits(1) y_limits(2) y_limits(2)], uint8([17 17 17]), 'FaceAlpha', 0.1, 'EdgeColor', 'none');
end

legend('EEG Signal', 'Blinks');
hold off;


%% Functions
function seperate_blinks = split_blink_segments(blinks)
    seperate_blinks = {};  
    start_idx = 1;
    for i = 1:length(blinks)-1
        if blinks(i+1) ~= blinks(i) + 1
            seperate_blinks{end+1} = blinks(start_idx:i);
            start_idx = i + 1;
        end
    end
    seperate_blinks{end+1} = blinks(start_idx:end);  % Add the last blink
end
