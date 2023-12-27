function savefig_helper(options, name)
    if options('savefig')
        fname = strcat(options('foldername'), options('filename'), name);
        saveas(gcf, strcat(fname, '.fig'));
        saveas(gcf, strcat(fname, '.svg'));
        
        if options('savepdf')
            % Save figures as pdf to preserve the transparency
            % saveas(gcf, strcat(fname, '.pdf'));
            print(gcf, strcat(fname, '.pdf'), '-dpdf')
        else
            saveas(gcf, strcat(fname, '.epsc'));
            movefile(strcat(fname, '.epsc'), strcat(fname, '.eps'))
        end
    end
end
