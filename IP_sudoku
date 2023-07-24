clear;clc;close all

grid = [5 3 0 0 7 0 0 0 0;
        6 0 0 1 9 5 0 0 0;
        0 9 8 0 0 0 0 6 0;
        8 0 0 0 6 0 0 0 3;
        4 0 0 8 0 3 0 0 1;
        7 0 0 0 2 0 0 0 6;
        0 6 0 0 0 0 2 8 0;
        0 0 0 4 1 9 0 0 5;
        0 0 0 0 8 0 0 7 9 ];

% Define the size of the Sudoku grid
N = size(grid, 1);

% Create the binary decision variables
x = optimvar('x',[N, N, N],'Type','integer','LowerBound',0,'UpperBound',1);

% Create the objective function weights (all equal to 1)
weights = ones([N,N,N]);

% Create the optimization problem
ipsudoku = optimproblem;

% Set up the objective function
ipsudoku.Objective = sum(sum(sum(weights .* x)));


% Create the constraints
prefilled = optimconstr(60,1);
for i = 1:N
    for j = 1:N
        if grid(i, j) ~= 0
            % Fix the value of pre-filled cells
                      prefilled(i,1)= x(i, j, grid(i, j)) == 1;
        end
    end
end

   ipsudoku.Constraints.prefilled=prefilled;
    ipsudoku.Constraints.ci=sum(x,1)==1;
     ipsudoku.Constraints.cj=sum(x,2)==1;
      ipsudoku.Constraints.ck=sum(x,3)==1;

 % Each digit should appear exactly once in each 3x3 subgrid
   squarecon = optimconstr(3,3,9);
for p = 1:3:N
    for q = 1:3:N
        for k = 1:N
             vect = x(3*(p-1)+1:3*(p-1)+3,3*(q-1)+1:3*(q-1)+3,:);
                squarecon(p,q,:) = sum(sum(vect,1),2) == ones(1,1,9);
        end
    end
end

 ipsudoku.Constraints.squarecon=squarecon;

% solve the optimization model
solution=solve(ipsudoku);
solution.x = round(solution.x);

% creating an S matrix for the solution
y = ones(size(solution.x));
for k = 2:9
    y(:,:,k) = k; 
end
S = solution.x.*y; 
S = sum(S,3); 
