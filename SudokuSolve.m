function S = SudokuSolve(grid)

% SudokuSolve: Solves a Sudoku puzzle using integer linear programming.
% The grid is a 9x9 matrix where empty cells are represented by zeros, 
% The function returns the solved Sudoku matrix S.
% In the matrix S Zeros in the input grid are replaced
% with the corresponding solved values.

arguments
    grid double {mustBeNonnegative,mustBeNonNan}
end
% Define the size of the Sudoku grid
N = size(grid, 1);

% Create the binary decision variables
x = optimvar("x",[N, N, N],'Type','integer','LowerBound',0,'UpperBound',1);

% Create the optimization problem
ipsudoku = optimproblem;

% Create the constraints
prefilled = optimconstr(N, N);
for i = 1:N
    for j = 1:N
        if grid(i, j) ~= 0
            % Fix the value of pre-filled cells
            prefilled(i, j) = x(i, j, grid(i, j)) == 1;
        else
            % If the cell is not pre-filled, enforce that one and only one digit is selected
            prefilled(i, j) = sum(x(i, j, :)) == 1;
        end
    end
end
ipsudoku.Constraints.prefilled = prefilled;

% Each digit should appear exactly once in each row, column, and 3x3 subgrid
for k = 1:N
    ipsudoku.Constraints.(['row' num2str(k)]) = sum(x(k,:,:),2) == 1;
    ipsudoku.Constraints.(['col' num2str(k)]) = sum(x(:,k,:),1) == 1;
    for p = 1:3:N
        for q = 1:3:N
            vect = x(p:p+2,q:q+2,k);
            ipsudoku.Constraints.(['square' num2str(p) num2str(q) num2str(k)]) = sum(vect, 'all') == 1;
        end
    end
end

% solve the optimization model
[solution,fval,exitflag,output] = solve(ipsudoku);

% Check if a solution was found
if exitflag == 1
    % Creating an S matrix for the solution
    S = zeros(N, N);
    for i = 1:N
        for j = 1:N
            for k = 1:N
                if solution.x(i, j, k) >0
                    S(i, j) = k;
                end
            end
        end
    end
else
    error('No feasible solution found.');
end
