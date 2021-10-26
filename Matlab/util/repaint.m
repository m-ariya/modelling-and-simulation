 function repaint(newState, step)
        newState = reshape(newState, sqrt(length(newState)), sqrt(length(newState)));
        imagesc(newState); 
        title('Reconstructing...');
        xlabel(sprintf('step = %d',step));
        axis square;
        colormap bone;
        drawnow;
        pause(0.03);
end