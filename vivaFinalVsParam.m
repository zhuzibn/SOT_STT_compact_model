function vivaFinalVsParam(fname, targetVar, paramName, varargin)
% vivaFinalVsParam  Plot final value of ViVA-exported curves vs swept parameter.
%
% NAME-VALUE OPTIONS (added)
%   "XUnit"    : unit string for x-axis (default "")
%   "YUnit"    : unit string for y-axis (default "")
%   "Take"     : "last" (default) or "meanLastN"
%   "N"        : N for meanLastN (default 20)
%   "Delimiter": delimiter passed to readtable (default ',')
%
% EXAMPLE
%   out = vivaFinalVsParam("SOT_cadence2.matlab","mz","vdc","XUnit","V");
%   out = vivaFinalVsParam("SOT_cadence2.matlab","mz","vdc","XUnit","V","YUnit","");

p = inputParser;
p.addParameter("Take","last",@(s)isstring(s)||ischar(s));
p.addParameter("N",20,@(x)isnumeric(x)&&isscalar(x)&&x>=1);
p.addParameter("Delimiter",",",@(s)isstring(s)||ischar(s)||iscell(s));

% ---- added units ----
p.addParameter("XUnit","",@(s)isstring(s)||ischar(s));
p.addParameter("YUnit","",@(s)isstring(s)||ischar(s));

p.parse(varargin{:});
opt = p.Results;

fname     = string(fname);
targetVar = string(targetVar);
paramName = string(paramName);

% Normalize targetVar to match headers like "/mz ..."
if ~startsWith(targetVar, "/")
    targetKey = "/" + targetVar;
else
    targetKey = targetVar;
end

T = readtable(fname, ...
    "FileType","text", ...
    "Delimiter", opt.Delimiter, ...
    "PreserveVariableNames", true);

vn = string(T.Properties.VariableNames);

% Find all Y columns for that target variable
yIdx = find(startsWith(vn, targetKey + " ") & endsWith(vn, "_Y"));
if isempty(yIdx)
    yIdx = find(contains(vn, targetKey) & endsWith(vn, "_Y"));
end
if isempty(yIdx)
    error('No Y columns found for target "%s".', targetVar);
end

paramVals = nan(numel(yIdx),1);
yFinal    = nan(numel(yIdx),1);

for k = 1:numel(yIdx)
    yName = vn(yIdx(k));   % e.g. "/mz (vdc=-0.4)_Y"

    tok = regexp(yName, paramName + "=([-\d\.eE\+]+)", "tokens", "once");
    if ~isempty(tok)
        paramVals(k) = str2double(tok{1});
    end

    y = T{:, yIdx(k)};
    y = y(:);
    y = y(isfinite(y));
    if isempty(y), continue; end

    switch lower(string(opt.Take))
        case "last"
            yFinal(k) = y(end);
        case "meanlastn"
            N = min(opt.N, numel(y));
            yFinal(k) = mean(y(end-N+1:end));
        otherwise
            error('Unknown Take="%s". Use "last" or "meanLastN".', opt.Take);
    end
end

ok = isfinite(paramVals) & isfinite(yFinal);
paramVals = paramVals(ok);
yFinal    = yFinal(ok);
yNames    = vn(yIdx(ok));

% Sort by parameter
[paramVals, ord] = sort(paramVals);
yFinal = yFinal(ord);
yNames = yNames(ord);

% ---- build labels with units ----
xlab = paramName;
if strlength(string(opt.XUnit)) > 0
    xlab = xlab + " (" + string(opt.XUnit) + ")";
end

ylab = targetKey + " final";
if strlength(string(opt.YUnit)) > 0
    ylab = ylab + " (" + string(opt.YUnit) + ")";
end

if paramName=="vdc"
    RHM = 500;%ohm
    LHM    = 55e-9;
    tHM    = 4e-9;
    Jc_mz1=paramVals/RHM/(LHM*tHM);
    figure('Color','w'); grid on;
    plot(Jc_mz1, yFinal, '-ro', 'LineWidth', 1.5);
    xlabel('Jc(A/m2)'); ylabel('final /mz');
    title('Final /mz vs Jc');
end
% Plot
figure('Color','w'); grid on;
plot(paramVals, yFinal, '-o', 'LineWidth', 1.5);
xlabel(xlab, 'Interpreter','none');
ylabel(ylab, 'Interpreter','none');
title(sprintf('Final %s vs %s (%s)', targetKey, paramName, fname), 'Interpreter','none');
end