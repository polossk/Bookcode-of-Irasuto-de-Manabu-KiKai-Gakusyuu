%% Example 18.2 Importance Sampling Using Density Contrast
%
% * *Result in book* : Figure 18.10
% * *Code in book* : Figure 18.11
% * *Output* : |eg18_2_A.png, eg18_2_B.png|
% * *Usage* : |eg18_2(), eg18_2(200)|
%
%% Source Code
function eg18_2(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 200;
    end
    x = randn(n, 1) - 1; y = randn(n, 1) + 1;

    hhs = 2 * [0.5 1 3] .^ 2;
    ls = 10 .^ [ -2  -1 0];
    m = 5;
    x2 = x .^ 2; y2 = y .^ 2;
    xx = repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x';
    yx = repmat(y2, 1, n) + repmat(x2', n, 1) - 2 * y * x';
    u = floor(m * (0:n - 1) / n) + 1; u = u(randperm(n));
    v = floor(m * (0:n - 1) / n) + 1; v = v(randperm(n));

    g = zeros(length( hhs), length(ls), m);
    for hk = 1 : length(hhs)
        hh = hhs(hk); k = exp( - xx / hh); r = exp( - yx / hh);
        U = (pi * hh / 2) ^ (1 / 2) * exp(-xx / (2 * hh));
        for ii = 1 : m
            vh = mean(k(u ~= ii, :))' - mean(r(v ~= ii, :))';
            z = mean(k(u == ii, :)) - mean(r(v == ii, :));
            for lk = 1:length(ls)
                l = ls(lk); a = (U + l * eye(n)) \ vh;
                g(hk, lk, ii) = a' * U * a - 2 * z * a;
            end
        end
    end
    [gl, ggl] = min(mean(g, 3), [], 2);
    [ghl, gghl] = min(gl);
    L = ls(ggl(gghl));
    HH = hhs(gghl);
    k = exp(-xx / HH);
    r = exp(-yx / HH);
    vh = mean(k)' - mean(r)';
    U = (pi * HH / 2) ^ (1 / 2) * exp(-xx / (2 * HH));
    a = (U + L * eye(n)) \ vh;
    s = [k;r] * a;
    L2 = 2 * a' * vh - a' * U * a;

    figure('Name', 'Density Contrast Example A');
    clf; hold on; suptitle('Data Distribution');
    bins = -3.25 : 0.5 : 4.25;
    subplot(2, 1, 1); histogram(x, bins);
    axis([-3, 4, 0, 75]); legend('\itx_i''');
    subplot(2, 1, 2); histogram(y, bins);
    axis([-3, 4, 0, 75]); legend('\itx_i');
    saveas(gcf, 'eg18_2_A', 'png');

    figure('Name', 'Density Contrast Example B');
    clf; hold on; title('Density Contrast');
    x_ = -4 : 0.1 : 4;
    xh = normpdf(x_, -1, 1);
    yh = normpdf(x_, 1, 1);
    [xy_, idx] = sort([x; y]);
    plot(x_, xh, '-', x_, yh, '--', xy_, s(idx), 'rx-');
    legend('\itp''(\itx)', '\itp(\itx)', '\itw(\itx)');
    axis([-4, 4, -0.4, 0.4]);
    saveas(gcf, 'eg18_2_B', 'png');
end