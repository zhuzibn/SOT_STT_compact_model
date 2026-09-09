clear all;clc;close all
%% sweep Jc
if (1)
vivaFinalVsParam("SOT_sweepJc_mz+1.matlab","mz","vdc","XUnit","V");
vivaFinalVsParam("SOT_sweepJc_mz-1.matlab","mz","vdc","XUnit","V");
end
%% sweep hx
if (0)
vivaFinalVsParam("SOT_sweep_hx.matlab","mz","hx","XUnit","T");
end