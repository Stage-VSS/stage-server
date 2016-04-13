function package(skipTests)
    if nargin < 1
        skipTests = false;
    end

    if ~skipTests
        test();
    end
    
    rootPath = fileparts(mfilename('fullpath'));
    targetPath = fullfile(rootPath, 'target');
    [~, ~] = mkdir(targetPath);
    
    addpath(genpath(fullfile(rootPath, 'lib')));
    addpath(genpath(fullfile(rootPath, 'src')));
    
    projectFile = fullfile(rootPath, 'Stage Server.prj');

    dom = xmlread(projectFile);
    root = dom.getDocumentElement();
    config = root.getElementsByTagName('configuration').item(0);
    
    % Update version number.
    version = config.getElementsByTagName('param.version').item(0);
    version.setTextContent(stageui.app.App.version);
    
    % Replace fullpaths with ${PROJECT_ROOT}.
    config.setAttribute('file', '${PROJECT_ROOT}\Stage Server.prj');
    config.setAttribute('location', '${PROJECT_ROOT}');
    output = config.getElementsByTagName('param.output').item(0);
    output.setTextContent('${PROJECT_ROOT}\target');
    deliverable = config.getElementsByTagName('build-deliverables').item(0).getElementsByTagName('file').item(0);
    deliverable.setAttribute('location', '${PROJECT_ROOT}');
    deliverable.setTextContent('${PROJECT_ROOT}\target');
    
    % Comment out unsetting the param.output.
    unsets = config.getElementsByTagName('unset').item(0);
    param = unsets.getElementsByTagName('param.output');
    if param.getLength() > 0
        param = param.item(0);
        comment = param.getOwnerDocument().createComment(param.getTextContent());
        unsets.replaceChild(comment, param);
    end
    
    % Comment out dependencies outside the project root folder because they're included with the toolbox.
    filedeps = config.getElementsByTagName('fileset.depfun').item(0);
    files = filedeps.getElementsByTagName('file');
    commentFiles = {};
    for i = 1:files.getLength()
        file = files.item(i-1);
        if ~strncmp(file.getTextContent(), '$', 1)
            commentFiles{end + 1} = file; %#ok<AGROW>
        end
    end
    
    for i = 1:numel(commentFiles)
        file = commentFiles{i};
        comment = file.getOwnerDocument().createComment(file.getTextContent());
        filedeps.replaceChild(comment, file);
    end

    % This adds a new line after each line in the XML
    %xmlwrite(projectFile, dom);
    
    domString = strrep(char(dom.saveXML(root)), 'encoding="UTF-16"', 'encoding="UTF-8"');
    fid = fopen(projectFile, 'w');
    fwrite(fid, domString);
    fclose(fid);
    
    matlab.apputil.package(projectFile);
end
