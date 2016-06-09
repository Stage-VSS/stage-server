function main()
    busy = appbox.BusyPresenter('This may take a moment.', 'Starting...');
    busy.go();
    deleteBusy = onCleanup(@()delete(busy));
    
    updater = appbox.GitHubUpdater();
    isUpdate = updater.checkForUpdates(stage.app.App.owner, stage.app.App.repo, struct('name', stage.app.App.name, 'version', stage.app.App.version));
    if isUpdate
        appbox.UpdatePresenter(updater).goWaitStop();
    end

    presenter = stageui.ui.presenters.MainPresenter();
    
    delete(busy);
    presenter.go();
end

