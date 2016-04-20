%% Example 8.2 Least Ramp Loss Classification
%
% * *Result in book* : Figure 8.19
% * *Code in book* : Figure 8.20
% * *Output* : |eg08_2.png|
% * *Usage* : |eg08_2(), eg08_2(40)|
%
%% Source Code
function eg08_2(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 40;
    end

    x = [randn(1, n / 2) - 15, randn(1 , n / 2) - 5; randn(1, n)]';
    y = [ones(n / 2, 1); -ones(n / 2, 1)];

    % outlier
    x(1 : 2, 1) = x(1 : 2, 1) + 60; x(:, 3) = 1;

    % constant
    l = 0.01; e = 0.01; t0 = zeros(3, 1);
    for o = 1 : 1000
        m = (x * t0) .* y;
        v = m + min(1, max(0, 1 - m));
        a = abs(v - m);
        w = ones(size(y));
        w(a > e) = e ./ a(a > e);
        t = (x' * (repmat(w, 1, 3) .* x) + l * eye(3)) \ (x' * (w .* v .* y));
        if norm(t - t0) < 0.001, break, end
        t0 = t;
    end

    figure('Name', 'Least Ramp Loss Example'); clf; hold on;
    z = [-20 50];
    axis([z -2 2]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == -1, 1), x(y == -1, 2), 'rx');
    plot(z, -(t(3) + z * t(1)) / t(2), 'k-');
    legend('Class A', 'Class B', 'Boundary');
    title('Least Ramp Loss Example');
    saveas(gcf, 'eg08_2', 'png');
end