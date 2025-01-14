% test.m
% Script to read a wav file, process it using ftrack_tvwlp, and plot
% formant tracks.
addpath("ftrack_tvwlp_v1/GLOAT/")
addpath("ftrack_tvwlp_v1/")


% Path to the wav file - replace this with your actual file path
wavFilePath = '../data/data_final/Audios/Contr/A/1/Contr_ses1_a_0014.wav'; % TODO: Replace with your actual file path

% Read the audio file
[s, fs] = audioread(wavFilePath);

% Ensure the sampling rate is 8kHz as required
if fs ~= 8000
    [P, Q] = rat(8000/fs); % Get resampling factors
    s = resample(s, P, Q); % Resample signal to 8 kHz
    fs = 8000; % Update sampling rate to 8 kHz
end

% Set parameters for ftrack_tvwlp function
lptype = 'tvwlp_l2'; % Type of LP analysis
nwin = 160; % Window size for analysis
nshift = 80; % Window shift
p = 12; % LP order
q = 0; % Polynomial order
npeaks = 3; % Number of formants to track
PREEMP = 0.7; % Preemphasis factor
fint = 80; % Formant interval in samples
PLOT_FLAG = 1; % Plot flag (set to 0 as we will plot separately)
SAVE_PLOT_FLAG = 1; % Save flag (set 1 if you want to save the image in a .png file

% Call ftrack_tvwlp function from the repository
[Fi, Ak] = ftrack_tvwlp(s, fs, lptype, nwin, nshift, p, q, npeaks, PREEMP, fint, PLOT_FLAG, SAVE_PLOT_FLAG, wavFilePath);
