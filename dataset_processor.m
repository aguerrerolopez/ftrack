% Define the directory path here
directoryPath = '../data/data_final/'; % Replace with your actual directory path

% Search for all .wav files in the directory and its subdirectories
files = dir(fullfile(directoryPath, '**', '*.wav'));

% Parameters for the formant tracking function
% (Define all your parameters here)
lptype = 'tvwlp_l2';
nwin = 1600;
nshift = 1600;
p = 8;
q = 3;
npeaks = 3;
PREEMP = 0.97;
fint = 80;
PLOT_FLAG = 0;

% Loop over each file and process
for k = 1:length(files)
    wavFilePath = fullfile(files(k).folder, files(k).name);
    [s, fs] = audioread(wavFilePath);
    
    % Downsample the signal to 8 kHz if necessary
    if fs ~= 8000
        [P, Q] = rat(8000/fs); % Get resampling factors
        s = resample(s, P, Q); % Resample signal to 8 kHz
        fs = 8000; % Update sampling rate to 8 kHz
    end
    
    % Call your formant tracking function with the downsampled signal 's'
    % [Fi, Ak] = ftrack_tvwlp(s, fs, lptype, nwin, nshift, p, q, npeaks, PREEMP, fint, PLOT_FLAG);

    % For the purpose of this example, let's say Fi and Ak are obtained
    % Fi = [F1_values; F2_values; F3_values];

    % Now save the downsampled audio signal and other results in a .mat file
    % Mimicking a Python dictionary style
    dataToSave = struct();
    dataToSave.AudioSignal = s; % Add the downsampled audio signal
    dataToSave.F1 = Fi(1, :); % First formant track
    dataToSave.F2 = Fi(2, :); % Second formant track
    dataToSave.F3 = Fi(3, :); % Third formant track

    % Parameters dictionary
    paramsDict = struct('lptype', lptype, 'nwin', nwin, 'nshift', nshift, ...
                        'p', p, 'q', q, 'npeaks', npeaks, 'PREEMP', PREEMP, ...
                        'fint', fint, 'PLOT_FLAG', PLOT_FLAG);
    dataToSave.Params = paramsDict;

    % Create a MAT file name based on the WAV file name
    matFileName = [wavFilePath(1:end-4), '.mat'];
    
    % Save the structure as a MAT file
    save(matFileName, '-struct', 'dataToSave');
end
