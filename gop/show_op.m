% Function to show object proposal within an image,
% writen by chenzy.
% Input
%     - img: Original image.
%     - op_mask: Mask for particular object proposal.
%     - op_box: Border around the proposal, optional.

function show_op(img, op_mask, op_box)
    
    imgCopy = 1*img;
    % Convert proposal area into red.
    imgCopy(:,:,1) = imgCopy(:,:,1) .* (1-op_mask) + op_mask*255;
    imgCopy(:,:,2) = imgCopy(:,:,2) .* (1-op_mask);
    imgCopy(:,:,3) = imgCopy(:,:,3) .* (1-op_mask);
    imagesc( imgCopy );
    if nargin > 2
        % Draw lines around the box.
        rectangle( 'Position', [op_box(1),op_box(2),op_box(3)-op_box(1)+1,op_box(4)-op_box(2)+1], 'LineWidth',2, 'EdgeColor',[0,1,0] );
    end
end