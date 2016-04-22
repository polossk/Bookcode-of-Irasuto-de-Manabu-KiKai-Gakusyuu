%% Example 14.3 Parameter Selection
%
% * *Result in book* : Figure 14.8
% * *Code in book* : Figure 14.9
% * *Output* : |eg14_3.png|
% * *Usage* : |eg14_3(), eg14_3(500)|
%
%% Source Code
function eg14_3(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 500;
    end
    a = linspace(0, 2 * pi, n / 2)';
    x = [a .* cos(a), a .* sin(a);
        (a + pi) .* cos(a), (a + pi) .* sin(a)];
    x = x + rand(n, 2);
    x = x - repmat(mean(x), [n, 1]);
    x2 = sum(x .^ 2, 2);
    y = [ones(1, n / 2), zeros(1, n / 2)];
    d = repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * (x * x');

    hhs = 2 * [0.5 1 2] .^ 2;
    ls = 10 .^ [-5 -4 -3];
    m = 5;
    u = floor(m * (0 : n - 1) / n) + 1;
    u = u(randperm(n));
    g = zeros(length(hhs), length(ls), m);
    for hk = 1 : length(hhs)
        hh = hhs(hk);
        k = exp(-d / hh);
        for jj = unique(y),
            for ii = 1 : m
                ki = k(u ~= ii, y == jj);
                kc = k(u == ii, y == jj);
                Gi = ki' * ki * sum(u ~= ii & y == jj) / (sum(u ~= ii) ^ 2);
                Gc = kc' * kc * sum(u == ii & y == jj) / (sum(u == ii) ^ 2);
                hi = sum(k(u ~= ii & y == jj, y == jj), 1)' / sum(u ~= ii);
                hc = sum(k(u == ii & y == jj, y == jj), 1)' / sum(u == ii);
                for lk = 1 : length(ls)
                    l = ls(lk); a = (Gi + l * eye(sum(y == jj))) \ hi;
                    g(hk, lk, ii) = g(hk, lk, ii) + a' * Gc * a / 2 - hc' * a;
                end
            end
        end
    end

    g = mean(g, 3);
    [gl, ggl] = min(g, [], 2);
    [ghl, gghl] = min(gl);
    L = ls(ggl(gghl));
    HH = hhs(gghl);
    s = -1 / 2;

    for jj = unique(y)
        k = exp(-d(:, y == jj) / HH);
        h = sum(k(y == jj, :), 2) / n;
        t = sum(y == jj);
        s = s + h' * ( ( k' * k * t / (n ^ 2) + L * eye(t) ) \ h ) / 2;
    end
    msg = sprintf('Information = %g', s);
    disp(msg);

    figure('Name', 'Parameter Selection'); clf; 
    title('Clustering Result'); hold on;
    axis([-10 10 -10 10]);
    xlabel('\itx^{(1)}');
    ylabel('\itx^{(2)}');
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 0, 1), x(y == 0, 2), 'rx');
    text(-9.5, 9.5, msg);
    saveas(gcf, 'eg14_3', 'png');
end