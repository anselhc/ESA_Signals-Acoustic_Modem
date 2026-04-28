load long_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 
SymbolPeriod = 100;
signal_length = 122350;

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end)'; % y_t is the signal which starts at the beginning of the transmission


t_vals = [0:length(y_t)-1]/Fs;
cosine_transform = cos(2*pi*f_c*t_vals);
y_c = y_t.*cosine_transform;

t = [-10000:1:9999]*(1/Fs);
W = 2*pi*f_c;
lp = W/Fs * sinc(f_c*t); %normalize by dividing by fs
x_d = conv(y_c, lp, 'same');

% Convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits.
x_d_bits = x_d(SymbolPeriod/2:SymbolPeriod:signal_length) > 0;

BitsToString(x_d_bits)
plot(t_vals, x_d); 