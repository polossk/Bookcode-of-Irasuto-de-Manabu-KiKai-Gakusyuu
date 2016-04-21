%% Example 12.1 Local Outlier Factor
%
% * *Result in book* : Figure 12.1
% * *Code in book* : Figure 12.2
% * *Output* : |eg12_1.png|
% * *Usage* : |eg12_1(), eg12_1(100, 3)|
%
%% Source Code
function eg12_1(n, k)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 2
        n = 100; k = 3;
    end

    x = [(rand(n / 2, 2) - 0.5) * 20; randn(n / 2, 2)];
    x(n, 1) = 14;
    x2 = sum(x .^ 2, 2);
    dis = sqrt(repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x');
    [s, t] = sort(dis, 2);

    RD = zeros(n, k);
    LRD = zeros(n, k + 1);

    for ii = 1 : k + 1
        for jj = 1 : k
            RD(:, jj) = max( ...
            	s( t( t(:, ii), jj + 1 ), k ), ...
            	s( t(:, ii), jj + 1 ) ...
            );
        end
        LRD(:, ii) = 1 ./ mean(RD, 2);
    end
    LOF = mean(LRD(:, 2 : k + 1), 2) ./ LRD(:, 1);

    figure('Name', 'Local Outlier Factor Example'); clf; hold on
    title('Local Outlier Factor Example');
    axis([-10, 15, -10, 10]);
    plot(x(:, 1), x(:, 2), 'rx');
    for ii = 1 : n
        plot(x(ii , 1), x(ii , 2), 'bo', 'MarkerSize', LOF(ii) * 10);
    end
    saveas(gcf, 'eg12_1', 'png');
end
