function main()
    uix.tracking('off');

    busy = appbox.BusyPresenter('Starting...');
    busy.go();
    deleteBusy = onCleanup(@()delete(busy));

    updater = appbox.GitHubUpdater();
    appLocation = fullfile(fileparts(mfilename('fullpath')), '..', '..', '..', '..');
    isUpdate = updater.checkForUpdates(stage.app.App.owner, stage.app.App.repo, ...
        struct('name', stage.app.App.name, 'version', stage.app.App.version, 'appLocation', appLocation));
    if isUpdate
        p = appbox.UpdatePresenter(updater);
        p.goWaitStop();
        info = p.result;
        if ~isempty(info)
            msg = 'The update is complete. You must run ''clear classes'' or restart MATLAB before Stage Server will launch again.';
            appbox.MessagePresenter(msg, 'Update Complete').goWaitStop();
            disp(msg);
            return;
        end
    end

    presenter = stageui.ui.presenters.MainPresenter();

    delete(busy);
    presenter.go();
end
