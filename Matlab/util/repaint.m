 function repaint(newState, step)
        newState = reshape(newState, sqrt(length(newState)), sqrt(length(newState)));
        imagesc(newState); 
        xlabel(sprintf('step = %d',step));
        axis square;
        colormap bone;
        drawnow;
        pause(0.1);
end