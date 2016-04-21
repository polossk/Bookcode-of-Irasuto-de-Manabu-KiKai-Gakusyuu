%% Example 13.3 Laplacian Eigenmaps
%
% * *Result in book* : Figure 13.13
% * *Code in book* : Figure 13.14
% * *Output* : |eg13_3_A.png, eg13_3_A.png|
% * *Usage* : |eg13_3(), eg13_3(1000, 10)|
%
%% Source Code
function eg13_3(n)
    % init
    rng(0, 'v5uniform'); rng(0, 'v5normal');
    % recommended, use it in future instead of
    % rand('state', 0); randn('state', 0);
    if nargin < 1
        n = 1000; k = 10;
    end

    a = 3 * pi * rand(n, 1);
    x = [a .* cos(a) 30 * rand(n, 1) a .* sin(a)];

    [z, v] = lp_( x );

    figure('Name', 'Laplacian Eigenmaps Example');
    clf; hold on; title('Original Data');
    view([15 10]);
    scatter3(x(:, 1), x(:, 2), x(:, 3), 40, a, 'o');
    saveas(gcf, 'eg13_3_A', 'png');

    figure('Name', 'Laplacian Eigenmaps Example');
    clf; hold on; title('After Projection');
    scatter(z(:, 2), z(:, 1), 40, a, 'o');

    saveas(gcf, 'eg13_3_B', 'png');

    function [z, v] = lp_( x )
        x = x - repmat(mean(x), [n, 1]);
        x2 = sum(x .^ 2, 2);
        d = repmat(x2, 1, n) + repmat(x2', n, 1) - 2 * x * x';
        [p, ~] = sort(d);
        W = sparse(d <= ones(n, 1) * p(k + 1, :));
        W = (W + W' ~= 0);
        D = diag(sum(W, 2));
        L = D - W;
        [z, v] = eigs(L, D, 3, 'sm');
    end
end