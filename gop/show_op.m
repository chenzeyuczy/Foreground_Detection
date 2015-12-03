% Function to show object proposal within an image,
% writen by chenzy.
% Input
%     - imageData: Original image data.
%     - op_mask: Mask for particular object proposal.
%     - op_box: Border around the proposal, optional.

function show_op(imageData, op_mask, op_box)
    
    imageCopy = 1*imageData;
    % Convert proposal area into red.
    imageCopy(:,:,1) = imageCopy(:,:,1) .* (1-op_mask) + op_mask*255;
    imageCopy(:,:,2) = imageCopy(:,:,2) .* (1-op_mask);
    imageCopy(:,:,3) = imageCopy(:,:,3) .* (1-op_mask);
    imagesc( imageCopy );
    if nargin > 2
        % Draw lines around the box.
        rectangle( 'Position', [op_box(1),op_box(2),op_box(3)-op_box(1)+1,op_box(4)-op_box(2)+1], 'LineWidth',2, 'EdgeColor',[0,1,0] );
    end
end