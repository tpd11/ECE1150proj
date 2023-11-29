fmt = format("longG")
% trellis for 1/2 convolutional encoding
trellis = poly2trellis(7, [171 133]);

% k is the number of input streams
k = log2(trellis.numInputSymbols);
% n is the number of output streams
n = log2(trellis.numOutputSymbols);
numSymPerFrame = 12000;

% generate random binary message with length k*number of symbols per frame
msg = randi([0 1], k*numSymPerFrame, 1);

% Convolutional Encoding
[encodedData, ~] = convenc(msg, trellis);

% range of SNR values
EbNo = 0:1:10;
BER_coded = zeros(1, length(EbNo));
BER_uncoded = zeros(1, length(EbNo));

% add AWGN
for i = 1:length(EbNo)
    % Add AWGN to the channel
    noisyData = awgn(encodedData, EbNo(i), 'measured');
    noisyMsg = awgn(msg, EbNo(i), 'measured');

    % Convert received signal to binary
    received_binary = (noisyData >= 0.5);
    binary_noisy_msg = (noisyMsg >= 0.5);

    % Convolutional Decoding
    decodedData = vitdec(received_binary, trellis, 50, 'trunc', 'hard'); % The third argument (50) is the traceback length

    % Compute Bit Error Rate (BER)
    BER_coded(i) = sum(decodedData ~= msg) / numSymPerFrame;
    BER_uncoded(i) = sum(binary_noisy_msg ~= msg) / numSymPerFrame;
end

% plot results
semilogy(EbNo, BER_coded, '-o', EbNo, BER_uncoded, '-*');
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('Convolutional Codes');
legend({'R = 1/2 Coding','Uncoded'},'Location','northeast')




