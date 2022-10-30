% データの列を一定であるとみなして，外れ値を取り除く

function rep = cleanup(data)
data = squeeze(data);
dataR = real(data);
dataI = imag(data);
N = size(data,1);
stdR = std(dataR);
stdI = std(dataI);
avgR = mean(dataR);
avgI = mean(dataI);
for i = 1:N
    if (dataR(i) > avgR+stdR) || (dataR(i) < avgR-stdR) || (dataI(i) > avgI+stdI) || (dataI(i) < avgI-stdI)
        data(i) = NaN;
    end
end
data = rmmissing(data);
rep = mean(data);