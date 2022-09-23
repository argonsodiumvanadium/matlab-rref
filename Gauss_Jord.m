function [] = main ()
    disp("hello world")
    gaussJordan([1 2 3 4; 5 6 7 8; 9 10 1 12; 13 14 15 16],[7; 8; 9; 11])
end

function [values] = gaussJordan (matrix,augumentation)
    newMatrix = [matrix augumentation];
    matrix = myRref(newMatrix);
    values = matrix(:,size(matrix,2))
end

%-- main function --%
function [rrefMatrix] = myRref (matrix)
    for row = 1:size(matrix,1)
        for column = 1:(size(matrix,2) - 1)
            if matrix(row, column) ~= 0
                matrix = normalise (matrix,row,matrix(row, column));
                matrix = nullifyColumns(matrix,row,column);
                break
            end
        end
    end
    rrefMatrix = swapToRref(matrix)
end

%-- basically divides a row by a number, useful to create pivot elements --% 
function [newMatrix] = normalise (matrix, row, factor)
    matrix(row,:) = matrix(row,:) / factor;
    newMatrix = matrix;
end

%-- This function is used to basically ensure the pivot columns are filled with 0s --%
function [nullifiedMatrix] =  nullifyColumns (matrix, rowIndex, columnIndex)
    row = matrix(rowIndex,:);

    for ri = 1:size(matrix,1)
        if ri == rowIndex 
            continue 
        end

        matrix = nullify (matrix, rowIndex, ri, matrix(ri, columnIndex));
    end

    nullifiedMatrix = matrix;
end

%-- this is for creating 0s in the other elements in a column of a matrix, requires --%
%-- the nullifyingRow to have a pivot                                               --%
function [newMatrix] = nullify (matrix, nullifyingRow, targetRow, factor) 
    matrix(targetRow,:) = matrix(targetRow,:) - matrix(nullifyingRow,:) * factor;
    newMatrix = matrix;
end

%-- basically swap to ensure all pivots are on the left of the previous pivot --%
function [finalMatrix] = swapToRref (matrix)
    rowToBeSwapped = 1;
    for ci = 1:(size(matrix,2) - 1)
        if sum(abs(matrix(:,ci))) == 1
            for ri = 1:size(matrix,1)
                if matrix(ri,ci) == 1
                    matrix = swap (matrix, rowToBeSwapped, ri);
                    rowToBeSwapped = rowToBeSwapped + 1;
                end
            end
        end
    end
       
    finalMatrix = matrix;
end

%-- this is for row swapping operations such as R1 <-> R2 --%
function [newMatrix] = swap(matrix, rowIndex1, rowIndex2) 
    temp = matrix(rowIndex1,:);
    matrix(rowIndex1,:) = matrix(rowIndex2,:);
    matrix(rowIndex2,:) = temp;
    newMatrix = matrix;
end

