function [modified_matrix] = mask_matrix(matrix, selected_value)

    modified_matrix = matrix == selected_value;

end
