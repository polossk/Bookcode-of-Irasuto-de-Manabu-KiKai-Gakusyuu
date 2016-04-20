%% Example 3.1 Basic Linear Regression with Least Square Method
%
% * *Result in book* : Figure 3.1
% * *Code in book* : Figure 3.2
% * *Output* : |eg03_1.png|
% * *Usage* : |eg03_1(), eg03_1(50, 1000)|
%
%% Source Code
function eg03_1(n, N)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 2
        n = 50; N = 1000;
    end

    % constant
    x = linspace(-3, 3, n)';
    X = linspace(-3, 3, N)';
    pix = pi * x;
    y = sin(pix) ./ pix + 0.1 * x + 0.05 * randn(n, 1);

    % base function
    p(:, 1) = ones(n, 1);
    P(:, 1) = ones(N, 1);
    for jj = 1 : 15
        p(:, 2 * jj) = sin(jj / 2 * x); p(:, 2 * jj + 1) = cos(jj / 2 * x);
        P(:, 2 * jj) = sin(jj / 2 * X); P(:, 2 * jj + 1) = cos(jj / 2 * X);
    end

    % solve
    t = p \ y;
    F = P * t;

    % plot
    figure('Name', 'example 3-1'); clf; hold on;
    plot(X, F, 'g-'); plot(x, y, 'bo');
    setFigure('example 3-1');

    % save figure
    saveas(gcf, 'eg03_1', 'png');

    % sub-function, figure setting
    function [] = setFigure( tag )
        title(tag); xlabel('\itx');
        xlim([-2.8, 2.8]); ylim([-0.5, 1.2]);
    end
end
