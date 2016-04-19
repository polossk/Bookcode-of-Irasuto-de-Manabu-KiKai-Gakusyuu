%% Example 8.1 Support Vector Machine
%
% * *Result in book* : Figure 8.10
% * *Code in book* : none
% * *Output* : |eg8_1.png|
% * *Usage* : |eg8_1(), eg8_1(400)|
%
%% Source Code
function eg8_1(n)
    % init
    rng(0);
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 400;
    end

    % constant
    a = linspace(0, 4 * pi, n / 2);
    a = [a a a a];

    randin = @(a, b, n, m)...
        ((a + b) / 2.0 + (b - a) / 2.0 * rand(n, m));

    u = [randin(0.7, 1, n, 1); randin(0.8, 1, 2 * n, 1); randin(0.7, 1, n, 1)];
    u = [a .* cos(a), (a + pi) .* cos(a)]' .* u;
    v = [randin(0.7, 1, n, 1); randin(0.8, 1, 2 * n, 1); randin(0.7, 1, n, 1)];
    v = [a .* sin(a), (a + pi) .* sin(a)]' .* v;

    x = [u, v];

    getlabel = @(name, n) ...
        (mat2cell(repmat(name, n, 1), ones(1, n), length(name)));

    y = cat(1, getlabel('inner', n * 2), getlabel('outter', n * 2));

    % support vector mechines model
    SVMModel = fitcsvm(x, y, 'KernelFunction', 'gaussian')

    % plot
    classes = SVMModel.ClassNames;
    sv = SVMModel.SupportVectors;
    figure('Name', 'SVM Example');
    gscatter(x(:, 1), x(:, 2), y);
    hold on;
    plot(sv(:, 1), sv(:, 2), 'ko', 'MarkerSize', 8);
    legend(classes{1}, classes{2}, 'Support Vector');
    axis([-13.5, 16.5, -15, 15]); axis square;
    title('Support Vector Machine Classification');
    saveas(gcf, 'eg8_1', 'png');
end