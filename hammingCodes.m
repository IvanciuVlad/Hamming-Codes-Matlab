prompt1 = 'How many parity bits?: ';
n = input(prompt1) % Number of parity bits 
len = 2^n - 1;% Nr of total bits
nr_dB = len - n; % Nr of data bits

% Randomly generated message 
dataBits = round(rand(1, nr_dB)) %d_ndB d_ndB-1... d_2 d_1

% Parity bit coverage matrice 
M = dec2bin(1:1:2^n-1) - '0'; 
O = ones(1,n);
Sr = O*M'; % Parity bit coverage sum, row wise
C_i = []; % Control bits place in string
D_i = []; % Data bits place in string

for i = 1:len
    if(Sr(i)) == 1
        C_i = [C_i, i];
    else
        D_i = [D_i, i];
    end
end

% Calculating control bits
controlBits = zeros(1, n); 
for r = 1:n
    sum = 0;
    for c = 1:len
        if (M(c, (n+1-r)) == 1 && c ~= C_i(r))
            for e = 1:nr_dB
                if(D_i(e) == c)
                    sum = sum + dataBits(nr_dB+1-e);
                end
            end
        end
    end
    controlBits(r) = mod(sum, 2);
end
controlBits

% Encoding the message
bits = zeros(1, len); % Encoded message
for i = 1:n
    bits(len+1- C_i(i)) = controlBits(i);
end
            
for j = 1:nr_dB
    bits(len+1-D_i(j)) = dataBits(nr_dB+1-j);
end   
bits


%--------------------------------------------------------------------%
prompt2='Poziton of the flipped bit: ';
p = input(prompt2)

% Flipping the requested bit
if bits(len+1-p) == 0
    bits(len+1-p) = 1;
else
    bits(len+1-p) = 0;
end

bits

for i = 1:n
    if C_i(i) == p
        controlBits(i) = bits(len+1-p);
    end
end

for i = 1:nr_dB
    if D_i(i) == p
        dataBits(nr_dB+1-i) = bits(len+1-p);
    end
end


%--------------------------------------------------------------------%
%Verification
s = []; % Symdromes
for r = 1:n
    sum = 0;
    for c = 1:len
        if (M(c, (n+1-r)) == 1 && c ~= C_i(r))
            for e = 1:nr_dB
                if(D_i(e) == c)
                    sum = sum + dataBits(nr_dB+1-e);
                end
            end
        end
    end
    
    sum = sum + controlBits(r);
    s(n+1-r) = mod(sum, 2);
end
s

% Calculating flipped bit position
flipped_bit_position = 0;
for i = 1:n
    flipped_bit_position = flipped_bit_position + s(n+1-i)*2^(i-1);
end
flipped_bit_position
