
load short_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission


t_vals = [0:1/Fs:(39660/Fs)-1/Fs];
cosine_transform = cos(2*pi*f_c*t_vals);
x_d = y_t.*cosine_transform.*sinc(t_vals*2*f_c)*2000;

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits.
for i=1:length(x_d)
    if x_d(i) > 0
        x_d(i) = 1;
    else
        x_d(i) = 0;
    end
end
x_d = x_d(1:39656);
BitsToString(x_d)

