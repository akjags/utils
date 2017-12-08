% addJobToSherlock.m
%
%   Adds jobs to Sherlock queue, given the split file handle.
%
%      by: akshay jagadeesh
%    date: 07/13/2017
%
%    inputs: Inputs represent sherlock job parameters.
%         Two options for input arguments: struct or 'key', 'value' pairs. 
%         Job parameters:
%           - 'jobName' -- name of the job (also name of the batch script)
%           - 'jobFile' -- string containing path to matlab file you want to submit to Sherlock.
%           - 'suid' -- suid to log onto sherlock
%           - 'logDir' -- Name of directory on sherlock to save log files to; if it doesn't exist, will get created.
%           - 'runTime' -- maximum amount of time to allow a job to run for
%           - 'memory' -- Memory to request from sherlock (Default 8gb) as a string, e.g. '8G'
%           - 'numNodes' -- number of nodes you want to request (default 1)
%           - 'scriptSaveDir' -- Local directory to save the script in.
%           - 'sherlockSessionDir' -- Name of directory on Sherlock to transfer the script to and run it from. 
%
function job = addJobToSherlock(varargin)

% Get any nondefault inputs
default_table = {'jobName', 'job', 'parameter';
                 'jobFile', '', 'parameter';
                 'suid', 'akshayj', 'parameter';
                 'logDir', '/home/akshayj/log', 'parameter';
                 'runtime', 60, 'parameter';
                 'numNodes', 1, 'parameter';
                 'sherlockSessionDir', '~', 'parameter';
                 'scriptSaveDir', '.', 'parameter';
                 'memory', '8G', 'parameter'};
if strcmp(class(varargin{1}), 'struct')
  % If they pass in a struct, merge it with the defaults.
  inp = util_extract_inputs(default_table, {});
  inp = mergeStructs(inp, varargin{1});
else
  % If key value pairs are passed in, extract them and merge with the default_table.
  inp = util_extract_inputs(default_table, varargin);
end

disp('Generating batch scripts');
system(sprintf('sh ~/proj/utils/sherlock/genBatchScript.sh "%s" "%s" "%s" "%s" "%s" "%s" "%s"', inp.jobName, inp.suid, inp.logDir, num2str(inp.runtime), num2str(inp.numNodes), inp.memory, inp.jobFile));

system(sprintf('ssh %s@sherlock.stanford.edu "mkdir %s"', inp.suid, inp.logDir));

disp('Transferring batch scripts to Sherlock and running');
system(sprintf('rsync -q %s/%s.sbatch %s@sherlock.stanford.edu:%s/.', inp.scriptSaveDir, inp.jobName, inp.suid, inp.sherlockSessionDir));
system(sprintf('ssh %s@sherlock.stanford.edu "cd %s; sbatch %s.sbatch"', inp.suid, inp.sherlockSessionDir, inp.jobName));

job = inp;
