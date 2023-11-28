
N = 7;  % Codeword length
K = 3;   % Message length

% Create RS Encoder and Decoder objects
Enc = comm.RSEncoder('BitInput', true, 'CodewordLength', N, 'MessageLength', K);
Dec = comm.RSDecoder('BitInput', true, 'CodewordLength', N, 'MessageLength', K);

% Number of simulations
numSimulations = 1000;

% Initialize BER vector
EbNoRange = 0:1:10;
BER_enc = zeros(length(EbNoRange), 1);
BER_uncoded = zeros(length(EbNoRange), 1);

for snrIdx = 1:length(EbNoRange)
    % Initialize error count for this Eb/No value
    errorCount = 0;
    errorCount_uncoded = 0;

    for simIdx = 1:numSimulations
        % Generate random input message
        inputMessage = randi([0 1], 9, 1);

        % Encode the message
        codeword = Enc(inputMessage);

        % Introduce AWGN
        snr = EbNoRange(snrIdx) + 10 * log10(K/N);
        noiseStdDev = 1 / sqrt(2 * 10^(snr/10));
        awgnNoise = noiseStdDev * randn(size(codeword));
        receivedCodeword = ((codeword + awgnNoise) >= 0.5);

        % Decode the codeword
        decodedMessage = Dec(receivedCodeword);

        % Count errors
        errorCount = errorCount + sum(decodedMessage ~= inputMessage);

        % Introduce AWGN to the unencoded message
        awgnNoise_uncoded = noiseStdDev * randn(size(inputMessage));
        receivedMessage_uncoded = ((inputMessage + awgnNoise_uncoded) >= 0.5);

        % Count errors for unencoded message
        errorCount_uncoded = errorCount_uncoded + sum(receivedMessage_uncoded ~= inputMessage);
    end

    % Calculate BER for this Eb/No value
    BER_enc(snrIdx) = errorCount / (numSimulations * K);
    BER_uncoded(snrIdx) = errorCount_uncoded / (numSimulations * K);

end

% Plot the results
figure;
semilogy(EbNoRange, BER_enc, 'o-', 'DisplayName', 'Encoded');
hold on;
semilogy(EbNoRange, BER_uncoded, 's-', 'DisplayName', 'Unencoded');
xlabel('Eb/No (dB)');
ylabel('BER');
title('Reed-Solomon Encoding vs. Unencoded (AWGN)');
legend('show');
grid on;