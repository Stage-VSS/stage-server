function main()
    busy = appbox.BusyPresenter('This may take a moment.', 'Starting...');
    busy.go();
    deleteBusy = onCleanup(@()delete(busy));
    
    updater = appbox.GitHubUpdater();
    isUpdate = updater.checkForUpdates(stage.app.App.owner, stage.app.App.repo, struct('name', stage.app.App.name, 'version', stage.app.App.version));
    if isUpdate
        p = appbox.UpdatePresenter(updater);
        p.goWaitStop();
        id = p.result;
        if ~isempty(id)
            matlab.apputil.run(id);
            return;
        end
    end

    presenter = stageui.ui.presenters.MainPresenter();
    
    delete(busy);
    presenter.go();
end

