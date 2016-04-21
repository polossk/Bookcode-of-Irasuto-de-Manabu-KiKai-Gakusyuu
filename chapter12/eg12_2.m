%% Example 12.2 Kullback-Leibler Divergence
%
% * *Result in book* : Figure 12.6
% * *Code in book* : Figure 12.7
% * *Output* : |eg12_2_A.png, eg12_2_B.png|
% * *Usage* : |eg12_2(), eg12_2(100)|
%
%% Source Code
function eg12_2(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 100;
    end

    x = randn(n, 1); y = randn(n, 1);
    y(n) = 5;
    hhs = 2 * [1 5 10 ] .^ 2;
    m = 5;
    x2 = x .^ 2; y2 = y .^ 2;
    xy = repmat(x2, 1, n) + repmat(y2', n, 1) - 2 * (x * y');
    yx = repmat(y2, 1, n) + repmat(x2', n, 1) - 2 * (x * y');
    u = floor(m * (0 : n - 1) / n) + 1;
    u = u(randperm(n));
    g = zeros(length(hhs), m);

    for hk = 1 : length(hhs)
        hh = hhs(hk);
        k = exp(-xy / hh);
        r = exp(-yx / hh);
        for ii = 1 : m
            g(hk, ii) = mean(k(u == ii, :) * KLIEP(k(u ~= ii, :), r));
        end
    end
    [~, ggh] = max(mean(g, 2));
    HH = hhs(ggh);
    k = exp(-xy / HH);
    r = exp(-yx / HH);
    s = r * KLIEP(k, r);

    figure('Name', 'Kullback-Leibler Divergence Example A');
    clf; hold on; title('Data Distribution');
    bins = -2.5 : 1 : 5.5;
    subplot(2, 1, 1);
    histogram(x, bins); legend('Regular');
    subplot(2, 1, 2);
    histogram(y, bins); legend('Test');
    saveas(gcf, 'eg12_2_A', 'png');

    figure('Name', 'Kullback-Leibler Divergence Example B');
    clf; hold on; title('Kullback-Leibler Divergence Example');
    axis([-3, 6, 0, 1.1]);
    plot(y, s, 'rx');
    legend('w(x_i)');
    saveas(gcf, 'eg12_2_B', 'png');

    function a = KLIEP( k, r )
        a0 = rand(size(k, 2), 1);
        b = mean(r)';
        c = sum(b .^ 2);
        for o = 1 : 1000
            a = a0 + 0.01 * k' * (1 ./ k * a0);
            a = a + b * (1 - sum(b .* a)) / c;
            a = max(0, a);
            a = a / sum(b .* a);
            if norm(a - a0) < 0.001, break, end
            a0 = a;
        end
    end
end