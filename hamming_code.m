% k is the length of the message in bits
k = 120;

% generate random binary message with length k
msg = randi([0 1], k, 1);

% hamming codeword length
n = 127;

% obtain hamming codeword
codeword = encode(msg, n, k);

% range of SNR values
EbNo = 0:5:20;
BER = zeros(1, length(EbNo));

% add AWGN
for i = 1:length(EbNo)
    % Add AWGN to the channel
    y = awgn(codeword, EbNo(i), 'measured');

    % Convert received signal to binary
    received_binary = (y > 0.5);

    % Decode received message
    rx_msg = decode(received_binary, n, k);

    % Compute Bit Error Rate (BER)
    BER(i) = sum(rx_msg ~= msg) / k;
end

% plot results
semilogy(EbNo, BER);
grid on;
xlabel('Eb/No (dB)');
ylabel('BER');
title('Hamming Codes');
