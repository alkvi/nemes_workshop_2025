% Testing
% Ran on R2024a, master branch of nirs toolbox 2025-09-20
% https://github.com/huppertt/nirs-toolbox

% Based on examples in:
% https://github.com/huppertt/nirs-toolbox/blob/master/demos/fnirs_analysis_demo.m

%% Load

% Save the current directory
originalDir = pwd;

% Change to the ../data directory
% since the toolbox is not very robust to 
% dots and spaces and other things in the path..
cd('../data');

% We will load the SNIRF files with the legacy loadSNIRF
% because the nirs.bids.loadBIDS function is pretty unstable still and 
% won't load this dataset.
filenames = {
    'rob-luke-BIDS-NIRS-Tapping-e262df8/sub-01/nirs/sub-01_task-tapping_nirs.snirf'
    'rob-luke-BIDS-NIRS-Tapping-e262df8/sub-02/nirs/sub-02_task-tapping_nirs.snirf'
    'rob-luke-BIDS-NIRS-Tapping-e262df8/sub-03/nirs/sub-03_task-tapping_nirs.snirf'
    'rob-luke-BIDS-NIRS-Tapping-e262df8/sub-04/nirs/sub-04_task-tapping_nirs.snirf'
    'rob-luke-BIDS-NIRS-Tapping-e262df8/sub-05/nirs/sub-05_task-tapping_nirs.snirf'
};

for i = 1:numel(filenames)
    data(i) = nirs.io.loadSNIRF(filenames{i}, true, true);
end

% Change back to the original directory
cd(originalDir);

% Print demographics (metadata) of loaded data
demographics = nirs.createDemographicsTable(data);
disp(demographics)

%% Visualize montage and raw data

sub_01_data = data(1);

% Let's make sure the loaded montage looks OK.
figure()
sub_01_data.probe.draw()

% The actual channels can be found in here:
disp(sub_01_data.probe.link);

% We can also plot the raw intensity data.
figure()
sub_01_data.draw

%% Handle events

% Rename the stimuli for setup 1
job = nirs.modules.RenameStims;
job.listOfChanges = {'1.0', 'Control';
                 '2.0' ,'Tapping_Left';
                 '3.0' ,'Tapping_Right';
                 '15.0' ,'Start_Stop';};
data = job.run(data);

% Also remove the start/stop triggers.
job = nirs.modules.DiscardStims;
job.listOfStims = {'Start_Stop'};
data = job.run(data);

% Look at the resulting time series with events.
figure()
data(1).draw

%% Short channels

% Label short channels in the data.
% This will automatically label 8mm as short channel by adding a 
% fourth type column to data.probe.link 
job = nirs.modules.LabelShortSeperation();
job.max_distance = 8;
data = job.run(data);

%% Pre-processing

% Trim noisy data before and after experiment.
% We want to cut before the first stimulus (preBaseline), and then after the
% end of last stimulus (i.e. the end of the experiment) (postBaseline). 
% Leave 1 second on each side.
job = nirs.modules.TrimBaseline();
job.preBaseline  = 1;
job.postBaseline = 1;
data = job.run(data);

% Resampling for speed
job = nirs.modules.Resample(); 
job.Fs = 4;
data = job.run(data);

% Convert intensity to optical density,
% and then density to hemoglobin using mBLL
job = nirs.modules.OpticalDensity();
job = nirs.modules.BeerLambertLaw(job);
hb = job.run(data);

% Now we have hemoglobin data. Draw it.
figure()
hb(1).draw

%% Interactive visualization

% We can use the Time Series Viewer to look at the data as well.
nirs.viz.TimeSeriesViewer(hb);

%% First-level

% Subject level pipeline

% GLM via AR(P)-IRLS GLM (Autoregressive iterative least square) 
% basically prewhitening 
% Barker, Jeffrey W., Ardalan Aarabi, and Theodore J. Huppert."Autoregressive model based algorithm for correcting motion and serially correlated errors in fNIRS." 
% Biomedical optics express 4.8 (2013): 1366-1379.

% Set up the GLM model with prewithening 
job = nirs.modules.GLM();
job.type='AR-IRLS';

% Add the short channel (regressors) to the GLM  
job.AddShortSepRegressors = true;

% We can look at every option set in the job
disp(job)

% Run the GLM.
% Note that this creates a design matrix from the stimulus
% with the HRF set according to job options. Default is 'Canonical'.
SubjStats = job.run(hb(1)); 

%% Visualize 1st level results

% To visualize the data ex. t statisics
SubjStats(1).draw('tstat', [-10 10], 'p < 0.05');

% Note you can get available draw functions like so:
SubjStats(1).probe.defaultdrawfcn='?';

% The 3D mesh does not seem to load properly
% in the latest version for me. So we're sticking to 2D plots in this
% pipeline. Usually I fork the toolbox and add my own fixes to
% the BIDS/SNIRF loading code for 3D coordinates. For example
% https://github.com/alkvi/nirs-toolbox-fork/commits/phd_study_3/

%% Group level

% Let's run a mixed-effects model for group analysis.
j = nirs.modules.MixedEffects( );

% We must specify the formula for the mixed effects.  This one calculates
% the group mean for each condition.  There is also a random intercept for
% each subject.  Google "matlab wilkinson notation" or see
% <http://www.mathworks.com/help/stats/wilkinson-notation.html> for more examples.
j.formula = 'beta ~ -1 + group:cond + (1|subject)';
j.dummyCoding = 'full';
j.include_diagnostics=true;

% Run the model
GroupStats = j.run(SubjStats);

%% Visualize group level

% We can plot as before..
GroupStats.draw('tstat', [-10 10], 'p < 0.05');

% Or with FDR-corrected p values (q) instead
GroupStats.draw('tstat', [-10 10], 'q < 0.05');

% In table form
result_table = GroupStats.table();
disp(result_table);