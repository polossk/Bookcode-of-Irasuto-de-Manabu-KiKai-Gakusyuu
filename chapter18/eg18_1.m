%% Example 18.1 Importance Sampling Using Relative Density
%
% * *Result in book* : Figure 18.5
% * *Code in book* : Figure 18.6
% * *Output* : |eg18_1_A.png, eg18_1_B.png|
% * *Usage* : |eg18_1(), eg18_1(300)|
%
%% Source Code
function eg18_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 300;
    end
    x = randn(n, 1); y = randn(n, 1) + 0.5;
    hhs = 2 * [1 5 10] .^ 2;
    ls = 10 .^ [-3  -2  -1];
    m = 5; b = 0.5;
    x2 = x .^ 2; y2 = y .^ 2;
    xx = repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x';
    yx = repmat(y2, 1, n) + repmat(x2', n, 1) - 2 * y * x';
    u = floor(m * (0:n - 1) / n) + 1; u = u(randperm(n));
    v = floor(m * (0:n - 1) / n) + 1; v = v(randperm(n));

    g = zeros(length(hhs), length(ls), m);
    for hk = 1 : length(hhs)
        hh = hhs(hk); k = exp( - xx / hh); r = exp( - yx / hh);
        for ii = 1 : m
            ki = k(u ~= ii, :); kc = k(u == ii, :);
            ri = r(v ~= ii, :); rj = r(v == ii, :);
            h = mean(ki)';
            G = b * ki' * ki / sum(u ~= ii) + (1 - b) * ri' * ri / sum(v ~= ii);
            for lk = 1 : length(ls)
                l = ls(lk);
                a = (G + l * eye(n)) \ h;
                kca = kc * a;
                g(hk, lk, ii) = b * mean(kca .^ 2) + (1 - b) * mean((rj * a) .^ 2);
                g(hk, lk, ii) = g(hk, lk, ii) / 2 - mean(kca);
            end
        end
    end
    [gl, ggl] = min(mean(g, 3), [], 2);
    [ghl, gghl] = min(gl);
    L = ls(ggl(gghl));
    HH = hhs(gghl);
    k = exp(-xx / HH);
    r = exp(-yx / HH);
    s = r * ((b * k' * k / n + (1 - b) * r' * r / n + L * eye(n)) \ (mean(k)'));

    figure('Name', 'Relative Density Example A');
    clf; hold on; suptitle('Data Distribution');
    bins = -2.75 : 0.5 : 4.25;
    subplot(2, 1, 1); histogram(x, bins);
    axis([-3, 4, 0, 75]); legend('\itx_i''');
    subplot(2, 1, 2); histogram(y, bins);
    axis([-3, 4, 0, 75]); legend('\itx_i');
    saveas(gcf, 'eg18_1_A', 'png');

    figure('Name', 'Relative Density Example B');
    clf; hold on; title('Relative Density (\beta = 0.5)');
    x_ = sort(x); [y_, idx] = sort(y);
    xh = normpdf(x_, 0, 1);
    yh = normpdf(y_, 0.5, 1);
    plot(x_, xh, '-', y_, yh, '--', y_, s(idx), 'rx-');
    legend('\itp''(\itx)', '\itp(\itx)', '\itw(\itx)');
    axis([-3, 4, 0, 1.8]);
    saveas(gcf, 'eg18_1_B', 'png');
end

