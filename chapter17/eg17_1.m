%% Example 17.1 Fisher Discriminant Analysis
%
% * *Result in book* : Figure 17.1
% * *Code in book* : Figure 17.2
% * *Output* : |eg17_1.png|
% * *Usage* : |eg17_1(), eg17_1(100)|
%
%% Source Code
function eg17_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 100;
    end
    x_ = randn(n, 2);
    y = [ones(n / 2, 1); 2 * ones(n / 2, 1)];
    figure('Name', 'Fisher Discriminant Analysis Example');
    
    x = x_;
    x(1 : n / 2, 1) = x(1 : n / 2, 1) - 4;
    x(n / 2 + 1 : end, 1) = x(n / 2 + 1: end, 1) + 4;
    [t, v] = fisher_( x );
    subplot(2, 1, 1); hold on; title('Example A');
    axis([-8, 8, -6, 6]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 2, 1), x(y == 2, 2), 'rx');
    plot(99 * [-t(1), t(1)], 99 * [-t(2), t(2)], 'k-');

    x = x_;
    x(1 : n / 4, 1) = x(1 : n / 4, 1) - 4;
    x(n / 4 + 1 : n / 2, 1) = x(n / 4 + 1: n / 2, 1) + 4;
    [t, v] = fisher_( x );
    subplot(2, 1, 2); hold on; title('Example B');
    axis([-8, 8, -6, 6]);
    plot(x(y == 1, 1), x(y == 1, 2), 'bo');
    plot(x(y == 2, 1), x(y == 2, 2), 'rx');
    plot(99 * [-t(1), t(1)], 99 * [-t(2), t(2)], 'k-');

    saveas(gcf, 'eg17_1', 'png');

    function [t, v] = fisher_( x )
        x = x - repmat(mean(x), [n, 1]);
        m1 = mean(x(y == 1, :));
        m2 = mean(x(y == 2, :));
        x1 = x(y == 1, :) - repmat(m1, [n / 2, 1]);
        x2 = x(y == 2, :) - repmat(m2, [n / 2, 1]);
        [t, v] = eigs(n / 2 * m1' * m1 + n / 2 * m2' * m2, ...
            x1' * x1 + x2' * x2, 1);
    end
end