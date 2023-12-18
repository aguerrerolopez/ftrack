% Full Dataset Audio Processing Script
% ------------------------------------
% This script is designed to automate the processing of a large dataset of audio files.
% It recursively searches through the specified directory and all its subdirectories
% to find every .wav file. For each audio file discovered, it performs the following actions:
%
% 1. Reads the audio file and downsamples it to 8 kHz if the original sampling rate is different.
%    This downsampling step is crucial as the formant tracking function used in this script 
%    requires the audio to be at an 8 kHz sampling rate.
%
% 2. Processes the downsampled audio signal using a formant tracking function. This function 
%    is assumed to be previously defined and is responsible for extracting the formant frequencies 
%    (F1, F2, F3) from the audio signal. The exact implementation details of the formant 
%    tracking should be documented in the function itself.
%
% 3. Saves the processed data into a MATLAB .mat file mimicking a dictionary-like structure.
%    The .mat file contains the following keys and associated values:
%       - "AudioSignal": The downsampled audio signal used for formant tracking.
%       - "F1", "F2", "F3": The first, second, and third formant frequency tracks, respectively.
%       - "Params": A nested structure containing the parameters used for formant tracking, 
%                   which includes the type of LP analysis, window size, window shift, LP order, 
%                   polynomial order, number of formants to track, preemphasis factor, formant 
%                   interval, and plot flag.
%
% This script is intended to facilitate batch processing of audio files for speech analysis,
% particularly useful for researchers dealing with large speech datasets.
% It streamlines the extraction of important speech features and organizes the output
% for subsequent analysis.
%
% Ensure MATLAB's current directory is set to the script's location or provide the full path to the
% script when running. Modify the 'directoryPath' variable below to point to the dataset's root folder.
%
% Author: [Your Name]
% Date: [Date of Script Creation]
% Version: [Version of the Script]
% License: [License Information, if applicable]

addpath("ftrack_tvwlp_v1/GLOAT/")
addpath("ftrack_tvwlp_v1/")

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
PLOT_FLAG = 1;
SAVE_PLOT_FLAG = 1;

% Loop over each file and process
for k = 1:length(files)
    wavFilePath = fullfile(files(k).folder, files(k).name);
    [s, fs] = audioread(wavFilePath);
    display(wavFilePath);
    
    % Downsample the signal to 8 kHz if necessary
    if fs ~= 8000
        [P, Q] = rat(8000/fs); % Get resampling factors
        s = resample(s, P, Q); % Resample signal to 8 kHz
        fs = 8000; % Update sampling rate to 8 kHz
    end
    
    % Call your formant tracking function with the downsampled signal 's'
    [Fi, Ak] = ftrack_tvwlp(s, fs, lptype, nwin, nshift, p, q, npeaks, PREEMP, fint, PLOT_FLAG, SAVE_PLOT_FLAG, wavFilePath);

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
