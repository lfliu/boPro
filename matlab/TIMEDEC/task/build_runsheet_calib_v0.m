%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function to build array with task parameters for PRC
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function trials = build_runsheet_calib_v0(delays, thresholds)

if isempty(delays)
    error('First argument must be an array of singles or doubles (delays).')
end
if isempty(thresholds)
    error('Second argument must be an array of singles or doubles (thresholds).')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_delays = numel(delays);
num_thresholds = numel(thresholds);
max_num_trials = 80;

FIX_DURATION = 2;
fix_jitter = [-1 0 1];
OPTIONS_DURATION = 4;
RESPONSE_DURATION = 2;
POST_FIX_DURATION = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build runsheet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create column of zeros (for placeholders)
zc = zeros(max_num_trials,1);

% create column vector of ones
oc = ones(max_num_trials,1);

% placeholder for trial numbers
RUNSHEET = [1:max_num_trials]';

% placeholder for trial onset
RUNSHEET = [ RUNSHEET zc ];

% fixation duration
num_fix_values = numel(fix_jitter);
jitters = randsample(1:num_fix_values, max_num_trials, 1)'; %get_anu_rnd_numbers(max_num_trials,num_fix_values) - 1; % vector of random numbers from 0 to 2
fix_duration = jitters + FIX_DURATION;
RUNSHEET = [ RUNSHEET fix_duration ];

% placeholder for fixation onset
RUNSHEET = [ RUNSHEET zc ];

% options duration
RUNSHEET = [ RUNSHEET OPTIONS_DURATION .* oc ];

% delayed option up top?
top = randsample(0:1, max_num_trials, 1)'; %get_anu_rnd_numbers(max_num_trials,2); % rnd vector of 0/1
RUNSHEET = [ RUNSHEET top ];

% delay
delay = randsample(1:num_delays, max_num_trials, 1)'; %get_anu_rnd_numbers(max_num_trials,num_delays) + 1; % rnd vector of num of delays - 1
delay = delays(delay);
RUNSHEET = [ RUNSHEET delay' ];

% percentiles
threshold = randsample(1:num_thresholds, max_num_trials, 1)'; %get_anu_rnd_numbers(max_num_trials,num_thresholds) + 1; % rnd vector of num of delays - 1
threshold = thresholds(threshold);
RUNSHEET = [ RUNSHEET threshold' ];

% placeholders for vn, vd, y 
RUNSHEET = [ RUNSHEET zc zc zc];

% placeholder for options onset
RUNSHEET = [ RUNSHEET zc ];

% response screen duration
RUNSHEET = [ RUNSHEET RESPONSE_DURATION .* oc ];

% delayed option right?
right = randsample(0:1, max_num_trials, 1)'; %get_anu_rnd_numbers(max_num_trials,2); % rnd vector of 0/1
RUNSHEET = [ RUNSHEET right ];

% placeholder for response screen onset
RUNSHEET = [ RUNSHEET zc ];

% placeholders for response and choice
RUNSHEET = [ RUNSHEET zc zc ];

% placeholders for response time
RUNSHEET = [ RUNSHEET zc ];

% post fix duration
RUNSHEET = [ RUNSHEET POST_FIX_DURATION .* oc ];

% placeholders for post fix onset
RUNSHEET = [ RUNSHEET zc ];

% placeholders for quantile estimtes
RUNSHEET = [ RUNSHEET zc zc zc zc zc zc ];


% Runsheet structure
%
% Columns:
%
% trial - 1
% trial onset - 2
% fix duration - 3
% fix onset - 4
% options duration - 5
% top (delayed option up top?) - 6
% delay - 7
% quantile - 8
% v_n - 9
% v_d - 10
% y (discount factor) - 11
% options onset - 12
% response screen duration - 13
% right (delayed option on right?) - 14
% response screen onset - 15
% response (L/R?) - 16
% choice (SS/LL?) - 17
% RT (ms) - 18
% post fix duration - 19
% post fix onset - 20
% [param1_quantile1 param2_quantile2 ...]

% build trial structure
trials = struct();
trials.datetime = [];
trials.lasttrial = [];
trials.trial = [];
trials.trial.onset = [];
trials.trial.end = [];
trials.prefix = [];
trials.prefix.duration = [];
trials.prefix.onset = [];
trials.attention = [];
trials.attention.duration = [];
trials.attention.onset = [];
trials.attention.sideopen = [];
trials.attention.key = [];
trials.attention.correct = [];
trials.attention.rt = [];
trials.attention.performance = [];
trials.priming = [];
trials.priming.duration = [];
trials.priming.condition = [];
trials.priming.image = [];
trials.priming.onset = [];
trials.options = [];
trials.options.duration = [];
trials.options.lltop = [];
trials.options.delay = [];
trials.options.quantile = [];
trials.options.vn = [];
trials.options.vd = [];
trials.options.y = [];
trials.options.onset = [];
trials.response.duration = [];
trials.response.llright = [];
trials.response.onset = [];
trials.response.key = [];
trials.response.choice = [];
trials.response.rt = [];
trials.postfix.duration = [];
trials.postfix.onset = [];
trials.fast.struct = [];
trials.fast.estimate = [];
trials.fast.k25 = [];
trials.fast.k50 = [];
trials.fast.k75 = [];
trials.fast.s25 = [];
trials.fast.s50 = [];
trials.fast.s75 = [];

% fill with values
for t = 1:size(RUNSHEET,1)
   
    trials.prefix(t).duration = RUNSHEET(t,3);
    trials.options(t).duration = RUNSHEET(t,5);
    trials.options(t).lltop = RUNSHEET(t,6);
    trials.options(t).delay = RUNSHEET(t,7);
    trials.options(t).quantile = RUNSHEET(t,8);
    trials.response(t).duration = RUNSHEET(t,13);
    trials.response(t).llright = RUNSHEET(t,14);
    trials.postfix(t).duration = POST_FIX_DURATION;

end
