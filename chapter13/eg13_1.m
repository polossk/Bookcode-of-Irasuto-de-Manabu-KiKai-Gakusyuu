%% Example 13.1 Principal Component Analysis
%
% * *Result in book* : Figure 13.5
% * *Code in book* : Figure 13.6
% * *Output* : |eg13_1.png|
% * *Usage* : |eg13_1(), eg13_1(100)|
%
%% Source Code
function eg13_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 100;
    end
    figure('Name', 'Principal Component Analysis Example');

    x = [2 * randn(n, 1), randn(n, 1)];
    [X, t] = pca_( x );
    subplot(2, 1, 1); hold on; title('Example A');
    axis([-6, 6, -3, 3]);
    plot(x(:, 1), x(:, 2), 'rx');
    plot(9 * [-t(1) t(1)], 9 * [-t(2) t(2)]);

    x = [2 * randn(n, 1), 2 * round(rand(n, 1)) - 1 + randn(n, 1) / 3];
    [X, t] = pca_( x );
    subplot(2, 1, 2); hold on; title('Example B');
    axis([-6, 6, -3, 3])
    plot(x(:, 1), x(:, 2), 'rx');
    plot(9 * [-t(1) t(1)], 9 * [-t(2) t(2)]);

    saveas(gcf, 'eg13_1', 'png');

    function [X, t] = pca_( x )
        x = x - repmat(mean(x), [n, 1]);
        [t, v] = eigs(x' * x, 1);
        X = x * (t * t');
    end
end