% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'E:\My Matlab\My codes\My GitHub\SINEAD_tool\SPM batch\Batch_PET_Realign_Coregister_Normalise_Smooth_job_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
