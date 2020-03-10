function [force extension] = Convert2FvsX(piezoPos,qpdVolts,params)

disp = params.disp;
strain2nm = params.strain2nm;
fc = params.fc;
R = params.R;
eta = params.eta;

numData = length(piezoPos);
extension = cell(numData,1);
force = cell(numData,1);
for i = 1:numData
    
    % correct for extension
    ext = (piezoPos{i} - qpdVolts{i}/disp)*1e-9; % in meters

    % calculate force
    beta = 6*pi*eta*R;
    k = fc*(2*pi *beta);
    F = k*qpdVolts{i}/disp*strain2nm*1e-9; % in Newtons

    % correct for absolute force and extension
    extension{i} = -ext*1e9;    % nm
    force{i} = -F*1e12;         % pN
end
