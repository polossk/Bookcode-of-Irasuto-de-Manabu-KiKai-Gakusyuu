%% Example 15.1 Passive-Aggressive Classification
%
% * *Result in book* : Figure 15.5
% * *Code in book* : Figure 15.6
% * *Output* : |eg15_1.png|
% * *Usage* : |eg15_1(), eg15_1(200)|
%
%% Source Code
function eg15_1(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 200;
    end
    x = [randn(1, n / 2) - 5 randn(1, n / 2) + 5;
        5 * randn(1, n)]';
    y = [ones(n / 2, 1); -ones(n / 2, 1)];
    x(:, 3) = 1;
    p = randperm(n);
    x = x(p, :);
    y = y(p);

    t = zeros(3, 1);
    l = 1; id = 1;

    figure('Name', 'Passive-Aggressive Classification'); clf;

    for ii = 1 : length(x)
        xi = x(ii, :)';
        yi = y(ii);
        t = t + yi * max(0, 1 - t' * xi * yi) / (xi' * xi + l) * xi;
        if (ismember(ii, [3, 5, 10, 200]) == 1)
            plotFigure( 2, 2, id, ii, t );
            id = id + 1;
        end 
    end

    saveas(gcf, 'eg15_1', 'png');

    % sub-function, plot sub-figure
    function [] = plotFigure( M, N, id, num, t )
        subplot(M, N, id); hold on;
        axis([-10 10 -10 10]);
        x_ = x(1 : num, :);
        y_ = y(1 : num);
        plot(x_(y_ == 1, 1), x_(y_ == 1, 2), 'bo');
        plot(x_(y_ == -1, 1), x_(y_ == -1, 2), 'rx');
        plot([-10 10], -(t(3) + [-10 10] * t(1)) / t(2), 'k-');
        setFigure(strcat(num2str(num), ' samples.'));
    end

    % sub-function, figure setting
    function [] = setFigure( tag )
        title(tag);
        xlabel('\itx^{(1)}');
        ylabel('\itx^{(2)}');
    end
end